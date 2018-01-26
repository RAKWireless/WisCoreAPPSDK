//
//  ApAddStep2ViewController.m
//  WisCore
//
//  Created by rakwireless on 2017/4/20.
//  Copyright © 2017年 rak. All rights reserved.
//

#import "ApAddStep2ViewController.h"
#import "CommanParameters.h"
#import "ApAddWaitViewController.h"
#import "Scanner.h"
#import "CommanParameters.h"
#import "LoadingView.h"

@interface ApAddStep2ViewController ()
{
    Scanner *_device_Scan;
    LoadingView *_loadingView;
    BOOL _isExit;
}
@end

@implementation ApAddStep2ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:MAIN_BG_COLOR];
    _isExit=NO;
    
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
    
    _apAddStep2Img=[[UIImageView alloc]init];
    _apAddStep2Img.frame=CGRectMake(0, 0, viewW, viewH*200/view_fix_height);
    _apAddStep2Img.image=[UIImage imageNamed:@"tips@3x.png"];
    [_mainBg addSubview:_apAddStep2Img];
    
    _apAddStep2Label= [[UILabel alloc] initWithFrame:CGRectMake(viewW*30/view_fix_width, viewH*222/view_fix_height,viewW-viewW*60/view_fix_width, viewH*150/view_fix_height)];
    _apAddStep2Label.textColor=MAIN_TEXT_COLOR;
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"main_add_step2_note", nil)];
    [str addAttribute:NSForegroundColorAttributeName value:INFO_TEXT_COLOR range:NSMakeRange(84,14)];
    _apAddStep2Label.attributedText=str;
    _apAddStep2Label.font = [UIFont systemFontOfSize: main_text_size];
    _apAddStep2Label.backgroundColor = [UIColor clearColor];
    _apAddStep2Label.numberOfLines = 0;
    _apAddStep2Label.lineBreakMode = UILineBreakModeWordWrap;
    _apAddStep2Label.textAlignment=NSTextAlignmentLeft;
    [_mainBg addSubview:_apAddStep2Label];
    
    _apAddStep2GoSettingsBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    _apAddStep2GoSettingsBtn.frame = CGRectMake(viewW*54/view_fix_width, viewH*381/view_fix_height, viewW*267/view_fix_width, viewH*48/view_fix_height);
    [_apAddStep2GoSettingsBtn setTitle:NSLocalizedString(@"main_add_step2_settings_btn", nil) forState:UIControlStateNormal];
    [_apAddStep2GoSettingsBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_apAddStep2GoSettingsBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [_apAddStep2GoSettingsBtn setBackgroundImage:[UIImage imageNamed:@"long_oc_cyan_nor@3x.png"] forState:UIControlStateNormal];
    [_apAddStep2GoSettingsBtn setBackgroundImage:[UIImage imageNamed:@"long_oc_cyan_pre@3x.png"] forState:UIControlStateHighlighted];
    _apAddStep2GoSettingsBtn.contentHorizontalAlignment=UIControlContentHorizontalAlignmentCenter;
    [_apAddStep2GoSettingsBtn addTarget:nil action:@selector(_apAddStep2GoSettingsBtnClick) forControlEvents:UIControlEventTouchUpInside];
    _apAddStep2GoSettingsBtn.titleLabel.font=[UIFont systemFontOfSize: main_text_size];
    //[_mainBg  addSubview:_apAddStep2GoSettingsBtn];
    
    _apAddStep2ContinueBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    _apAddStep2ContinueBtn.frame = CGRectMake(viewW*54/view_fix_width, viewH*449/view_fix_height, viewW*267/view_fix_width, viewH*48/view_fix_height);
    [_apAddStep2ContinueBtn setTitle:NSLocalizedString(@"main_add_step2_settings_btn", nil) forState:UIControlStateNormal];
    [_apAddStep2ContinueBtn setTitleColor:MAIN_TEXT_COLOR forState:UIControlStateNormal];
    [_apAddStep2ContinueBtn setBackgroundImage:[UIImage imageNamed:@"long_oc_nor@3x.png"] forState:UIControlStateNormal];
    [_apAddStep2ContinueBtn setBackgroundImage:[UIImage imageNamed:@"long_oc_pre@3x.png"] forState:UIControlStateHighlighted];
    _apAddStep2ContinueBtn.contentHorizontalAlignment=UIControlContentHorizontalAlignmentCenter;
    [_apAddStep2ContinueBtn addTarget:nil action:@selector(_apAddStep2GoSettingsBtnClick) forControlEvents:UIControlEventTouchUpInside];
    _apAddStep2ContinueBtn.titleLabel.font=[UIFont systemFontOfSize: main_text_size];
    [_mainBg  addSubview:_apAddStep2ContinueBtn];
    
    _loadingView = [[LoadingView alloc] initWithFrame:self.view.frame];
    [_loadingView setLoadingShow:NO :@""];
    [self.view addSubview:_loadingView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillResignActive)
                                                 name:UIApplicationWillResignActiveNotification object:nil]; //监听是否触发home键挂起程序.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActive)
                                                 name:UIApplicationDidBecomeActiveNotification object:nil]; //监听是否重新进入程序程序.
    if ([[CommanParameters getWifiName] hasPrefix:@"WisCore"]) {
        ApAddWaitViewController *v = [[ApAddWaitViewController alloc] init];
        v.apAddWaitSsid=_apAddStep2Ssid;
        v.apAddWaitPsk=_apAddStep2Psk;
        [self.navigationController pushViewController: v animated:true];
    }
}

- (void)applicationWillResignActive{
    
}

- (void)applicationDidBecomeActive{
    if (_isExit) {
        return;
    }
    if ([[CommanParameters getWifiName] hasPrefix:@"WisCore"]) {
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        ApAddWaitViewController *v = [[ApAddWaitViewController alloc] init];
        v.apAddWaitSsid=_apAddStep2Ssid;
        v.apAddWaitPsk=_apAddStep2Psk;
        [self.navigationController pushViewController: v animated:true];
    }
    else{
        [CommanParameters showAllTextDialog:self.view :NSLocalizedString(@"main_add_step2_connected_failed", nil)];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)_backBtnClick{
    NSLog(@"_backBtnClick");
    _isExit=YES;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)_apAddStep2GoSettingsBtnClick{
    NSLog(@"_apAddStep2GoSettingsBtnClick");
    [CommanParameters gotoWifiSettings];
}

- (void)_apAddStep2ContinueBtnClick{
    NSLog(@"_apAddStep2ContinueBtnClick");
    
    [self scanDevice];
}

#pragma mark -- scanDevice
- (void)scanDevice
{
    [_loadingView setLoadingShow:YES :NSLocalizedString(@"add_device_ap_connect_text", nil)];
    [NSThread detachNewThreadSelector:@selector(scanDeviceTask) toTarget:self withObject:nil];
}

- (void)scanDeviceTask
{
    _device_Scan = [[Scanner alloc] init];
    Scanner *result = [_device_Scan ScanDeviceWithTime:1.5f];
    [self performSelectorOnMainThread:@selector(scanDeviceOver:) withObject:result waitUntilDone:NO];
}

- (void)scanDeviceOver:(Scanner *)result;
{
    if (result.Device_ID_Arr.count > 0) {
        NSLog(@"Scan Over...");
    }
    else
    {
        NSLog(@"Scan nothing...");
        [CommanParameters showAllTextDialog:self.view :NSLocalizedString(@"add_device_ap_connect_failed", nil)];
    }
    
    [_loadingView setLoadingShow:NO :@""];
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
