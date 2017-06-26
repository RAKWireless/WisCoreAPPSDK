//
//  APAddStep3ViewController.h
//  WisCore
//
//  Created by rakwireless on 2017/4/20.
//  Copyright © 2017年 rak. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface APAddStep3ViewController : UIViewController<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>
{
    UIView *_topBg;
    UIButton *_backBtn;
    UILabel *_topTitle;
    UIView *_mainBg;
    UILabel *_ssidLabel;
    UITextField *_ssidField;
    UIButton *_ssidImg;
    UILabel *_pskLabel;
    UITextField *_pskField;
    UIButton *_pskImg;
    UIButton *_apAddStep3ContinueBtn;
    UIButton *_switchBtn;
    
    UIView *_ssidBgView;
    UITableView *_ssidListView;
}
@end
