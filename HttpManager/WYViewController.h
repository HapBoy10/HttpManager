//
//  WYViewController.h
//  HttpManager
//
//  Created by 3TI on 13-6-14.
//  Copyright (c) 2013年 3TI. All rights reserved.
//

#import <UIKit/UIKit.h>


#import "WYHttpRequest.h"
@interface WYViewController : UIViewController<WYHttpRequestDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end
