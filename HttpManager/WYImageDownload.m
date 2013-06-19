//
//  WYImageDownload.m
//  HttpManager
//
//  Created by tom on 13-6-15.
//  Copyright (c) 2013年 3TI. All rights reserved.
//

#import "WYImageDownload.h"



@interface WYImageDownload(){
 
    CGSize _imageSize;
    NSURL *_imageURL;
    NSString *_diskCachePath;
    NSString *_diskHomePath;
}
@end

static WYImageDownload *g_imageDownload = nil;
static NSCache *g_cache = nil;

@implementation WYImageDownload

@synthesize delegate = _delegate;

-(id)init{
    self = [super init];
    
    _imageSize = CGSizeZero;
    
    g_cache = [[NSCache alloc] init];
    g_cache.name = @"imageHome";
    
    _diskHomePath = [WYCommonInfo getDirectoryHome];
    _diskHomePath = [_diskHomePath stringByAppendingPathComponent:@"imageHome"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:_diskHomePath])
    {
        [[NSFileManager defaultManager] createDirectoryAtPath:_diskHomePath withIntermediateDirectories:YES attributes:nil error:NULL];
    }
    
    return self;
}

+(WYImageDownload*)shareInstance{
    if(!g_imageDownload)
        g_imageDownload = [[[self class] alloc] init];
    return g_imageDownload;
}

-(void)downLoadWithURL:(NSURL*)url converTosize:(CGSize)size delegate:(id<WYImageDownloadDelegate>)delegate completion:(WYImageCompletionBlock)completion failure:(WYImageFaileBlock)faile{
    [self downLoadWithURL:url converTosize:size delegate:delegate completion:completion failure:faile received:nil];
}

-(void)downLoadWithURL:(NSURL*)url converTosize:(CGSize)size delegate:(id<WYImageDownloadDelegate>)delegate completion:(WYImageCompletionBlock)completion failure:(WYImageFaileBlock)faile received:(WYImageReceivedBlock)received{
    
    
    _imageURL = url;
    
    _imageSize = size;
    
    
    self.delegate = delegate;
    
    //首先在磁盘和cache中查找是否存在，不存在就从网络上查找
    WYHttpRequest *request = [WYHttpRequest requestWithURL:url];
    request.delegate = self;
    
    [request requestStart];
}

-(void)requestFinish:(WYHttpRequest *)request totalData:(NSMutableData *)data{
    
    //这个地方肯定是有数据
    UIImage* image = [self converImageToSize:_imageSize data:data];
    if([_delegate respondsToSelector:@selector(imageDownloadDidFinish:)])
        [_delegate imageDownloadDidFinish:self];
    
    if(completionBlock)
        completionBlock(image);
}
-(void)requestFailed:(WYHttpRequest *)request didFailWithError:(NSError *)error{
    if(faileBlock)//有可能是请求失败
        faileBlock();
}

-(void)requestRcvData:(WYHttpRequest *)request didReceiveData:(NSData *)data curTotal:(NSMutableData *)curTotal{

    if(receivedBlock)
        receivedBlock(request.total);
}

-(UIImage *)converImageToSize:(CGSize)size data:(NSMutableData*)data{
    
    if(data.length == 0 || !data)
        return nil;
    
    if(CGSizeEqualToSize(_imageSize, CGSizeZero))
    {
        return [UIImage imageWithData:data];
    }
    else
    {
        [self saveToLocal:[WYCommonInfo getDirectoryHomeWithFileName:[@"big_" stringByAppendingString:[WYCommonInfo getHashCodeWithURL:_imageURL]]] withData:data];//原图
        
        
        UIImage *image = [UIImage imageWithData:data];
        
        CGSize origImageSize= [image size];
        
        CGRect newRect;
        newRect.origin= CGPointZero;
        //拉伸到多大
        newRect.size.width=size.width;
        newRect.size.height=size.height;
        
        //缩放倍数
        float ratio = MIN(newRect.size.width/origImageSize.width, newRect.size.height/origImageSize.height);
        
        
        UIGraphicsBeginImageContext(newRect.size);
        
        
        CGRect projectRect;
        projectRect.size.width =ratio * origImageSize.width;
        projectRect.size.height=ratio * origImageSize.height;
        projectRect.origin.x= (newRect.size.width -projectRect.size.width)/2.0;
        projectRect.origin.y= (newRect.size.height-projectRect.size.height)/2.0;
        
        [image drawInRect:projectRect];
        
        UIImage *small = UIGraphicsGetImageFromCurrentImageContext();
        
        //压缩比例
        
        NSData *smallData=UIImageJPEGRepresentation(small, 0.2);
        
        [self saveToLocal:[WYCommonInfo getDirectoryHomeWithFileName:[@"small_" stringByAppendingString:[WYCommonInfo getHashCodeWithURL:_imageURL]]] withData:smallData];//原图
        return nil;
    }
}

-(void)saveToLocal:(NSString*)fileName withData:(NSData*)data{

    [[NSFileManager defaultManager] createFileAtPath:fileName contents:data attributes:nil];
}


-(void)setReceivedBlock:(WYImageReceivedBlock)aBlock{
    receivedBlock = [aBlock copy];
}
-(void)setCompletionBlock:(WYImageCompletionBlock)aBlock{
    completionBlock = [aBlock copy];
}
-(void)setFailedBlock:(WYImageFaileBlock)aBlock{
    faileBlock = [aBlock copy];
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
    if([[NSFileManager defaultManager] fileExistsAtPath:[WYCommonInfo getHashCodeWithURL:url] isDirectory:NO]){
        return YES;
    }
    return NO;
}

@end