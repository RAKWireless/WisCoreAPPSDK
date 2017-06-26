//
//  ViewController.h
//  WisCore
//
//  Created by rakwireless on 2017/4/19.
//  Copyright © 2017年 rak. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
{
    UIView *_topBg;
    UIButton *_menuBtn;
    UIButton *_refreshBtn;
    UILabel *_topTitle;
    UITableView* _deviceListTableview;
    UIView *_bottomBg;
    UIButton *_addBtn;
    UILabel *_noDeviceLabel;
    UIView *_deleteView;
    UILabel *_versonLabel;
}

@end

