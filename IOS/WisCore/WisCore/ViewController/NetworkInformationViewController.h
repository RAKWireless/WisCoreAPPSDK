//
//  NetworkInformationViewController.h
//  WisCore
//
//  Created by rakwireless on 2017/4/20.
//  Copyright © 2017年 rak. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ParametersConfig.h"

@interface NetworkInformationViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,ParametersConfigDelegate>
{
    UIView *_topBg;
    UIButton *_backBtn;
    UILabel *_topTitle;
    UIView *_mainBg;
    UIImageView *_networkViewImg;
    UITableView* _networkTableview;
    UILabel *_networkSSIDLabel;
    UILabel *_networkMACLabel;
    UILabel *_networkIPV4;
    UILabel *_networkMask;
    UILabel *_networkGateway;
    UILabel *_networkDNS;
    UILabel *_networkIPV4Value;
    UILabel *_networkMaskValue;
    UILabel *_networkGatewayValue;
    UILabel *_networkDNSValue;
}
@property (retain, nonatomic) NSString* networkDeviceIp;
@property (retain, nonatomic) ParametersConfig* networkParametersConfig;
@end
