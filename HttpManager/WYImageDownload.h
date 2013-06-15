//
//  WYImageDownload.h
//  HttpManager
//
//  Created by tom on 13-6-15.
//  Copyright (c) 2013年 3TI. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WYHttpRequest.h"

@class WYImageDownload;
@protocol WYImageDownloadDelegate <NSObject>
@optional
-(void)imageDownloadDidFinish:(WYImageDownload*)download;

@end

typedef void (^WYImageCompletionBlock)(UIImage *image);
typedef void (^WYImageFaileBlock)(void);
typedef void (^WYImageReceivedBlock)(long long total);;

@interface WYImageDownload : NSObject<WYHttpRequestDelegate>{

    WYImageCompletionBlock completionBlock;
    WYImageFaileBlock faileBlock;
    WYImageReceivedBlock receivedBlock;
}

+(WYImageDownload*)shareInstance;
@property(assign,nonatomic)id<WYImageDownloadDelegate>delegate;

-(void)downLoadWithURL:(NSURL*)url converTosize:(CGSize)size delegate:(id<WYImageDownloadDelegate>)delegate completion:(WYImageCompletionBlock)completion failure:(WYImageFaileBlock)faile;

-(void)downLoadWithURL:(NSURL*)url converTosize:(CGSize)size delegate:(id<WYImageDownloadDelegate>)delegate completion:(WYImageCompletionBlock)completion failure:(WYImageFaileBlock)faile received:(WYImageReceivedBlock)received;


-(void)setReceivedBlock:(WYImageReceivedBlock)aBlock;
-(void)setCompletionBlock:(WYImageCompletionBlock)aBlock;
-(void)setFailedBlock:(WYImageFaileBlock)aBlock;

@end



//基本信息
@interface WYCommonInfo : NSObject
+(NSString*)getDirectoryCache;
+(NSString*)getDirectoryCacheWithFileName:(NSString*)fileName;
+(NSString*)getDirectoryHome;
+(NSString*)getDirectoryHomeWithFileName:(NSString*)fileName;
+(NSString*)getHashCodeWithURL:(NSURL*)url;
+(BOOL)isCached:(NSURL*)url;//是否再缓存中查找到对应的值，
@end