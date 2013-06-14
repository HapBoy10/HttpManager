//
//  WYHttpRequest.h
//  HttpManager
//
//  Created by 3TI on 13-6-14.
//  Copyright (c) 2013年 3TI. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol WYHttpRequestDelegate <NSObject>

@optional
-(void)requestFailed:(NSURLConnection*)connection didFailWithError:(NSError *)error;

-(void)requestRcvData:(NSURLConnection*)connection didReceiveData:(NSData *)data curTotal:(NSMutableData*)curTotal;

-(void)requestFinish:(NSURLConnection*)connection totalData:(NSMutableData*)data;

@end



@interface WYHttpRequest : NSOperation

@property(assign) BOOL startImmediately;
@property(assign) NSTimeInterval requestTimeOut;
@property(nonatomic,retain) NSURL *requestURL;
@property(nonatomic,retain) NSString *requestMethod;
@property(nonatomic,retain) NSMutableData *requestBodyData;
@property(nonatomic,assign) id<WYHttpRequestDelegate>delegate;


#pragma mark
#pragma mark method
+(id)requestWithURL:(NSURL*)url;

-(id)initWithURL:(NSURL*)url;
-(void)requestStart;
-(void)requestCancel;
@end
