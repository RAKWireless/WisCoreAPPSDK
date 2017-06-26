//
//  ApAddWaitViewController.h
//  WisCore
//
//  Created by rakwireless on 2017/4/23.
//  Copyright © 2017年 rak. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ParametersConfig.h"

@interface ApAddWaitViewController : UIViewController<ParametersConfigDelegate>
{
    UIButton *_backBtn;
    UILabel *_noteTitle;
    UILabel *_noteText;
    UIProgressView *_noteProgress;
    UILabel *_noteProgressValue;
}

@property (retain, nonatomic) NSString* apAddWaitSsid;
@property (retain, nonatomic) NSString* apAddWaitPsk;
@property (retain, nonatomic) NSString* apAddWaitDeviceId;
@property (retain, nonatomic) ParametersConfig* apWaitParametersConfig;
@end
