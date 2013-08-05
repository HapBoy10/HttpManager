//
//  WYHttpTask.m
//  QiaQuan_Merchant
//
//  Created by tom on 13-8-3.
//  Copyright (c) 2013年 tom. All rights reserved.
//

#import "WYHttpTask.h"
#import "ASIFormDataRequest.h"
#import "MBProgressHUD.h"


@interface WYHttpTask()
@property(strong)MBProgressHUD *hud;
@end


static NSOperationQueue *g_operationQueue = nil;
static NSMutableDictionary *g_mutableDictionary = nil;


@implementation WYHttpTask


@synthesize wydelegate;
@synthesize httpRequest = _httpRequest;

-(BOOL)isUrlEnable:(NSURL*)url{

    if(url == nil || [url absoluteString].length  == 0)
        return NO;
    
    if(g_mutableDictionary == nil){
        
        g_mutableDictionary = [NSMutableDictionary dictionaryWithCapacity:10];
    }
    
    //把相似url放在字典中，当一个请求完成后再回调 self
    return YES;
}

-(void)prepareRequest{
    
}

-(id)parseObj{
    
    return nil;
}

-(void)start{
    
    
    self.hud = [MBProgressHUD showHUDAddedTo:[[[UIApplication sharedApplication] windows] lastObject] animated:YES];
    self.hud.mode = MBProgressHUDAnimationZoom;
    self.hud.labelText = @"数据正在加载中，请稍后...";
    
    [self prepareRequest];
    
    if(g_operationQueue == nil){
        g_operationQueue = [[NSOperationQueue alloc] init];
        g_operationQueue.maxConcurrentOperationCount = 5;
    }
    
    if(g_mutableDictionary == nil){
        g_mutableDictionary = [[NSMutableDictionary alloc] initWithCapacity:10];
    }
    
    [self addObjToDoc];
    [self.httpRequest setDelegate:self];
    [g_operationQueue addOperation:self.httpRequest];
}

-(void)requestFailed:(ASIHTTPRequest *)request{
    DLog(@"请求失败：%@",request.responseString);
    [self failRequest];
}
-(void)requestFinished:(ASIHTTPRequest *)request{
    DLog(@"请求成功");
    [self completeRequst];
}

-(void)request:(ASIHTTPRequest *)request didReceiveData:(NSData *)data{
    
    [_mutableDta appendData:data];
}
-(void)requestStarted:(ASIHTTPRequest *)request{
    
    _mutableDta = [NSMutableData data];
}

-(void)addObjToDoc{
    
    NSString *url = [self.httpRequest.url absoluteString];
    url = [NSString stringWithFormat:@"%u",[url hash]];
    NSMutableArray *aSelf = [g_mutableDictionary valueForKey:url];
    
    if(aSelf == nil){
        aSelf = [NSMutableArray arrayWithCapacity:2];
    }
    
    [g_mutableDictionary setValue:self forKey:url];
}

-(void)removeObjFromDic{
    
    
}
//请求失败
-(void)failRequest{

    dispatch_async(dispatch_get_main_queue(), ^{
        if([wydelegate respondsToSelector:@selector(requestFailWithMsg:)])
            [wydelegate requestFailWithMsg:self];
        
        [self endRequest];
    });
}
//请求成功
-(void)completeRequst{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if([wydelegate respondsToSelector:@selector(requestCompleteWithObj:)])
            [wydelegate requestCompleteWithObj:self];
        
        [self endRequest];
    });
}


-(void)endRequest{
    [self removeObjFromDic];
    [self hidenHUD];
    [self.httpRequest clearDelegatesAndCancel];
}

-(void)hidenHUD{
    
    [self.hud hide:YES afterDelay:1.0];
}

-(void)cancelAllRequst{
    
    [self hidenHUD];
    [g_operationQueue cancelAllOperations];
}
@end
