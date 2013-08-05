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
    unsigned long long _postLength;
}


@synthesize delegate = _delegate;
@synthesize requestMethod = _requestMethod;
@synthesize requestURL = _requestURL;
@synthesize requestBodyData = _requestBodyData;
@synthesize rspMutableData = _rspMutableData;
@synthesize total = _total;
<<<<<<< HEAD
@synthesize rspCode = _rspCode;
=======
@synthesize userInfo = _userInfo;
>>>>>>> 2e1050a903aed66efaeccdec7eaac9101a04c542

-(id)init{
	if(self == [super init]){
		_rspMutableData = [NSMutableData data];
        _requestBodyData = [NSMutableData data];
        
<<<<<<< HEAD
        
=======
>>>>>>> 2e1050a903aed66efaeccdec7eaac9101a04c542
        _postData = [NSMutableArray array];
        _requestMethod = @"GET";
        _startImmediately = YES;
        _postLength = 0;
        _requestTimeOut = 30.0f;
        
        g_queue = [[NSOperationQueue alloc] init];
        [g_queue setMaxConcurrentOperationCount:2];
        
	}
	return self;
}

+(NSOperationQueue*)shareOprationQueue{
    if(!g_queue){
        g_queue = [[NSOperationQueue alloc] init];
        [g_queue setMaxConcurrentOperationCount:2];
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

    [_requestConnection cancel];
}

-(void)requestCancelAll{
    
    [g_queue cancelAllOperations];
}

//测试post数据、
-(void)main{
	
    _request = [NSMutableURLRequest requestWithURL:_requestURL cachePolicy:NSURLCacheStorageAllowed timeoutInterval:[self requestTimeOut]];
    
    [self buildPostBody];
    
//    _postLength = [self setPostLength];
    
    if(_requestBodyData.length > 0){
    
        if([_requestMethod isEqualToString:@"GET"])
            _requestMethod = @"POST";
        
        [_request setHTTPBody:_requestBodyData];

    [_request setHTTPMethod:_requestMethod];
    
    if(![self isCancelled]){
        
        _requestConnection = [[NSURLConnection alloc] initWithRequest:_request delegate:self startImmediately:_startImmediately];

        while (_requestConnection != nil) {
            [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
        }
    }    
}

//接受到响应
-(void)connection:(NSURLConnection*)connection didReceiveResponse:(NSURLResponse *)response{
    return;
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
<<<<<<< HEAD
//请求失败
=======

>>>>>>> 2e1050a903aed66efaeccdec7eaac9101a04c542
-(void)connection:(NSURLConnection*)connection didFailWithError:(NSError *)error{
    NSLog(@"didFailWithError:%@,%@",error,_request.URL);
    _rspCode = error.code;
    if([_delegate respondsToSelector:@selector(requestFailed:didFailWithError:)])
        [_delegate requestFailed:self didFailWithError:error];
    
    if(failedBlock)
        failedBlock();
}

//接受到数据
-(void)connection:(NSURLConnection*)connection didReceiveData:(NSData *)data{
    
    [_rspMutableData appendData:data];
    if([_delegate respondsToSelector:@selector(requestRcvData:didReceiveData:curlength:total:)])
        [_delegate requestRcvData:self didReceiveData:data curlength:_rspMutableData.length total:_total];
    
    if(receivedBlock){
        receivedBlock(data,_rspMutableData.length,_total);
    }
}

//数据接收完成
-(void)connectionDidFinishLoading:(NSURLConnection*)connection{
    
    if([_delegate respondsToSelector:@selector(requestFinish:totalData:)])
        [_delegate requestFinish:self totalData:_rspMutableData];
    
    if(completionBlock)
        completionBlock();
}

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

- (void)setPostValue:(id <NSObject>)value forKey:(NSString *)key
{
	// Remove any existing value
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

<<<<<<< HEAD
-(void)buildPostBody{
    
//    [_requestBodyData appendData:[self mutableArrayToData]];
    
    NSString *myBoundary=@"0xKhTmLbOuNdArY";//这个很重要，用于区别输入的域
    NSString *myContent=[NSString stringWithFormat:@"multipart/form-data;boundary=%@",myBoundary];//意思是要提交的是表单数据
    
    [_request setValue:myContent forHTTPHeaderField:@"Content-type"];//定义内容类型
    
    [_requestBodyData appendData:[[NSString stringWithFormat:@"\n--%@\n",myBoundary] dataUsingEncoding:NSUTF8StringEncoding]];//表示开始
=======
//表单提交
-(void)buildPostBody{
        
    NSString *boundary=@"0xKhTmLbOuNdArY";//这个很重要，用于区别输入的域
    NSString *content=[NSString stringWithFormat:@"multipart/form-data;boundary=%@",boundary];//意思是要提交的是表单数据
    
    [_request setValue:content forHTTPHeaderField:@"Content-type"];//定义内容类型
    
    [_requestBodyData appendData:[[NSString stringWithFormat:@"\n--%@\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];//表示开始
>>>>>>> 2e1050a903aed66efaeccdec7eaac9101a04c542
    
    NSMutableArray *keys = [NSMutableArray arrayWithCapacity:10];
    NSMutableArray *values = [NSMutableArray arrayWithCapacity:10];
    
    for (NSMutableDictionary * aDic in _postData) {
        [keys addObject:[aDic valueForKey:@"key"]];
        [values addObject:[aDic valueForKey:@"value"]];
    }
    
<<<<<<< HEAD
    NSString *endItemBoundary = [NSString stringWithFormat:@"\r\n--%@\r\n",myBoundary];
=======
    NSString *endItemBoundary = [NSString stringWithFormat:@"\r\n--%@\r\n",boundary];
>>>>>>> 2e1050a903aed66efaeccdec7eaac9101a04c542
    for (int i = 0; i < keys.count; i++) {
        
        NSLog(@"key=%@,value=%@",[keys objectAtIndex:i],[values objectAtIndex:i]);
        
        [_requestBodyData appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n",[keys objectAtIndex:i]] dataUsingEncoding:NSUTF8StringEncoding]];
        
        [_requestBodyData appendData:[[values objectAtIndex:i] dataUsingEncoding:NSUTF8StringEncoding]];
        
        if(i != keys.count - 1)
            [_requestBodyData appendData:[endItemBoundary dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
<<<<<<< HEAD
    [_requestBodyData appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",myBoundary] dataUsingEncoding:NSUTF8StringEncoding]];//结束
=======
    [_requestBodyData appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];//结束
>>>>>>> 2e1050a903aed66efaeccdec7eaac9101a04c542
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
-(void)setReceivedBlock:(WYHttpDataBlock)aBlock{
    receivedBlock = [aBlock copy];
}
-(void)setCompletionBlock:(WYHttpBasicBlock)aBlock{
    completionBlock = [aBlock copy];
}
-(void)setFailedBlock:(WYHttpBasicBlock)aBlock{
    failedBlock = [aBlock copy];
}

@end
