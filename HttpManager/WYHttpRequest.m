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
    
    
    NSMutableData *_rspMutableData;
    NSMutableURLRequest *_request;
    NSURLConnection *_requestConnection;
}


@synthesize delegate = _delegate;
@synthesize requestMethod = _requestMethod;
@synthesize requestURL = _requestURL;
@synthesize requestBodyData = _requestBodyData;

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
+(id)requestWithURL:(NSURL *)url{
    return [[self alloc] initWithURL:url];
}

-(id)initWithURL:(NSURL *)url{
    
    
    self = [self init];
    [self setRequestURL:url];
    return self;
}

-(void)requestStart{
    NSLog(@"%d",g_queue.operationCount);
    [g_queue addOperation:self];//添加近队列
//    [self start];
}
-(void)requestCancel{

    [_requestConnection cancel];
}

-(void)requestCancelAll{
    
    [g_queue cancelAllOperations];
}

-(void)main{
	
    _request = [NSMutableURLRequest requestWithURL:_requestURL cachePolicy:NSURLCacheStorageAllowed timeoutInterval:[self requestTimeOut]];
    [_request setHTTPMethod:_requestMethod];
	_requestConnection = [[NSURLConnection alloc] initWithRequest:_request delegate:self startImmediately:_startImmediately];
    [_requestConnection start];
    NSLog(@"%f,%d",[self requestTimeOut],g_queue.operationCount);
}

-(void)connection:(NSURLConnection*)connection didReceiveResponse:(NSURLResponse *)response{
    NSLog(@"didReceiveResponse");
}

-(void)connection:(NSURLConnection*)connection didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError");
    if([_delegate respondsToSelector:@selector(requestFailed:didFailWithError:)])
        [_delegate requestFailed:connection didFailWithError:error];
}

-(void)connection:(NSURLConnection*)connection didReceiveData:(NSData *)data{
    NSLog(@"didReceiveData");
    [_rspMutableData appendData:data];
    if([_delegate respondsToSelector:@selector(requestRcvData:didReceiveData:curTotal:)])
        [_delegate requestRcvData:connection didReceiveData:data curTotal:_rspMutableData];
}

-(void)connectionDidFinishLoading:(NSURLConnection*)connection{
    NSLog(@"connectionDidFinishLoading");
    if([_delegate respondsToSelector:@selector(requestFinish:totalData:)])
        [_delegate requestFinish:connection totalData:_rspMutableData];
}

@end
