//
//  WYHttpTask.h
//  QiaQuan_Merchant
//
//  Created by tom on 13-8-3.
//  Copyright (c) 2013年 tom. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"

@class WYHttpTask;
@protocol WYHttpTaskDelegate <NSObject>

@required
-(void)requestCompleteWithObj:(WYHttpTask*)obj;

@optional
-(void)requestFailWithMsg:(WYHttpTask*)obj;

@end

@interface WYHttpTask : NSObject<ASIHTTPRequestDelegate>{
@public
    NSMutableData *_mutableDta;
}
@property(strong,nonatomic)ASIHTTPRequest *httpRequest;
@property(assign,nonatomic)id<WYHttpTaskDelegate>wydelegate;

-(void)prepareRequest;
-(id)parseObj;
-(void)start;
-(void)cancelAllRequst;
@end
