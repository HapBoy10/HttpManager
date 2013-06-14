//
//  WYViewController.m
//  HttpManager
//
//  Created by 3TI on 13-6-14.
//  Copyright (c) 2013年 3TI. All rights reserved.
//

#import "WYViewController.h"
#import "WYHttpRequest.h"

@interface WYViewController ()

@end

@implementation WYViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    WYHttpRequest *request = [WYHttpRequest requestWithURL:[NSURL URLWithString:@"http://img3.douban.com/icon/g289842-3.jpg"]];
    request.delegate = self;
    [request requestStart];
    
    [self performSelector:@selector(ononon) withObject:nil afterDelay:10];
}
-(void)ononon{
    
    WYHttpRequest *request = [WYHttpRequest requestWithURL:[NSURL URLWithString:@"http://img3.douban.com/icon/g289842-3.jpg"]];
    request.delegate = self;
    [request requestStart];
}

-(void)requestFinish:(NSURLConnection *)connection totalData:(NSMutableData *)data{

}
-(void)requestFailed:(NSURLConnection *)connection didFailWithError:(NSError *)error{

}

-(void)requestRcvData:(NSURLConnection *)connection didReceiveData:(NSData *)data curTotal:(NSMutableData *)curTotal{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
