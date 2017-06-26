//
//  DeviceInformationViewController.h
//  WisCore
//
//  Created by rakwireless on 2017/4/20.
//  Copyright © 2017年 rak. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ParametersConfig.h"

@interface DeviceInformationViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,ParametersConfigDelegate>
{
    UIView *_topBg;
    UIButton *_backBtn;
    UILabel *_topTitle;
    UIView *_mainBg;
    UIImageView *_informationViewImg;
    UITableView* _informationTableview;
    UILabel *_infoDeviceNameLabel;
    UILabel *_infoSNLabel;
    UILabel *_infoFWLabel;
}
@property (retain, nonatomic) NSString* infoDeviceName;
@property (retain, nonatomic) NSString* infoDeviceIp;
@property (retain, nonatomic) ParametersConfig* infoParametersConfig;
@end
