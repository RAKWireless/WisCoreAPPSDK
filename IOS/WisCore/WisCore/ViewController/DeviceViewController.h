//
//  DeviceViewController.h
//  WisCore
//
//  Created by rakwireless on 2017/4/20.
//  Copyright © 2017年 rak. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ParametersConfig.h"

@interface DeviceViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,ParametersConfigDelegate>
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
@property (retain, nonatomic) ParametersConfig* deviceViewParametersConfig;
@end
