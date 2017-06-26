//
//  ApAddStep2ViewController.h
//  WisCore
//
//  Created by rakwireless on 2017/4/20.
//  Copyright © 2017年 rak. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ApAddStep2ViewController : UIViewController
{
    UIView *_topBg;
    UIButton *_backBtn;
    UILabel *_topTitle;
    UIView *_mainBg;
    UIImageView *_apAddStep2Img;
    UILabel *_apAddStep2Label;
    UIButton *_apAddStep2GoSettingsBtn;
    UIButton *_apAddStep2ContinueBtn;
}
@property (retain, nonatomic) NSString* apAddStep2Ssid;
@property (retain, nonatomic) NSString* apAddStep2Psk;
@end
