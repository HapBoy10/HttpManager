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

static NSMutableDictionary *g_mutableDictionary = nil;

@implementation WYHttpTask

@synthesize wydelegate;
@synthesize httpRequest = _httpRequest;

-(void)prepareRequest{
    
}

-(id)parseObj{
    
    return nil;
}

-(void)start{
    DLog(@"%@",[[UIApplication sharedApplication] windows]);

//    self.hud = [MBProgressHUD showHUDAddedTo:[[[UIApplication sharedApplication] windows] lastObject] animated:YES];
//    self.hud.mode = MBProgressHUDAnimationZoom;
//    self.hud.labelText = @"数据正在加载中，请稍后...";
    
    /*
     
     (
     "<UIWindow: 0x85bada0; frame = (0 0; 768 1024); layer = <UIWindowLayer: 0x85baea0>>",
     "<UITextEffectsWindow: 0x91bde10; frame = (0 0; 768 1024); transform = [0, -1, 1, 0, -128, 128]; hidden = YES; opaque = NO; layer = <UIWindowLayer: 0x919e6d0>>"
     )
     
     */
    [self prepareRequest];
    
    if(g_mutableDictionary == nil){
        g_mutableDictionary = [[NSMutableDictionary alloc] initWithCapacity:10];
    }
    
    [self.httpRequest setDelegate:self];
    
    if([self addObjToDoc])
        [self.httpRequest startAsynchronous];
    
}

-(void)requestFailed:(ASIHTTPRequest *)request{
    DLog(@"请求失败：%@",request.responseString);
    [self failRequest];
}

-(void)requestFinished:(ASIHTTPRequest *)request{
    DLog(@"请求成功");
    [self completeRequst];
}

//请求失败
-(void)failRequest{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if([wydelegate respondsToSelector:@selector(requestFailWithMsg:)])
            [wydelegate requestFailWithMsg:self];
        
        [self endRequest:NO];
    });
}
//请求成功
-(void)completeRequst{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if([wydelegate respondsToSelector:@selector(requestCompleteWithObj:)])
            [wydelegate requestCompleteWithObj:self];
        
        [self endRequest:YES];
    });
}

-(void)request:(ASIHTTPRequest *)request didReceiveData:(NSData *)data{
    
    [_mutableDta appendData:data];
}

-(void)requestStarted:(ASIHTTPRequest *)request{
    
    _mutableDta = [NSMutableData data];
}

-(BOOL)addObjToDoc{
    
    NSString *url = [self.httpRequest.url absoluteString];
    url = [NSString stringWithFormat:@"%u",[url hash]];
    NSMutableArray *aSelf = [g_mutableDictionary valueForKey:url];
    
    if(aSelf == nil || aSelf.count == 0){
        
        aSelf = [NSMutableArray arrayWithCapacity:2];
        [aSelf addObject:self];
        [g_mutableDictionary setValue:aSelf forKey:url];
        return YES;
    }
    [aSelf addObject:self];
    return NO;
}

//请求成功移除
-(void)removeObjFromDicSuccess{
    
    NSString *url = [self.httpRequest.url absoluteString];
    url = [NSString stringWithFormat:@"%u",[url hash]];
    NSMutableArray *aSelf = [g_mutableDictionary valueForKey:url];
    NSInteger count = [aSelf count];
    if(count == 1){
        ;
    }else if(count > 1){
    
        for (WYHttpTask * task in aSelf) {
            
            task->_mutableDta = [self->_mutableDta mutableCopy];
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if([task.wydelegate respondsToSelector:@selector(requestCompleteWithObj:)])
                    [task.wydelegate requestCompleteWithObj:task];
            });
        }
    }
    
    [g_mutableDictionary removeObjectForKey:url];
}
//请求失败继续
-(void)removeObjFromDicFail{
    
    NSString *url = [self.httpRequest.url absoluteString];
    url = [NSString stringWithFormat:@"%u",[url hash]];
    NSMutableArray *aSelf = [g_mutableDictionary valueForKey:url];
    NSInteger count = [aSelf count];
    if(count == 1){
        ;
    }else if(count > 1){
        //标记已经请求过的
        for (WYHttpTask * task in aSelf) {
            
            if([task isEqual:self]) continue;
            
            [task.httpRequest startAsynchronous];
            break;
        }
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if([wydelegate respondsToSelector:@selector(requestFailWithMsg:)])
            [wydelegate requestFailWithMsg:self];
    });
    [g_mutableDictionary removeObjectForKey:url];
}

-(void)endRequest:(BOOL)isComplete{
    
    if(isComplete)
        [self removeObjFromDicSuccess];
    else
        [self removeObjFromDicFail];
    
    [self hidenHUD];
    [self.httpRequest clearDelegatesAndCancel];
}

-(void)hidenHUD{
    
    [self.hud hide:YES afterDelay:1.0];
}

-(void)cancelAllRequst{
    
    [self hidenHUD];
    [[ASIHTTPRequest sharedQueue] cancelAllOperations];
}
@end
