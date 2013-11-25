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
#import <sys/sysctl.h>

#define uploadurl [@"http://aiyobucuo.com/qiaquan/index.php?" stringByAppendingString:@"app=appapi&mod=Upload&act=do_upload"]

#import "WYCell.h"

@interface WYViewController ()<UITableViewDataSource,UITableViewDelegate,WYImageDownloadDelegate>
{
    UITableView *_tableView;
    NSMutableArray *_array;
}
@end

@implementation WYViewController

#define MYBASICURL @"http://61.155.169.165/pusher/"

#define POSTDEVICE MYBASICURL @"ws/device/add"  //设备信息报备

#define AppKey  @"27e1615212f3c6ea846ed6c412df1361ce97f006ee20bb5aa2483a3b61d5cadd"

@synthesize tableView = _tableView;
-(void)imageDownloadDidFinish:(WYImageDownload *)download{

    DLog(@"%@",download);
}

- (void)viewDidLoad{
    [super viewDidLoad];

    
    _array = [NSMutableArray arrayWithCapacity:10];
    [_array addObject:@"http://img.pconline.com.cn/images/upload/upc/tx/wallpaper/1205/21/c0/11692434_1337571824967.jpg"];
    [_array addObject:@"http://img.xshuma.com/201203/205354120322908066.jpg"];
    [_array addObject:@"http://www.gov234.cn/pic.asp?url=http://img.pconline.com.cn/images/upload/upc/tx/wallpaper/1206/12/c2/11972533_1339493488094.jpg"];
    [_array addObject:@"http://img.pconline.com.cn/images/upload/upc/tx/wallpaper/1204/16/c0/11268288_1334561385756.jpg"];
    [_array addObject:@"http://i1.img.969g.com/down/imgx2013/02/20/206_170544_4e8b8.jpg"];
    [_array addObject:@"http://img.pconline.com.cn/images/upload/upc/tx/wallpaper/1206/25/c1/12115987_1340604105848.jpg"];
    [_array addObject:@"http://www.33.la/uploads/20130217bz/845.jpg"];
    [_array addObject:@"http://t10.baidu.com/it/u=1619568749,1336149052&fm=21&gp=0.jpg"];
    [_array addObject:@"http://pic23.nipic.com/20120904/10866944_101420679148_2.jpg"];
    [_array addObject:@"http://img.wallba.com/Public/Upload/Image/mingxingbizi/gaoqingmeinv/8/20113117013843.jpg"];
    [_array addObject:@"http://img.wallba.com/Public/Upload/Image/mingxingbizi/hejing/12/201142014124972.jpg"];
    [_array addObject:@"http://attach.bbs.miui.com/forum/201203/10/072855r3a5xzqzge0qaqgg.jpg"];
    [_array addObject:@"http://bbra.cn/Uploadfiles/imgs/20110221/gaoqing/009.jpg"];
    [_array addObject:@"http://attach.bbs.miui.com/forum/month_1011/1011250123b74b7b4f6a74e8dc.jpg"];
    [_array addObject:@"http://pic.4j4j.cn/upload/pic/20130626/24251116c6.jpg"];
    [_array addObject:@"http://img2.niutuku.com/desk/1208/1308/ntk-1308-43168.jpg"];
    [_array addObject:@"http://www.79n.cn/uploads/allimg/121213/1-121213000914.jpg"];
    [_array addObject:@"http://h.hiphotos.bdimg.com/album/w%3D2048/sign=746841b10823dd542173a068e531b1de/cc11728b4710b9127787cb2bc2fdfc03934522a4.jpg"];
    [_array addObject:@"http://pic3.bbzhi.com/xitongbizhi/gaoqingkuanpingfengguangbizhi1/computer_kuan_266488_12.jpg"];
   
}
-(void)requestSendData:(WYHttpRequest *)request percent:(float)percent{

    DLog(@"%.2f",percent);
}


-(void)requestFinish:(WYHttpRequest *)request totalData:(NSMutableData *)data{
    DLog(@"%@,%@",data,[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
}
-(void)requestFailed:(WYHttpRequest *)request didFailWithError:(NSError *)error{
    DLog(@"%@",error);
}

-(void)requestRcvData:(WYHttpRequest *)request didReceiveData:(NSData *)data curTotal:(NSMutableData *)curTotal{
    DLog(@"requestRcvData");
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{

    WYHttpRequest *request = [WYHttpRequest requestWithURL:[NSURL URLWithString:uploadurl]];
    request.delegate = self;
    NSString *s = [[NSBundle mainBundle] pathForResource:@"big" ofType:@"jpg"];
    NSData *data = [NSData dataWithContentsOfFile:s];
    
    request.requestBodyData = [NSMutableData dataWithData:data];
    
    [request requestStart];
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_array count];
}

-(void)on_btn:(UIButton *)btn{

    
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString *defaultKey = @"sdjdsjkdshjkdsfkjh";
    WYCell *cell = [tableView dequeueReusableCellWithIdentifier:defaultKey];
    if(!cell){
        cell = [[[NSBundle mainBundle] loadNibNamed:@"WYCell" owner:self options:nil] objectAtIndex:0];
        [cell.imageBtn addTarget:self action:@selector(on_btn:) forControlEvents:UIControlEventTouchUpInside];
    }
    NSString *s = _array[indexPath.row];
    
    [[WYImageDownload shareInstance] downLoadWithURL:[NSURL URLWithString:s] delegate:self completion:^(UIImage *image) {
        [cell.imageBtn setBackgroundImage:image forState:UIControlStateNormal];
    } failure:^{
        DLog(@"file");
    }];
    
    cell.tag = 10000 + indexPath.row;
    
    cell.labelUrl.text = s;
    return cell;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewDidUnload {
    [self setTableView:nil];
    [super viewDidUnload];
}
@end
