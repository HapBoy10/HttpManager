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


static NSOperationQueue *g_queue = nil;
@interface WYViewController ()<UITableViewDataSource,UITableViewDelegate,WYImageDownloadDelegate>
{
    UITableView *_tableView;
}
@end

@implementation WYViewController

#define MYBASICURL @"http://61.155.169.165/pusher/"

#define POSTDEVICE MYBASICURL @"ws/device/add"  //设备信息报备

#define AppKey  @"27e1615212f3c6ea846ed6c412df1361ce97f006ee20bb5aa2483a3b61d5cadd"

-(void)imageDownloadDidFinish:(WYImageDownload *)download{

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSURL * url=[NSURL URLWithString:POSTDEVICE];
    __weak WYHttpRequest *request1 = [WYHttpRequest requestWithURL:url];
    

    
    NSDictionary * dic=[NSDictionary dictionaryWithObjectsAndKeys:
                        AppKey,@"header.appKey",
                        @"deviceToken",@"body.deviceId",
                        [self deviceId],@"body.deviceToken",
                        [self terminal],@"body.terminal",
                        [self deviceType],@"body.deviceType",
                        [self model],@"body.mode",
                        [self resolution],@"body.resolution",
                        [self network],@"body.netWorkType",
                        [self carrier],@"body.operator",
                        [self cpuSeria],@"body.cpuSerial",
                        [self brand],@"body.brand",
                        [self PhoneNumber],@"body.phoneNumbers",
                        nil];
    
    NSArray *keys = [dic allKeys];
    NSArray *values = [dic allValues];
    /*
    
    NSMutableURLRequest *myRequest=[NSMutableURLRequest requestWithURL:url];//创建一个指向目的网站的请求
    NSString *myBoundary=@"0xKhTmLbOuNdArY";//这个很重要，用于区别输入的域
    NSString *myContent=[NSString stringWithFormat:@"multipart/form-data;boundary=%@",myBoundary];//意思是要提交的是表单数据
    
<<<<<<< HEAD
=======
    UIImageView *imageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(110, 110, 160, 160)];
    
    
    NSData *data = UIImagePNGRepresentation([UIImage imageNamed:@"Default@2x.png"]);
    UIImage *image =[[WYImageDownload shareInstance] converImageToSize:CGSizeMake(160, 160) data:[NSMutableData dataWithData:data]];
    NSLog(@"%@,%d",NSStringFromCGSize(image.size),UIImagePNGRepresentation(image).length);
    
    
    imageView1.image = image;
    [self.view addSubview:imageView1];
    
    return;
    NSURL * url=[NSURL URLWithString:POSTDEVICE];
    __weak WYHttpRequest *request1 = [WYHttpRequest requestWithURL:url];
    

    
    NSDictionary * dic=[NSDictionary dictionaryWithObjectsAndKeys:
                        AppKey,@"header.appKey",
                        @"deviceToken",@"body.deviceId",
                        [self deviceId],@"body.deviceToken",
                        [self terminal],@"body.terminal",
                        [self deviceType],@"body.deviceType",
                        [self model],@"body.mode",
                        [self resolution],@"body.resolution",
                        [self network],@"body.netWorkType",
                        [self carrier],@"body.operator",
                        [self cpuSeria],@"body.cpuSerial",
                        [self brand],@"body.brand",
                        [self PhoneNumber],@"body.phoneNumbers",
                        nil];
    
    NSArray *keys = [dic allKeys];
    NSArray *values = [dic allValues];
    /*
    
    NSMutableURLRequest *myRequest=[NSMutableURLRequest requestWithURL:url];//创建一个指向目的网站的请求
    NSString *myBoundary=@"0xKhTmLbOuNdArY";//这个很重要，用于区别输入的域
    NSString *myContent=[NSString stringWithFormat:@"multipart/form-data;boundary=%@",myBoundary];//意思是要提交的是表单数据
    
>>>>>>> 2e1050a903aed66efaeccdec7eaac9101a04c542
    [myRequest setValue:myContent forHTTPHeaderField:@"Content-type"];//定义内容类型
    
    NSMutableData * body=[NSMutableData data];//这个用于暂存你要提交的数据
    //下面开始增加你的数据了
    
    //我这里假设表单中，有两个字段，一个叫user,一个叫password
    
    //字段与字段之间要用到boundary分开
    
    [body appendData:[[NSString stringWithFormat:@"\n--%@\n",myBoundary] dataUsingEncoding:NSUTF8StringEncoding]];//表示开始
    
    NSString *endItemBoundary = [NSString stringWithFormat:@"\r\n--%@\r\n",myBoundary];
    for (int i = 0; i < keys.count; i++) {
        
        NSLog(@"key=%@,value=%@",[keys objectAtIndex:i],[values objectAtIndex:i]);
        
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n",[keys objectAtIndex:i]] dataUsingEncoding:NSUTF8StringEncoding]];
        
        [body appendData:[[values objectAtIndex:i] dataUsingEncoding:NSUTF8StringEncoding]]; 
        
        if(i != keys.count - 1)
            [body appendData:[endItemBoundary dataUsingEncoding:NSUTF8StringEncoding]];
    }
<<<<<<< HEAD
=======

    
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",myBoundary] dataUsingEncoding:NSUTF8StringEncoding]];//结束
    
    [myRequest setHTTPMethod:@"POST"];
    [myRequest setHTTPBody:body];
    NSError *error;
    NSData *respondse=[NSURLConnection sendSynchronousRequest:myRequest returningResponse:nil error:&error];//创建连接
    
    NSString * myGet=[[NSString alloc] initWithData:respondse encoding:NSUTF8StringEncoding];//接收数据
    NSLog(@"%@,%@",myGet,error);
    return;
    */
    
    for (int i = 0 ; i < keys.count; i++) {
        [request1 setPostValue:[values objectAtIndex:i] forKey:[keys objectAtIndex:i]];
    }
    
    [request1 setCompletionBlock:^{
        NSLog(@"success:%@",[[NSString alloc] initWithData:request1.rspMutableData encoding:NSUTF8StringEncoding]);
    }];
    
    
    [request1 setFailedBlock:^{
        NSLog(@"Failed");
    }];
    
    [request1 requestStart];
    
    return;
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:imageView];
>>>>>>> 2e1050a903aed66efaeccdec7eaac9101a04c542

    
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",myBoundary] dataUsingEncoding:NSUTF8StringEncoding]];//结束
    
    [myRequest setHTTPMethod:@"POST"];
    [myRequest setHTTPBody:body];
    NSError *error;
    NSData *respondse=[NSURLConnection sendSynchronousRequest:myRequest returningResponse:nil error:&error];//创建连接
    
    NSString * myGet=[[NSString alloc] initWithData:respondse encoding:NSUTF8StringEncoding];//接收数据
    NSLog(@"%@,%@",myGet,error);
    return;
    */
    
    for (int i = 0 ; i < keys.count; i++) {
        [request1 setPostValue:[values objectAtIndex:i] forKey:[keys objectAtIndex:i]];
    }
    
    [request1 setCompletionBlock:^{
        NSLog(@"success:%@",[[NSString alloc] initWithData:request1.rspMutableData encoding:NSUTF8StringEncoding]);
    }];
    
    
    [request1 setFailedBlock:^{
        NSLog(@"Failed");
    }];
    
    [request1 requestStart];
    
    return;
   
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


//基本信息采集
-(NSString*)cpuSeria{
    return @"ceshi";
}
-(NSString *)network{
    
    return @"Wifi";
}
-(NSString*)carrier{

    return @"ceshi";
}
-(NSString *)deviceType{
    
    return  @"Ios";
}
-(NSString *)sdkVersion{
    return [[UIDevice currentDevice]systemVersion];
}
-(NSString *)resolution{
    CGRect rect_screen = [[UIScreen mainScreen]bounds];
    CGSize size_screen = rect_screen.size;
    CGFloat scale_screen = [UIScreen mainScreen].scale;
    return [NSString stringWithFormat:@"%f",size_screen.width*size_screen.height*scale_screen];
}
-(NSString *)uid{

    return @"uid";
}
-(NSString *)model{
    
    return [[UIDevice currentDevice]model];
}
-(NSString *)cpu{
    return @"cpu";
}
-(NSString *)deviceId{
    
    return @"OpenUDID";
}
-(NSString *)PhoneNumber{
    //获取电话号码
    return  [[NSUserDefaults standardUserDefaults] objectForKey:@"SBFormattedPhoneNumber"];
}
-(NSString *)terminal{
    size_t size;
    int nR = sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = (char *)malloc(size);
    nR = sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *platform = [NSString stringWithCString:machine encoding:NSUTF8StringEncoding];
    free(machine);
    
    NSRange loc=[platform rangeOfString:@"iPod"];
    if(loc.location!=NSNotFound){
        return @"Pad";
    }
    else{
        return @"Mobile";
    }
}
-(NSString *)brand{
    return @"IPhone";
}

@end
