//
//  UIImageView+WYNetKitAdditions.m
//  WYNetKitDemo
//
//  Created by Mugunth Kumar (@mugunthkumar) on 18/01/13.
//  Copyright (C) 2011-2020 by Steinlogic Consulting and Training Pte Ltd

//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

#import "UIImageView+WYNetKitAdditions.h"

#import "WYNetEngine.h"

#import <objc/runtime.h>

static WYNetEngine *DefaultEngine;
static char imageFetchOperationKey;

const float kFromCacheAnimationDuration = 0.1f;
const float kFreshLoadAnimationDuration = 0.35f;

@interface UIImageView (/*Private Methods*/)
@property (strong, nonatomic) WYNetOperation *imageFetchOperation;
@end

@implementation UIImageView (WYNetKitAdditions)

-(WYNetOperation*) imageFetchOperation {
  
  return (WYNetOperation*) objc_getAssociatedObject(self, &imageFetchOperationKey);
}

-(void) setImageFetchOperation:(WYNetOperation *)imageFetchOperation {
  
  objc_setAssociatedObject(self, &imageFetchOperationKey, imageFetchOperation, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+(void) setDefaultEngine:(WYNetEngine*) engine {
  
  DefaultEngine = engine;
}

-(WYNetOperation*) setImageFromURL:(NSURL*) url {
  
  return [self setImageFromURL:url placeHolderImage:nil];
}

-(WYNetOperation*) setImageFromURL:(NSURL*) url placeHolderImage:(UIImage*) image {
  
  return [self setImageFromURL:url placeHolderImage:image usingEngine:DefaultEngine animation:YES];
}

-(WYNetOperation*) setImageFromURL:(NSURL*) url placeHolderImage:(UIImage*) image animation:(BOOL) yesOrNo {
  
  return [self setImageFromURL:url placeHolderImage:image usingEngine:DefaultEngine animation:yesOrNo];
}

-(WYNetOperation*) setImageFromURL:(NSURL*) url placeHolderImage:(UIImage*) image usingEngine:(WYNetEngine*) imageCacheEngine animation:(BOOL) animation {
  
  if(image) self.image = image;
  [self.imageFetchOperation cancel];
  if(!imageCacheEngine) imageCacheEngine = DefaultEngine;
  
  if(imageCacheEngine) {
    self.imageFetchOperation = [imageCacheEngine imageAtURL:url
                                                       size:self.frame.size
                                          completionHandler:^(UIImage *fetchedImage, NSURL *url, BOOL isInCache) {
                                            
                                            if(animation) {
                                            [UIView transitionWithView:self.superview
                                                              duration:isInCache?kFromCacheAnimationDuration:kFreshLoadAnimationDuration
                                                               options:UIViewAnimationOptionTransitionCrossDissolve | UIViewAnimationOptionAllowUserInteraction
                                                            animations:^{
                                                                 self.image = fetchedImage;
                                                               } completion:nil];
                                            } else {
                                              self.image = fetchedImage;                                              
                                            }
                                            
                                          } errorHandler:^(WYNetOperation *completedOperation, NSError *error) {
                                            
                                            DLog(@"%@", error);
                                          }];
  } else {
    
    DLog(@"No default engine found and imageCacheEngine parameter is null")
  }
  
  return self.imageFetchOperation;
}
@end
