//
//  WYHttpRequest.m
//  HttpManager
//
//  Created by 3TI on 13-6-14.
//  Copyright (c) 2013年 3TI. All rights reserved.
//

#import "WYHttpRequest.h"


static NSOperationQueue *g_queue = nil;

@implementation WYHttpRequest{
    
    NSMutableURLRequest *_request;
    NSURLConnection *_requestConnection;
    
    NSMutableArray *_postData;
    NSMutableArray *_headerData;
    unsigned long long _postLength;
}


@synthesize delegate = _delegate;
@synthesize requestMethod = _requestMethod;
@synthesize requestURL = _requestURL;
@synthesize requestBodyData = _requestBodyData;
@synthesize rspMutableData = _rspMutableData;
@synthesize total = _total;
@synthesize rspCode = _rspCode;
@synthesize userInfo = _userInfo;

-(id)init{
	if(self == [super init]){
		_rspMutableData = [NSMutableData data];
        _requestBodyData = [NSMutableData data];
        
        _postData = [NSMutableArray array];
        _headerData = [NSMutableArray array];
        
        _requestMethod = @"GET";
        _startImmediately = YES;
        _postLength = 0;
        _requestTimeOut = 60.0f;
        
        g_queue = [[NSOperationQueue alloc] init];
        [g_queue setMaxConcurrentOperationCount:5];
        
	}
	return self;
}

+(NSOperationQueue*)shareOprationQueue{
    if(!g_queue){
        
        g_queue = [[NSOperationQueue alloc] init];
        [g_queue setMaxConcurrentOperationCount:5];
    }
    return g_queue;
}

+(id)requestWithURL:(NSURL *)url{
    return [[self alloc] initWithURL:url];
}

-(id)initWithURL:(NSURL *)url{
    
    self = [self init];
    
    [self setRequestURL:url];
    
    return self;
}

-(BOOL)isConcurrent {

  return YES;//返回yes表示支持异步调用，否则为支持同步调用

}

-(void)requestStart{
    [g_queue addOperation:self];
}
-(void)requestCancel{

    [g_queue cancelAllOperations];
}

-(void)requestCancelAll{
    
    [g_queue cancelAllOperations];
}

//测试post数据、
-(void)main{
	
    _request = [NSMutableURLRequest requestWithURL:_requestURL cachePolicy:NSURLCacheStorageNotAllowed timeoutInterval:[self requestTimeOut]];
    
    //form 表单提交
    [self buildPostBody];
    
    
    if(_requestBodyData.length > 0){
    
        if([_requestMethod isEqualToString:@"GET"])
            _requestMethod = @"POST";
        
        [_request setHTTPBody:_requestBodyData];

        [self addHeaderValue:[NSString stringWithFormat:@"%d",_requestBodyData.length] forKey:@"Content-Length"];
    }

    [self buildHeader];
    
    [_request setHTTPMethod:_requestMethod];
    [_request setTimeoutInterval:-1];
    if(![self isCancelled]){
        
        _requestConnection = [[NSURLConnection alloc] initWithRequest:_request delegate:self startImmediately:_startImmediately];

        while (_requestConnection != nil) {
            [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
        }
    }    
}


#pragma mark -- delegate start
//请求失败
-(void)connection:(NSURLConnection*)connection didFailWithError:(NSError *)error{

    _rspCode = error.code;
    if([_delegate respondsToSelector:@selector(requestFailed:didFailWithError:)])
        [_delegate requestFailed:self didFailWithError:error];
    
    if(failedBlock)
        failedBlock();
}

-(void)connection:(NSURLConnection*)connection didReceiveData:(NSData *)data{
    
    [_rspMutableData appendData:data];
    if([_delegate respondsToSelector:@selector(requestRcvData:didReceiveData:curlength:total:)])
        [_delegate requestRcvData:self didReceiveData:data curlength:_rspMutableData.length total:_total];
    
    if(receivedBlock){
        receivedBlock(data,_rspMutableData.length,_total);
    }
}

//接受到响应
-(void)connection:(NSURLConnection*)connection didReceiveResponse:(NSURLResponse *)response{
    
    _rspCode = [((NSHTTPURLResponse *)response) statusCode];
    NSDictionary *dic = [((NSHTTPURLResponse *)response) allHeaderFields];
    NSLog(@"didReceiveResponse:%@",dic);
    
    //    [data writeToFile:path atomically:YES];
    return;
    
    //判断请求数据是否为空
    if(![response respondsToSelector:@selector(statusCode)] || [((NSHTTPURLResponse *)response) statusCode] < 400){
        _total = [response expectedContentLength] > 0 ? [response expectedContentLength] : 0;
        if(_total == 0) {
            [_requestConnection cancel];
            [self cancel];
            return;
        }
    } else {
        [_requestConnection cancel];
        [self cancel];
        
        if([_delegate respondsToSelector:@selector(requestFailed:didFailWithError:)])
            [_delegate requestFailed:self didFailWithError:[NSError errorWithDomain:@"" code:[((NSHTTPURLResponse *)response) statusCode] userInfo:nil]];
        
        if(failedBlock)
            failedBlock();
    }
}

//发送数据
- (void)connection:(NSURLConnection *)connection didSendBodyData:(NSInteger)bytesWritten totalBytesWritten:(NSInteger)totalBytesWritten totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite{

    float percent = totalBytesWritten * 100 / totalBytesExpectedToWrite;
    DLog(@"%f",percent);
    if([_delegate respondsToSelector:@selector(requestSendData:percent:)])
        [_delegate requestSendData:self percent:percent];
    
    if(sendBlock)
        sendBlock(percent);
}

//数据接收完成
-(void)connectionDidFinishLoading:(NSURLConnection*)connection{
    
    DLog(@"%@",[[NSString alloc] initWithData:_rspMutableData encoding:NSUTF8StringEncoding]);
    
    if([_delegate respondsToSelector:@selector(requestFinish:totalData:)])
        [_delegate requestFinish:self totalData:_rspMutableData];
    
    if(completionBlock)
        completionBlock(_rspMutableData);
}

#pragma mark -- delegate end


- (void)addPostValue:(id <NSObject>)value forKey:(NSString *)key{
	if (!key) {
		return;
	}
	if (!_postData) {
        _postData = [NSMutableArray array];
	}
	NSMutableDictionary *keyValuePair = [NSMutableDictionary dictionaryWithCapacity:2];
	[keyValuePair setValue:key forKey:@"key"];
	[keyValuePair setValue:[value description] forKey:@"value"];
	[_postData addObject:keyValuePair];
}

- (void)setPostValue:(id <NSObject>)value forKey:(NSString *)key{

	NSUInteger i;
	for (i=0; i<[_postData count]; i++) {
		NSDictionary *val = [_postData objectAtIndex:i];
		if ([[val objectForKey:@"key"] isEqualToString:key]) {
			[_postData removeObjectAtIndex:i];
			i--;
		}
	}
	[self addPostValue:value forKey:key];
}

- (void)addHeaderValue:(id <NSObject>)value forKey:(NSString *)key{
    
    if (!key) {
		return;
	}
    
    if(nil == _headerData){
        _headerData = [NSMutableArray array];
    }
    
    NSMutableDictionary *keyValuePair = [NSMutableDictionary dictionaryWithCapacity:2];
	[keyValuePair setValue:key forKey:@"key"];
	[keyValuePair setValue:[value description] forKey:@"value"];
	[_headerData addObject:keyValuePair];
}

- (void)setHeaderValue:(id <NSObject>)value forKey:(NSString *)key{
    
    NSUInteger i;
	for (i=0; i<[_postData count]; i++) {
		NSDictionary *val = [_headerData objectAtIndex:i];
		if ([[val objectForKey:@"key"] isEqualToString:key]) {
			[_headerData removeObjectAtIndex:i];
			i--;
		}
	}
    
    [self addHeaderValue:value forKey:key];
}

-(void)buildHeader{

    for (NSDictionary *aDic in _headerData) {
        
        [_request setValue:[aDic valueForKey:@"value"] forHTTPHeaderField:[aDic valueForKey:@"key"]];
    }
    
}

-(void)buildPostBody{
    
    if(nil == _postData || !_postData.count)
        return;
        
    NSMutableArray *keys = [NSMutableArray arrayWithCapacity:10];
    NSMutableArray *values = [NSMutableArray arrayWithCapacity:10];
    
    for (NSMutableDictionary * aDic in _postData) {
        [keys addObject:[aDic valueForKey:@"key"]];
        [values addObject:[aDic valueForKey:@"value"]];
    }
    
    NSString *boundary=@"0xKhTmLbOuNdArY";//这个很重要，用于区别输入的域
    NSString *content=[NSString stringWithFormat:@"multipart/form-data;boundary=%@",boundary];//意思是要提交的是表单数据
    
    [_request setValue:content forHTTPHeaderField:@"Content-type"];//定义内容类型
    
    [_requestBodyData appendData:[[NSString stringWithFormat:@"\n--%@\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];//表示开始    
    
    NSString *endItemBoundary = [NSString stringWithFormat:@"\r\n--%@\r\n",boundary];
    for (int i = 0; i < keys.count; i++) {
                
        [_requestBodyData appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n",[keys objectAtIndex:i]] dataUsingEncoding:NSUTF8StringEncoding]];
        
        [_requestBodyData appendData:[[values objectAtIndex:i] dataUsingEncoding:NSUTF8StringEncoding]];
        
        if(i != keys.count - 1)
            [_requestBodyData appendData:[endItemBoundary dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    [_requestBodyData appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];//结束
}

-(unsigned long long)setPostLength{
    unsigned long long count = 0;
    count = _requestBodyData.length;
    return count;
}

-(NSData*)mutableArrayToData{
    
    return [NSKeyedArchiver archivedDataWithRootObject:_postData];
}

-(void)setStrartBlock:(WYHttpBasicBlock)aBlock{
    strartBlock = [aBlock copy];
}
-(void)setReceivedBlock:(WYHttpDownBlock)aBlock{
    receivedBlock = [aBlock copy];
}
-(void)setCompletionBlock:(WYHttpComplete)aBlock{
    completionBlock = [aBlock copy];
}
-(void)setFailedBlock:(WYHttpBasicBlock)aBlock{
    failedBlock = [aBlock copy];
}

-(void)setSendDataBlock:(WYHttpSendPercentBlock)aBlock{
    sendBlock = [aBlock copy];
}

@end
