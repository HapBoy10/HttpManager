//
//  WYImageDownload.m
//  HttpManager
//
//  Created by tom on 13-6-15.
//  Copyright (c) 2013年 3TI. All rights reserved.
//

#import "WYImageDownload.h"



@interface WYImageDownload(){
 
    
    NSString *_diskHomePath;
}
@end

static WYImageDownload *g_imageDownload = nil;
static NSCache *g_cache = nil;

@implementation WYImageDownload

@synthesize delegate = _delegate;

-(id)init{
    if(self = [super init]){
    
        
        g_cache = [[NSCache alloc] init];
        g_cache.name = @"image";
        
        _diskHomePath = [WYCommonInfo getDirectoryCacheWithFileName:@"image"];
        if (![[NSFileManager defaultManager] fileExistsAtPath:_diskHomePath])
        {
            [[NSFileManager defaultManager] createDirectoryAtPath:_diskHomePath withIntermediateDirectories:YES attributes:nil error:NULL];
        }
    }

    return self;
}

+(WYImageDownload*)shareInstance{
    if(!g_imageDownload)
        g_imageDownload = [[self alloc] init];
    return g_imageDownload;
}

-(void)downLoadWithURL:(NSURL*)url {
    [self downLoadWithURL:url completion:nil failure:nil];
}

-(void)downLoadWithURL:(NSURL*)url completion:(WYImageCompletionBlock)completion failure:(WYImageFaileBlock)faile{
    [self downLoadWithURL:url  delegate:nil completion:completion failure:faile];
}


-(void)downLoadWithURL:(NSURL*)url  delegate:(id<WYImageDownloadDelegate>)delegate completion:(WYImageCompletionBlock)completion failure:(WYImageFaileBlock)faile{
    [self downLoadWithURL:url  delegate:delegate completion:completion failure:faile received:nil];
}

-(void)downLoadWithURL:(NSURL*)url delegate:(id<WYImageDownloadDelegate>)delegate completion:(WYImageCompletionBlock)completion failure:(WYImageFaileBlock)faile received:(WYImageReceivedBlock)received{
    
    
    WYImageCompletionBlock completionBlock = completion;
    WYImageFaileBlock faileBlock = faile;
    WYImageReceivedBlock receivedBlock = received;
    
    
    if([self isDisked:url]){//首先在磁盘和cache中查找是否存在，不存在就从网络上查找
        NSString *filePath = [_diskHomePath stringByAppendingPathComponent:[WYCommonInfo getHashCodeWithURL:url]];
        
        UIImage *image = [UIImage imageWithContentsOfFile:filePath];
        if(completionBlock)
            completionBlock(image);
        return;
    }
    
   __weak WYHttpRequest *request = [WYHttpRequest requestWithURL:url];
    
    [request setCompletionBlock:^(NSData *data){
                
        [self saveToLocal:[_diskHomePath stringByAppendingPathComponent:[WYCommonInfo getHashCodeWithURL:url]] withData:data];
        
        UIImage* image = [UIImage imageWithData:data];
        
        if([_delegate respondsToSelector:@selector(imageDownloadDidFinish:)])
            [_delegate imageDownloadDidFinish:self];
        
        if(completionBlock)
            completionBlock(image);
    }];
    
    [request setFailedBlock:^{
        if(faileBlock)//有可能是请求失败
            faileBlock();
    }];
    [request setReceivedBlock:^(NSData *data, long long curlength, long long total) {
        
        if(receivedBlock)
            receivedBlock(request.total);
    }];
    
    [request requestStart];
}


-(void)saveToLocal:(NSString*)fileName withData:(NSData*)data{

//    [[NSFileManager defaultManager] createFileAtPath:fileName contents:data attributes:nil];
    [data writeToFile:fileName atomically:YES];
}

-(BOOL)isDisked:(NSURL*)url{

    return [[NSFileManager defaultManager] fileExistsAtPath:[_diskHomePath stringByAppendingPathComponent:[WYCommonInfo getHashCodeWithURL:url]] isDirectory:NO];
}

@end



@implementation WYCommonInfo

+(NSString*)getDirectoryCache{
    
    return [WYCommonInfo getDirectoryCacheWithFileName:@""];
}
+(NSString*)getDirectoryCacheWithFileName:(NSString *)fileName{
    return [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:fileName];
}
+(NSString*)getDirectoryHome{
    return [WYCommonInfo getDirectoryHomeWithFileName:@""];
}
+(NSString*)getDirectoryHomeWithFileName:(NSString *)fileName{
    return [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:fileName];
}
+(NSString*)getHashCodeWithURL:(NSURL*)url{
    return [NSString stringWithFormat:@"%u",[[url debugDescription] hash]];
}
+(BOOL)isCached:(NSURL*)url{
    return [[NSFileManager defaultManager] fileExistsAtPath:[WYCommonInfo getHashCodeWithURL:url] isDirectory:NO];
}

@end