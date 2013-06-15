//
//  WYViewController.m
//  HttpManager
//
//  Created by 3TI on 13-6-14.
//  Copyright (c) 2013年 3TI. All rights reserved.
//

#import "WYViewController.h"
#import "WYHttpRequest.h"
#import "WYImageDownload.h"


static NSOperationQueue *g_queue = nil;
@interface WYViewController ()<UITableViewDataSource,UITableViewDelegate,WYImageDownloadDelegate>
{
    UITableView *_tableView;
}
@end

@implementation WYViewController

-(void)imageDownloadDidFinish:(WYImageDownload *)download{

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    CGRect frame = self.view.bounds;
//    
//    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width / 3, frame.size.height / 3)];
//    [self.view addSubview:imageView];
//
//    [[WYImageDownload shareInstance] downLoadWithURL:[NSURL URLWithString:@"http://img3.douban.com/icon/g289842-3.jpg"]  converTosize:CGSizeZero delegate:self completion:^(UIImage *image) {
//        imageView.alpha = 0;
//        imageView.image = image;
//        [UIView animateWithDuration:5 animations:^{
//            imageView.alpha = 1.0;
//        }];
//
//    } failure:^{
//        NSLog(@"shibai");
//    } received:^(long long total) {
//        NSLog(@"fuck");
//    }];
//    
//    UIImageView *imageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(0,20 + frame.size.height / 3, frame.size.width / 3, frame.size.height / 3)];
//    [self.view addSubview:imageView2];
//    
//    [[WYImageDownload shareInstance] downLoadWithURL:[NSURL URLWithString:@"http://img3.douban.com/icon/g289842-3.jpg"]  converTosize:CGSizeZero delegate:self completion:^(UIImage *image) {
//        imageView2.alpha = 0;
//        imageView2.image = image;
//        [UIView animateWithDuration:5 animations:^{
//            imageView2.alpha = 1.0;
//        }];
//
//    } failure:^{
//        NSLog(@"shibai");
//    } received:^(long long total) {
//        NSLog(@"fuck");
//    }];
//    
//    return;
    g_queue = [[NSOperationQueue alloc] init];
    [g_queue setMaxConcurrentOperationCount:2];
	// Do any additional setup after loading the view, typically from a nib.
    WYHttpRequest *request = [WYHttpRequest requestWithURL:[NSURL URLWithString:@"http://img3.douban.com/icon/g289842-3.jpg"]];
    NSData *d = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://img3.douban.com/icon/g289842-3.jpg"]];
    [request setRequestBodyData:(NSMutableData*)d];
    [request setRequestMethod:@"POST"];
    
    [request setCompletionBlock:^{
        NSLog(@"tangwei");
    }];
    [request setReceivedBlock:^(NSData *data, long long curlength, long long total) {
        NSLog(@"");
    }];
    
    [request setFailedBlock:^{
        NSLog(@"error");
    }];
    
    [request requestStart];
    
    
   
//    [self performSelector:@selector(ononon) withObject:nil afterDelay:.2];
    
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
}
//-(void)ononon{
//    
//    WYHttpRequest *request = [WYHttpRequest requestWithURL:[NSURL URLWithString:@"http://img3.douban.com/icon/g289842-3.jpg"]];
//    request.delegate = self;
//    [request requestStart];
//}

-(void)requestFinish:(WYHttpRequest *)request totalData:(NSMutableData *)data{

}
-(void)requestFailed:(WYHttpRequest *)request didFailWithError:(NSError *)error{

}

-(void)requestRcvData:(WYHttpRequest *)request didReceiveData:(NSData *)data curTotal:(NSMutableData *)curTotal{

}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 100;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString *defaultKey = @"sdjdsjkdshjkdsfkjh";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:defaultKey];
    if(!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:defaultKey];
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@",indexPath];
    return cell;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
