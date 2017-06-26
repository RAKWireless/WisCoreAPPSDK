//
//  DeviceViewController.h
//  WisCore
//
//  Created by rakwireless on 2017/4/20.
//  Copyright © 2017年 rak. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DeviceViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
{
    UIView *_topBg;
    UIButton *_backBtn;
    UILabel *_topTitle;
    UIView *_mainBg;
    UIImageView *_deviceViewImg;
    UITableView* _deviceInfoTableview;
}

@property (retain, nonatomic) NSString* deviceName;
@property (retain, nonatomic) NSString* deviceIp;
@end
