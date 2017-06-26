//
//  LogoutViewController.h
//  WisCore
//
//  Created by rakwireless on 2017/4/20.
//  Copyright © 2017年 rak. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ParametersConfig.h"

@interface LogoutViewController : UIViewController<ParametersConfigDelegate>
{
    UIView *_topBg;
    UIButton *_backBtn;
    UILabel *_topTitle;
    UILabel *_signOutTitle;
    UIView *_mainBg;
    UIImageView *_logoutImg;
    UIButton *_logoutBtn;
    UILabel *_logoutInfo;
}
@property (retain, nonatomic) NSString* loginOutStep1DeviceIp;
@property (retain, nonatomic) ParametersConfig* loginOutStep1ParametersConfig;
@end
