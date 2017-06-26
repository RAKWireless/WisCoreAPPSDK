//
//  ApAddEndViewController.h
//  WisCore
//
//  Created by rakwireless on 2017/4/20.
//  Copyright © 2017年 rak. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ApAddEndViewController : UIViewController
{
    UIView *_topBg;
    UIButton *_backBtn;
    UILabel *_topTitle;
    UIView *_mainBg;
    UIImageView *_apAddEndImg;
    UILabel *_apAddEndLabel1;
    UILabel *_apAddEndLabel2;
    UIButton *_apAddGoSettingsBtn;
    UIButton *_apAddEndBtn;
}
@property (retain, nonatomic) NSString* apAddSuccess;
@property (retain, nonatomic) NSString* apAddEndSsid;
@property (retain, nonatomic) NSString* apAddEndDeviceId;
@end
