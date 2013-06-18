//
//  WYHttpRequest.h
//  HttpManager
//
//  Created by 3TI on 13-6-14.
//  Copyright (c) 2013年 3TI. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WYHttpRequest;
@protocol WYHttpRequestDelegate <NSObject>

@optional


-(void)requestFailed:(WYHttpRequest*)request didFailWithError:(NSError *)error;

-(void)requestRcvData:(WYHttpRequest*)request didReceiveData:(NSData *)data curlength:(long long)curlength total:(long long)total;

-(void)requestFinish:(WYHttpRequest*)request totalData:(NSMutableData*)data;

@end

typedef void (^WYHttpBasicBlock)(void);
typedef void (^WYHttpDataBlock)(NSData *data ,long long curlength,long long total);

@interface WYHttpRequest : NSOperation{

    WYHttpBasicBlock strartBlock;
    WYHttpDataBlock receivedBlock;
    WYHttpBasicBlock completionBlock;
    WYHttpBasicBlock failedBlock;
    
}

@property(assign) long long total;
@property(assign) BOOL startImmediately;
@property(assign) NSTimeInterval requestTimeOut;
@property(assign) NSInteger rspCode;




@property(nonatomic,retain) NSURL *requestURL;
@property(nonatomic,retain) NSString *requestMethod;
@property(nonatomic,retain) NSMutableData *requestBodyData;
@property(nonatomic,readonly,retain) NSMutableData *rspMutableData;
@property(nonatomic,assign) id<WYHttpRequestDelegate>delegate;


-(void)setStrartBlock:(WYHttpBasicBlock)aBlock;//暂时还没用到
-(void)setReceivedBlock:(WYHttpDataBlock)aBlock;
-(void)setCompletionBlock:(WYHttpBasicBlock)aBlock;
-(void)setFailedBlock:(WYHttpBasicBlock)aBlock;

- (void)setPostValue:(id <NSObject>)value forKey:(NSString *)key;
- (void)addPostValue:(id <NSObject>)value forKey:(NSString *)key;


#pragma mark
#pragma mark method
+(id)requestWithURL:(NSURL*)url;
+(NSOperationQueue*)shareOprationQueue;

-(id)initWithURL:(NSURL*)url;
-(void)requestStart;
-(void)requestCancel;
@end
