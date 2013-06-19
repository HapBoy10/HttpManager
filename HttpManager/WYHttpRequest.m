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

-(id)init{
	if(self == [super init]){
		_rspMutableData = [NSMutableData data];
        _requestBodyData = [NSMutableData data];
        
        
        _postData = [NSMutableArray array];
        _requestMethod = @"GET";
        _startImmediately = YES;
        _postLength = 0;
        _requestTimeOut = 30.0f;
        
        g_queue = [[NSOperationQueue alloc] init];
        [g_queue setMaxConcurrentOperationCount:4];
        
	}
	return self;
}

+(NSOperationQueue*)shareOprationQueue{
    if(!g_queue){
        g_queue = [[NSOperationQueue alloc] init];
        [g_queue setMaxConcurrentOperationCount:4];
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
    }
    
    [_request setHTTPMethod:_requestMethod];
    
    if(![self isCancelled]){
        
        _requestConnection = [[NSURLConnection alloc] initWithRequest:_request delegate:self startImmediately:_startImmediately];
        while (_requestConnection != nil) {
            [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
        }
    }    
}


-(void)connection:(NSURLConnection*)connection didReceiveResponse:(NSURLResponse *)response{
//    NSLog(@"didReceiveResponse:%@,%d",((NSHTTPURLResponse *)response).allHeaderFields,[((NSHTTPURLResponse *)response) statusCode]);
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

-(void)connection:(NSURLConnection*)connection didFailWithError:(NSError *)error{
    NSLog(@"didFailWithError:%@,%@",error,_request.URL);
    if([_delegate respondsToSelector:@selector(requestFailed:didFailWithError:)])
        [_delegate requestFailed:self didFailWithError:error];
    
    if(failedBlock)
        failedBlock();
}

-(void)connection:(NSURLConnection*)connection didReceiveData:(NSData *)data{
    
    [_rspMutableData appendData:data];
    if([_delegate respondsToSelector:@selector(requestRcvData:didReceiveData:curTotal:)])
        [_delegate requestRcvData:self didReceiveData:data curTotal:_rspMutableData];
    
    if(receivedBlock){
        receivedBlock(data,_rspMutableData);
    }
    NSLog(@"didReceiveData:%@,%d",_request.URL,_rspMutableData.length);
}

-(void)connectionDidFinishLoading:(NSURLConnection*)connection{
    NSLog(@"connectionDidFinishLoading:%@",_request.URL);
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

-(void)buildPostBody{
        
    NSString *boundary=@"0xKhTmLbOuNdArY";//这个很重要，用于区别输入的域
    NSString *content=[NSString stringWithFormat:@"multipart/form-data;boundary=%@",boundary];//意思是要提交的是表单数据
    
    [_request setValue:content forHTTPHeaderField:@"Content-type"];//定义内容类型
    
    [_requestBodyData appendData:[[NSString stringWithFormat:@"\n--%@\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];//表示开始
    
    NSMutableArray *keys = [NSMutableArray arrayWithCapacity:10];
    NSMutableArray *values = [NSMutableArray arrayWithCapacity:10];
    
    for (NSMutableDictionary * aDic in _postData) {
        [keys addObject:[aDic valueForKey:@"key"]];
        [values addObject:[aDic valueForKey:@"value"]];
    }
    
    NSString *endItemBoundary = [NSString stringWithFormat:@"\r\n--%@\r\n",boundary];
    for (int i = 0; i < keys.count; i++) {
        
        NSLog(@"key=%@,value=%@",[keys objectAtIndex:i],[values objectAtIndex:i]);
        
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
