//
//  ApAddEndViewController.m
//  WisCore
//
//  Created by rakwireless on 2017/4/20.
//  Copyright © 2017年 rak. All rights reserved.
//

#import "ApAddEndViewController.h"
#import "CommanParameters.h"
#import "ApAddWaitViewController.h"

@interface ApAddEndViewController ()

@end

@implementation ApAddEndViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:MAIN_BG_COLOR];
    // 标题栏
    _topBg=[[UIView alloc]init];
    _topBg.frame = CGRectMake(0, diff_top, viewW, viewH*44/view_fix_height);
    _topBg.userInteractionEnabled=YES;
    [_topBg setBackgroundColor:MAIN_TITLE_BG_COLOR];
    [self.view addSubview:_topBg];
    
    _backBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    _backBtn.frame = CGRectMake(0, 0, viewH*44/view_fix_height, viewH*44/view_fix_height);
    [_backBtn setImage:[UIImage imageNamed:@"pre_nor@3x.png"] forState:UIControlStateNormal];
    [_backBtn setImage:[UIImage imageNamed:@"pre_pre@3x.png"] forState:UIControlStateHighlighted];
    [_backBtn setTitleColor:[UIColor lightGrayColor]forState:UIControlStateNormal];
    [_backBtn setTitleColor:[UIColor grayColor]forState:UIControlStateHighlighted];
    _backBtn.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
    [_backBtn addTarget:nil action:@selector(_backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_topBg  addSubview:_backBtn];
    
    _topTitle= [[UILabel alloc] initWithFrame:CGRectMake(0, 0,viewW-viewH*44*2/view_fix_height, viewH*44/view_fix_height)];
    _topTitle.text = NSLocalizedString(@"main_add_step1_title", nil);
    _topTitle.center=CGPointMake(_topBg.center.x, _topTitle.center.y);
    _topTitle.font = [UIFont boldSystemFontOfSize: main_title_size];
    _topTitle.backgroundColor = [UIColor clearColor];
    _topTitle.textColor = [UIColor blackColor];
    _topTitle.numberOfLines = 0;
    _topTitle.textAlignment=NSTextAlignmentCenter;
    [_topBg addSubview:_topTitle];
    
    //主界面
    _mainBg=[[UIView alloc]init];
    _mainBg.frame = CGRectMake(0, viewH*64/view_fix_height, viewW, viewH-viewH*64/view_fix_height);
    _mainBg.userInteractionEnabled=YES;
    [_mainBg setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:_mainBg];
    
    _apAddEndImg=[[UIImageView alloc]init];
    _apAddEndImg.frame=CGRectMake(0, viewH*79/view_fix_height, viewH*110/view_fix_height,viewH*110/view_fix_height);
    _apAddEndImg.center=CGPointMake(viewW*0.5, _apAddEndImg.center.y);
    _apAddEndImg.image=[UIImage imageNamed:@"successful@3x.png"];
    [_mainBg addSubview:_apAddEndImg];
    
    _apAddEndLabel1= [[UILabel alloc] initWithFrame:CGRectMake(0, viewH*201/view_fix_height,viewW, viewH*20/view_fix_height)];
    _apAddEndLabel1.text = NSLocalizedString(@"main_add_end_success_label1", nil);
    _apAddEndLabel1.center=CGPointMake(viewW*0.5, _apAddEndLabel1.center.y);
    _apAddEndLabel1.font = [UIFont boldSystemFontOfSize: main_text_size];
    _apAddEndLabel1.backgroundColor = [UIColor clearColor];
    _apAddEndLabel1.textColor = SUCCESS_TEXT_COLOR;
    _apAddEndLabel1.numberOfLines = 0;
    _apAddEndLabel1.textAlignment=NSTextAlignmentCenter;
    [_mainBg addSubview:_apAddEndLabel1];
    
    _apAddEndLabel2= [[UILabel alloc] initWithFrame:CGRectMake(viewW*20/view_fix_width, viewH*230/view_fix_height,viewW-viewW*40/view_fix_width, viewH*100/view_fix_height)];
    _apAddEndLabel2.text = NSLocalizedString(@"main_add_end_success_label2", nil);
    _apAddEndLabel2.center=CGPointMake(viewW*0.5, _apAddEndLabel2.center.y);
    _apAddEndLabel2.font = [UIFont systemFontOfSize: main_text_size];
    _apAddEndLabel2.backgroundColor = [UIColor clearColor];
    _apAddEndLabel2.textColor = ADD_NOTE_COLOR;
    _apAddEndLabel2.numberOfLines = 0;
    _apAddEndLabel2.lineBreakMode = UILineBreakModeWordWrap;
    _apAddEndLabel2.textAlignment=NSTextAlignmentCenter;
    [_mainBg addSubview:_apAddEndLabel2];
    
    _apAddGoSettingsBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    _apAddGoSettingsBtn.frame = CGRectMake(viewW*54/view_fix_width, viewH*381/view_fix_height, viewW*267/view_fix_width, viewH*48/view_fix_height);
    [_apAddGoSettingsBtn setTitle:NSLocalizedString(@"main_add_step2_settings_btn", nil) forState:UIControlStateNormal];
    [_apAddGoSettingsBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_apAddGoSettingsBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [_apAddGoSettingsBtn setBackgroundImage:[UIImage imageNamed:@"long_oc_cyan_nor@3x.png"] forState:UIControlStateNormal];
    [_apAddGoSettingsBtn setBackgroundImage:[UIImage imageNamed:@"long_oc_cyan_pre@3x.png"] forState:UIControlStateHighlighted];
    _apAddGoSettingsBtn.contentHorizontalAlignment=UIControlContentHorizontalAlignmentCenter;
    [_apAddGoSettingsBtn addTarget:nil action:@selector(_apAddGoSettingsBtnClick) forControlEvents:UIControlEventTouchUpInside];
    _apAddGoSettingsBtn.titleLabel.font=[UIFont systemFontOfSize: main_text_size];
    [_mainBg  addSubview:_apAddGoSettingsBtn];
    _apAddGoSettingsBtn.hidden=YES;
    
    _apAddEndBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    _apAddEndBtn.frame = CGRectMake(viewW*54/view_fix_width, viewH*449/view_fix_height, viewW*267/view_fix_width, viewH*48/view_fix_height);
    [_apAddEndBtn setTitle:NSLocalizedString(@"main_add_end_success_btn", nil) forState:UIControlStateNormal];
    [_apAddEndBtn setTitleColor:MAIN_TEXT_COLOR forState:UIControlStateNormal];
    [_apAddEndBtn setBackgroundImage:[UIImage imageNamed:@"long_oc_nor@3x.png"] forState:UIControlStateNormal];
    [_apAddEndBtn setBackgroundImage:[UIImage imageNamed:@"long_oc_pre@3x.png"] forState:UIControlStateHighlighted];
    _apAddEndBtn.contentHorizontalAlignment=UIControlContentHorizontalAlignmentCenter;
    [_apAddEndBtn addTarget:nil action:@selector(_apAddEndBtnClick) forControlEvents:UIControlEventTouchUpInside];
    _apAddEndBtn.titleLabel.font=[UIFont systemFontOfSize: main_text_size];
    [_mainBg  addSubview:_apAddEndBtn];
    
    if ([_apAddSuccess isEqualToString:@"no"]) {
        _apAddGoSettingsBtn.hidden=NO;
        _apAddEndImg.image=[UIImage imageNamed:@"faild@3x.png"];
        _apAddEndLabel1.text = NSLocalizedString(@"main_add_end_failed_label1", nil);
        _apAddEndLabel1.textColor=[UIColor blackColor];
        _apAddEndLabel2.text = NSLocalizedString(@"main_add_end_failed_label2", nil);
        [_apAddEndBtn setTitle:NSLocalizedString(@"main_add_end_failed_btn", nil) forState:UIControlStateNormal];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillResignActive)
                                                     name:UIApplicationWillResignActiveNotification object:nil]; //监听是否触发home键挂起程序.
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActive)
                                                     name:UIApplicationDidBecomeActiveNotification object:nil]; //监听是否重新进入程序程序.
    }
}
    
- (void)applicationWillResignActive{
    
}
    
- (void)applicationDidBecomeActive{
    if ([[CommanParameters getWifiName] isEqualToString:_apAddEndSsid]) {
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        ApAddWaitViewController *v = [[ApAddWaitViewController alloc] init];
        v.apAddWaitSsid=@"";
        v.apAddWaitPsk=@"";
        v.apAddWaitDeviceId=_apAddEndDeviceId;
        [self.navigationController pushViewController: v animated:true];
    }
    else{
        NSString *txt=[NSString stringWithFormat:@"%@%@",NSLocalizedString(@"check_network_dialog_text1", nil),_apAddEndSsid];
        [CommanParameters showAllTextDialog:self.view :txt];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)_backBtnClick{
    NSLog(@"_backBtnClick");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.navigationController popToRootViewControllerAnimated:YES];
}
    
- (void)_apAddGoSettingsBtnClick{
    NSLog(@"_apAddGoSettingsBtnClick");
    [CommanParameters gotoWifiSettings];
}

- (void)_apAddEndBtnClick{
    NSLog(@"_apAddEndBtnClick");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

//Set StatusBar
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}

- (BOOL)prefersStatusBarHidden//for iOS7.0
{
    return NO;
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}
@end
