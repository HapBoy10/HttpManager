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
}


@synthesize delegate = _delegate;
@synthesize requestMethod = _requestMethod;
@synthesize requestURL = _requestURL;
@synthesize requestBodyData = _requestBodyData;
@synthesize rspMutableData = _rspMutableData;
@synthesize total = _total;
@synthesize rspCode = _rspCode;

-(id)init{
	if(self == [super init]){
		_rspMutableData = [NSMutableData data];
        _requestMethod = @"GET";
        _startImmediately = YES;
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
-(void)setHeadInfo :(NSMutableURLRequest*)request{
    if(_requestBodyData.length && _requestBodyData != nil){
        [_request setHTTPBody:(NSData*)_requestBodyData];
    }
}


//测试post数据、
-(void)main{
	
    _request = [NSMutableURLRequest requestWithURL:_requestURL cachePolicy:NSURLCacheStorageAllowed timeoutInterval:[self requestTimeOut]];
    [_request setHTTPMethod:_requestMethod];
    
    [self setHeadInfo:_request];
    if(![self isCancelled]){
        
        _requestConnection = [[NSURLConnection alloc] initWithRequest:_request delegate:self startImmediately:_startImmediately];
        while (_requestConnection != nil) {
            [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
        }
    }    
}

//接受到响应
-(void)connection:(NSURLConnection*)connection didReceiveResponse:(NSURLResponse *)response{
    
    _rspCode = [((NSHTTPURLResponse *)response) statusCode];
    NSDictionary *dic = [((NSHTTPURLResponse *)response) allHeaderFields];
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
//请求失败
-(void)connection:(NSURLConnection*)connection didFailWithError:(NSError *)error
{
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
