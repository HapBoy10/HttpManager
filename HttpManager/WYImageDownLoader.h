
#import <Foundation/Foundation.h>

@interface WYImageDownLoader : NSObject{

    NSString *_homeDir;
    NSCache *_imageCache ;
    BOOL *_isLoadFinished;
}

+(WYImageDownLoader*)shareInstance;
-(void)initWithUrl:(NSURL*)url imageView:(UIImageView*)imageView;
@end
