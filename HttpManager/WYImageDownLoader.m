#import "WYImageDownLoader.h"
#import <QuartzCore/QuartzCore.h>

@implementation WYImageDownLoader

static WYImageDownLoader * defaultCacher=nil;

-(id)init{

    self = [super init];
    
    _imageCache = [[NSCache alloc] init];
    [_imageCache setCountLimit:10];
    
    _homeDir = [self pathIndocument:@"image"];

    if([[NSFileManager defaultManager] fileExistsAtPath:_homeDir isDirectory:NO]){

    }else{
        
        [[NSFileManager defaultManager] createDirectoryAtPath:_homeDir withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    return self;
}

+(WYImageDownLoader*)shareInstance{
    
    if (!defaultCacher) {
        
        defaultCacher=[[self alloc] init];
    }
    
    return defaultCacher;
}

-(void)initWithUrl:(NSURL*)url imageView:(UIImageView*)imageView{
    
    if(![url absoluteString] || !imageView || ![url absoluteString].length)
        return;
    NSDictionary *aDic = [NSDictionary dictionaryWithObjectsAndKeys:url,@"url",imageView,@"view", nil];
    [NSThread detachNewThreadSelector:@selector(loadImage:) toTarget:self withObject:aDic];
}

-(void)loadImage:(NSDictionary*)aDic{
	
    @autoreleasepool {
    
        NSURL *url = [aDic valueForKey:@"url"];
        UIImageView *view = [aDic valueForKey:@"view"];
        
        NSData *data = [_imageCache objectForKey:[self hashToString:url]];//再cache中查询
        if(data && data.length){
            
            DLog(@"缓存中找到");
        }else if([self hasCachedImage:url]){
            data = [self fileWithName:url];
            DLog(@"磁盘中找到");
            [_imageCache setObject:data forKey:[self hashToString:url]];
        } else {
            
            DLog(@"网上拉:%@",[url absoluteString]);
            data = [NSData dataWithContentsOfURL:url ];
            
            if(!data || !data.length)
                return;
            
            [_imageCache setObject:data forKey:[self hashToString:url]];
        }
        
        [self saveToFile:url withData:data];
        UIImage *image = [UIImage imageWithData:data];
        
        if(view != nil){
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                CATransition *transtion = [CATransition animation];
                transtion.duration = 0.5;
                [transtion setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
                [transtion setType:@"oglFlip"];
                [transtion setSubtype:kCATransitionFromRight];
                [view.layer addAnimation:transtion forKey:@"transtionKey"];
                
                view.image = image;
            });
        }
        _isLoadFinished = YES;
    }
}

-(void)saveToFile:(NSURL *)fileName withData:(NSData *)data{
    
    [[NSFileManager defaultManager] createFileAtPath:[_homeDir stringByAppendingPathComponent:[self hashToString:fileName]] contents:data attributes:nil];
}

-(NSString *)pathIndocument:(NSString *)fileName{
    
    //获取沙盒中的文档目录
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentDirectory=[documentDirectories objectAtIndex:0];
    
    NSString *fullPath = [documentDirectory stringByAppendingPathComponent:fileName];
    
    return fullPath;
}

-(NSString *)hashToString:(NSURL *)url{
    
    return [NSString stringWithFormat:@"%u",[[url description] hash]];
}

-(NSData *)fileWithName:(NSURL *)url{
    
    return [[NSFileManager defaultManager] contentsAtPath:[_homeDir stringByAppendingPathComponent:[self hashToString:url]]];
}

-(BOOL)hasCachedImage:(NSURL *)url{   
    
    return [[NSFileManager defaultManager] fileExistsAtPath:[_homeDir stringByAppendingPathComponent:[self hashToString:url]]];
}

@end