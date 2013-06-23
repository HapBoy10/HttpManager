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
    NSString *_diskHomePath;
}
@end

static WYImageDownload *g_imageDownload = nil;
static NSCache *g_cache = nil;

@implementation WYImageDownload

@synthesize delegate = _delegate;

-(id)init{
    if(self = [super init]){
    
        _imageSize = CGSizeZero;
        
        g_cache = [[NSCache alloc] init];
        g_cache.name = @"imageHome";
        
        _diskHomePath = [WYCommonInfo getDirectoryHome];
        _diskHomePath = [_diskHomePath stringByAppendingPathComponent:@"imageHome"];
        if (![[NSFileManager defaultManager] fileExistsAtPath:_diskHomePath])
        {
            [[NSFileManager defaultManager] createDirectoryAtPath:_diskHomePath withIntermediateDirectories:YES attributes:nil error:NULL];
        }
    }
<<<<<<< HEAD
=======
    
>>>>>>> 2e1050a903aed66efaeccdec7eaac9101a04c542
    return self;
}

+(WYImageDownload*)shareInstance{
    if(!g_imageDownload)
        g_imageDownload = [[self alloc] init];
    return g_imageDownload;
}

-(void)downLoadWithURL:(NSURL*)url converTosize:(CGSize)size  completion:(WYImageCompletionBlock)completion failure:(WYImageFaileBlock)faile{
    [self downLoadWithURL:url converTosize:size delegate:nil completion:completion failure:faile];
}


-(void)downLoadWithURL:(NSURL*)url converTosize:(CGSize)size delegate:(id<WYImageDownloadDelegate>)delegate completion:(WYImageCompletionBlock)completion failure:(WYImageFaileBlock)faile{
    [self downLoadWithURL:url converTosize:size delegate:delegate completion:completion failure:faile received:nil];
}

-(void)downLoadWithURL:(NSURL*)url converTosize:(CGSize)size delegate:(id<WYImageDownloadDelegate>)delegate completion:(WYImageCompletionBlock)completion failure:(WYImageFaileBlock)faile received:(WYImageReceivedBlock)received{
    
    _imageURL = url;
    _imageSize = size;
    
<<<<<<< HEAD
    WYImageCompletionBlock completionBlock = completion;
    WYImageFaileBlock faileBlock = faile;
    WYImageReceivedBlock receivedBlock = received;
        
    if([self isDisked:url]){//首先在磁盘和cache中查找是否存在，不存在就从网络上查找
        NSString *filePath = [_diskHomePath stringByAppendingPathComponent:[@"big_" stringByAppendingString:[WYCommonInfo getHashCodeWithURL:url]]];
        
        UIImage *image = [UIImage imageWithContentsOfFile:filePath];
        if(completionBlock)
            completionBlock(image);
        return;
    }
    
   __weak WYHttpRequest *request = [WYHttpRequest requestWithURL:url];
=======
    self.delegate = delegate;
>>>>>>> 2e1050a903aed66efaeccdec7eaac9101a04c542
    
    [request setCompletionBlock:^{
        UIImage* image = [self converImageToSize:_imageSize data:request.rspMutableData];
        
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

-(UIImage *)converImageToSize:(CGSize)size data:(NSMutableData*)data{
    
    if(data.length == 0 || !data)
        return nil;
    
<<<<<<< HEAD
    [self saveToLocal:[_diskHomePath stringByAppendingPathComponent:[@"big_" stringByAppendingString:[WYCommonInfo getHashCodeWithURL:_imageURL]]] withData:data];
    
    if(CGSizeEqualToSize(_imageSize, CGSizeZero))
=======
    if(CGSizeEqualToSize(size, CGSizeZero))
>>>>>>> 2e1050a903aed66efaeccdec7eaac9101a04c542
    {
        
        return [UIImage imageWithData:data];
    }
    else
    {
<<<<<<< HEAD
=======
        [self saveToLocal:[WYCommonInfo getDirectoryHomeWithFileName:[@"big_" stringByAppendingString:[WYCommonInfo getHashCodeWithURL:_imageURL]]] withData:data];//原图
        

>>>>>>> 2e1050a903aed66efaeccdec7eaac9101a04c542
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
        
        NSData *smallData=UIImageJPEGRepresentation(small, 1.0);
        
<<<<<<< HEAD
        [self saveToLocal:[_diskHomePath stringByAppendingPathComponent:[@"small_" stringByAppendingString:[WYCommonInfo getHashCodeWithURL:_imageURL]]] withData:smallData];//原图
        return nil;
=======
        [self saveToLocal:[WYCommonInfo getDirectoryHomeWithFileName:[@"small_" stringByAppendingString:[WYCommonInfo getHashCodeWithURL:_imageURL]]] withData:smallData];//小图
        return [UIImage imageWithData:smallData];
>>>>>>> 2e1050a903aed66efaeccdec7eaac9101a04c542
    }
}

-(void)saveToLocal:(NSString*)fileName withData:(NSData*)data{

    [[NSFileManager defaultManager] createFileAtPath:fileName contents:data attributes:nil];
}

-(BOOL)isDisked:(NSURL*)url{

    if([[NSFileManager defaultManager] fileExistsAtPath:[_diskHomePath stringByAppendingPathComponent:[@"big_" stringByAppendingString:[WYCommonInfo getHashCodeWithURL:url]]] isDirectory:NO])
        return YES;
    return NO;
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