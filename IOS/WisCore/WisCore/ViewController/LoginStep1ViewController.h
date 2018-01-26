//
//  LoginStep1ViewController.h
//  WisCore
//
//  Created by rakwireless on 2017/4/20.
//  Copyright © 2017年 rak. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ParametersConfig.h"

@interface LoginStep1ViewController : UIViewController<ParametersConfigDelegate,UIAlertViewDelegate>
{
    UIView *_topBg;
    UIButton *_backBtn;
    UILabel *_topTitle;
    UILabel *_skipTitle;
    UIView *_mainBg;
    UIImageView *_loginStep1Img;
    UILabel *_loginStep1Label1;
    UILabel *_loginStep1Label2;
    UIButton *_loginStep1Btn;
}
@property (retain, nonatomic) NSString* loginStep1DeviceIp;
@property (retain, nonatomic) ParametersConfig* loginStep1ParametersConfig;
@end
