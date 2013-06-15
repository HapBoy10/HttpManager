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
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:imageView];

    [[WYImageDownload shareInstance] downLoadWithURL:[NSURL URLWithString:@"http://img3.douban.com/icon/g289842-3.jpg"]  converTosize:CGSizeZero delegate:self completion:^(UIImage *image) {
        imageView.image = image;
    } failure:^{
        NSLog(@"shibai");
    } received:^(long long total) {
        NSLog(@"fuck");
    }];
    
    
    NSLog(@"%@,%d",@"tangwei",[@"tangwei" hash]);
    
    return;
    g_queue = [[NSOperationQueue alloc] init];
    [g_queue setMaxConcurrentOperationCount:2];
	// Do any additional setup after loading the view, typically from a nib.
    WYHttpRequest *request = [WYHttpRequest requestWithURL:[NSURL URLWithString:@"http://img3.douban.com/icon/g289842-3.jpg"]];
    request.delegate = self;
    
    [request setCompletionBlock:^{
        NSLog(@"tangwei");
    }];
    [request setReceivedBlock:^(NSData *data, NSMutableData *total) {
        NSLog(@"%d,%d",data.length,total.length);
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

//-(void)requestFinish:(WYHttpRequest *)request totalData:(NSMutableData *)data{
//
//}
//-(void)requestFailed:(WYHttpRequest *)request didFailWithError:(NSError *)error{
//
//}
//
//-(void)requestRcvData:(WYHttpRequest *)request didReceiveData:(NSData *)data curTotal:(NSMutableData *)curTotal{
//
//}


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
