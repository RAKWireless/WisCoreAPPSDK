//
//  APAddStep3ViewController.m
//  WisCore
//
//  Created by rakwireless on 2017/4/20.
//  Copyright © 2017年 rak. All rights reserved.
//

#import "APAddStep3ViewController.h"
#import "CommanParameters.h"
#import "ApAddEndViewController.h"
#import "ApAddStep2ViewController.h"

@interface APAddStep3ViewController ()
{
    NSMutableArray *_wifiList;
}
@end

@implementation APAddStep3ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view setBackgroundColor:MAIN_BG_COLOR];
    _wifiList=[[NSMutableArray alloc]init];
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
    
    //PSK
    _pskLabel= [[UILabel alloc] initWithFrame:CGRectMake(viewW*38/view_fix_width, viewH*165/view_fix_height,viewW-viewW*76/view_fix_width, viewH*20/view_fix_height)];
    _pskLabel.text = NSLocalizedString(@"main_add_step3_psk_label", nil);
    _pskLabel.font = [UIFont boldSystemFontOfSize: main_text_size];
    _pskLabel.backgroundColor = [UIColor clearColor];
    _pskLabel.textColor = [UIColor blackColor];
    _pskLabel.numberOfLines = 0;
    _pskLabel.textAlignment=NSTextAlignmentLeft;
    [_mainBg addSubview:_pskLabel];
    
    UIImageView *_pskView=[[UIImageView alloc]init];
    _pskView.frame=CGRectMake(viewW*38/view_fix_width, viewH*193/view_fix_height,viewW*300/view_fix_width, viewH*48/view_fix_height);
    _pskView.userInteractionEnabled=YES;
    _pskView.image=[UIImage imageNamed:@"input_sel@3x.png"];
    [_mainBg addSubview:_pskView];
    
    _pskField= [[UITextField alloc] initWithFrame:CGRectMake(viewW*42/view_fix_width, viewH*193/view_fix_height,viewW*254/view_fix_width, viewH*48/view_fix_height)];
    _pskField.font = [UIFont systemFontOfSize: choose_text_size];
    _pskField.backgroundColor = [UIColor clearColor];
    _pskField.textColor = [UIColor blackColor];
    _pskField.delegate = self;
    _pskField.textAlignment=NSTextAlignmentLeft;
    _pskField.secureTextEntry = YES;
    [_mainBg addSubview:_pskField];
    
    _pskImg=[UIButton buttonWithType:UIButtonTypeCustom];
    _pskImg.frame = CGRectMake(viewW*294/view_fix_width, viewH*193/view_fix_height,viewH*48/view_fix_height, viewH*48/view_fix_height);
    [_pskImg setImage:[UIImage imageNamed:@"off@3x.png"] forState:UIControlStateNormal];
    _pskImg.contentHorizontalAlignment=UIControlContentHorizontalAlignmentCenter;
    [_pskImg addTarget:nil action:@selector(_pskImgClick) forControlEvents:UIControlEventTouchUpInside];
    [_mainBg  addSubview:_pskImg];
    
    _apAddStep3ContinueBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    _apAddStep3ContinueBtn.frame = CGRectMake(viewW*54/view_fix_width, viewH*449/view_fix_height, viewW*267/view_fix_width, viewH*48/view_fix_height);
    [_apAddStep3ContinueBtn setTitle:NSLocalizedString(@"main_add_step3_contine_btn", nil) forState:UIControlStateNormal];
    [_apAddStep3ContinueBtn setTitleColor:MAIN_TEXT_COLOR forState:UIControlStateNormal];
    [_apAddStep3ContinueBtn setBackgroundImage:[UIImage imageNamed:@"long_oc_nor@3x.png"] forState:UIControlStateNormal];
    [_apAddStep3ContinueBtn setBackgroundImage:[UIImage imageNamed:@"long_oc_pre@3x.png"] forState:UIControlStateHighlighted];
    _apAddStep3ContinueBtn.contentHorizontalAlignment=UIControlContentHorizontalAlignmentCenter;
    [_apAddStep3ContinueBtn addTarget:nil action:@selector(_apAddStep3ContinueBtnClick) forControlEvents:UIControlEventTouchUpInside];
    _apAddStep3ContinueBtn.titleLabel.font=[UIFont systemFontOfSize: main_text_size];
    [_mainBg  addSubview:_apAddStep3ContinueBtn];
    
    _switchBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    _switchBtn.frame = CGRectMake(0, _pskView.frame.origin.y+_pskView.frame.size.height+viewH*10/view_fix_height, viewW-viewW*40/view_fix_width, viewH*20/view_fix_height);
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"main_add_step3_switch_btn", nil)];
    NSRange strRange = {0,[str length]};
    [str addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:strRange];
    [_switchBtn setAttributedTitle:str forState:UIControlStateNormal];
    [_switchBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_switchBtn setTitleColor:MAIN_TEXT_COLOR forState:UIControlStateHighlighted];
    _switchBtn.contentHorizontalAlignment=UIControlContentHorizontalAlignmentRight;
    [_switchBtn addTarget:nil action:@selector(_switchBtnClick) forControlEvents:UIControlEventTouchUpInside];
    _switchBtn.titleLabel.font=[UIFont systemFontOfSize: main_text_size];
    [_mainBg  addSubview:_switchBtn];
    
    _ssidBgView= [[UIView alloc]initWithFrame:CGRectMake(viewW*42/view_fix_width-8, viewH*133/view_fix_height,viewW*300/view_fix_width, viewH*190/view_fix_height)];
    _ssidBgView.userInteractionEnabled=YES;
    _ssidBgView.backgroundColor=[UIColor whiteColor];
    _ssidBgView.layer.shadowColor = SHADOW_COLOR.CGColor;
    _ssidBgView.layer.shadowOffset = CGSizeMake(-4, 4);
    _ssidBgView.layer.shadowOpacity = 1;
    _ssidBgView.clipsToBounds = false;
    [_mainBg  addSubview:_ssidBgView];
    _ssidBgView.hidden=YES;
    
    _ssidListView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0,viewW*300/view_fix_width, viewH*190/view_fix_height)];
    _ssidListView.dataSource = self;
    _ssidListView.delegate = self;
    _ssidListView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _ssidListView.backgroundColor=[UIColor whiteColor];
    _ssidListView.separatorInset=UIEdgeInsetsMake(0, 0, 0, 0);
    [_ssidBgView  addSubview:_ssidListView];
    
    //SSID
    _ssidLabel= [[UILabel alloc] initWithFrame:CGRectMake(viewW*38/view_fix_width, viewH*57/view_fix_height,viewW-viewW*76/view_fix_width, viewH*20/view_fix_height)];
    _ssidLabel.text = NSLocalizedString(@"main_add_step3_ssid_label", nil);
    _ssidLabel.font = [UIFont boldSystemFontOfSize: main_text_size];
    _ssidLabel.backgroundColor = [UIColor clearColor];
    _ssidLabel.textColor = [UIColor blackColor];
    _ssidLabel.numberOfLines = 0;
    _ssidLabel.textAlignment=NSTextAlignmentLeft;
    [_mainBg addSubview:_ssidLabel];
    
    UIImageView *_ssidView=[[UIImageView alloc]init];
    _ssidView.frame=CGRectMake(viewW*38/view_fix_width, viewH*85/view_fix_height,viewW*300/view_fix_width, viewH*48/view_fix_height);
    _ssidView.userInteractionEnabled=YES;
    _ssidListView.backgroundColor=[UIColor whiteColor];
    _ssidView.image=[UIImage imageNamed:@"input_sel@3x.png"];
    [_mainBg addSubview:_ssidView];
    
    _ssidField= [[UITextField alloc] initWithFrame:CGRectMake(viewW*42/view_fix_width, viewH*85/view_fix_height,viewW*254/view_fix_width, viewH*48/view_fix_height)];
    _ssidField.font = [UIFont systemFontOfSize: choose_text_size];
    _ssidField.backgroundColor = [UIColor clearColor];
    _ssidField.textColor = [UIColor blackColor];
    _ssidField.delegate = self;
    _ssidField.textAlignment=NSTextAlignmentLeft;
    [_mainBg addSubview:_ssidField];
    
    _ssidImg=[UIButton buttonWithType:UIButtonTypeCustom];
    _ssidImg.frame = CGRectMake(viewW*294/view_fix_width, viewH*85/view_fix_height,viewH*48/view_fix_height, viewH*48/view_fix_height);
    [_ssidImg setImage:[UIImage imageNamed:@"down_nor@3x.png"] forState:UIControlStateNormal];
    _ssidImg.contentHorizontalAlignment=UIControlContentHorizontalAlignmentCenter;
    [_ssidImg addTarget:nil action:@selector(_ssidImgClick) forControlEvents:UIControlEventTouchUpInside];
    //[_mainBg  addSubview:_ssidImg];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillResignActive)
                                                 name:UIApplicationWillResignActiveNotification object:nil]; //监听是否触发home键挂起程序.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActive)
                                                 name:UIApplicationDidBecomeActiveNotification object:nil]; //监听是否重新进入程序程序.
}

- (void)applicationWillResignActive{

}

- (void)applicationDidBecomeActive{
    _ssidField.text=[CommanParameters getWifiName];
    _pskField.text=[CommanParameters Get_String:_ssidField.text];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewDidAppear:(BOOL)animated
{
    _ssidField.text=[CommanParameters getWifiName];
    _pskField.text=[CommanParameters Get_String:_ssidField.text];
    [super viewDidAppear:animated];
}

- (void) viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

-(BOOL)parseJsonString:(NSString *)str{
    BOOL isFind=NO;
    NSString *srcStr=str;
    NSString *keyStr=@"\"ssid\":\"";
    NSString *endStr=@"\"";
    while(true){
        NSRange range=[srcStr rangeOfString:keyStr];
        if (range.location != NSNotFound) {
            int i=(int)range.location;
            srcStr=[srcStr substringFromIndex:i+keyStr.length];
            NSRange range1=[srcStr rangeOfString:endStr];
            if (range1.location != NSNotFound) {
                int j=(int)range1.location;
                NSRange diffRange=NSMakeRange(0, j);
                NSString *_ssid=[srcStr substringWithRange:diffRange];
                if ([_ssid isEqualToString:_ssidField.text]) {
                    isFind=YES;
                    break;
                }
            }
            else{
                break;
            }
        }else{
            break;
        }
    }
    return isFind;
}

/**
 * 弹窗
 */
-(void)checkViewInit{
    NSString *message=[NSString stringWithFormat:@"%@\"%@\"%@",NSLocalizedString(@"check_network_dialog_text1", nil),
                       _ssidField.text,NSLocalizedString(@"check_network_dialog_text2", nil)];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"check_network_dialog_title", nil) message:message preferredStyle:UIAlertControllerStyleAlert];
    
//    //修改标题的内容，字号，颜色。使用的key值是“attributedTitle”
//    NSMutableAttributedString *hogan = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"delete_device_dialog_text", nil)];
//    [hogan addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:main_text_size] range:NSMakeRange(0, [[hogan string] length])];
//    [hogan addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, [[hogan string] length])];
//    [alertController setValue:hogan forKey:@"attributedTitle"];
    //Yes
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"check_network_dialog_ok", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSLog(@"Yes");
        NSURL *url = [NSURL URLWithString:@"prefs:root=WIFI"];
        if ([[UIApplication sharedApplication] canOpenURL:url])
        {
            [[UIApplication sharedApplication] openURL:url];;
        }
        [self checkViewInit];
    }];
    [defaultAction setValue:INFO_TEXT_COLOR forKey:@"_titleTextColor"];
    //Cancel
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"check_network_dialog_cancel", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSLog(@"Cancel");
        NSString *wifiName=[CommanParameters getWifiName];
        if (wifiName!=nil) {
            if ([wifiName isEqualToString:_ssidField.text]) {
//                ApAddWaitViewController *v = [[ApAddWaitViewController alloc] init];
//                v.apAddWaitDeviceId=_apAddDeviceId;
//                [self.navigationController pushViewController: v animated:true];
            }
            else{
                [self checkViewInit];
                //[CommanParameters showAllTextDialog:self.view :[NSString stringWithFormat:@"Not connected to %@",_ssidField.text]];
            }
        }
        else{
            [self checkViewInit];
            //[CommanParameters showAllTextDialog:self.view :[NSString stringWithFormat:@"Not connected to %@",_ssidField.text]];
        }
    }];
    [cancelAction setValue:INFO_TEXT_COLOR forKey:@"_titleTextColor"];
    
    [alertController addAction:defaultAction];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)_backBtnClick{
    NSLog(@"_backBtnClick");
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)_switchBtnClick{
    NSLog(@"_switchBtnClick");
    [CommanParameters gotoWifiSettings];
}

//Ap config
- (void)_apAddStep3ContinueBtnClick{
    NSLog(@"_apAddStep3ContinueBtnClick");
    if ([_ssidField.text isEqualToString:@""]) {
        [CommanParameters showAllTextDialog:self.view :NSLocalizedString(@"main_config_ssid_error", nil)];
        return;
    }
    [CommanParameters Save_String:_pskField.text :_ssidField.text];
    ApAddStep2ViewController *v = [[ApAddStep2ViewController alloc] init];
    v.apAddStep2Ssid=_ssidField.text;
    v.apAddStep2Psk=_pskField.text;
    [self.navigationController pushViewController: v animated:true];
}

//Get SSID List
- (void)_ssidImgClick{
    NSLog(@"_ssidImgClick");
    _ssidBgView.hidden=YES;
    _wifiList=[CommanParameters Get_MutableArray:CONFIGURED_SSID];
    if (_wifiList!=nil) {
        if ([_wifiList count]>0) {
            _ssidBgView.hidden=NO;
            [_ssidListView reloadData];
        }
    }
}

//Show or Hide password
- (void)_pskImgClick{
    NSLog(@"_pskImgClick");
    if (_pskField.secureTextEntry) {
        _pskField.secureTextEntry = NO;
        [_pskImg setImage:[UIImage imageNamed:@"on@3x.png"] forState:UIControlStateNormal];
    }
    else{
        _pskField.secureTextEntry = YES;
        [_pskImg setImage:[UIImage imageNamed:@"off@3x.png"] forState:UIControlStateNormal];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return ssid_list_row_height;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_wifiList count];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.frame=CGRectMake(10, 0, viewW, device_info_list_row_height);
    cell.textLabel.text=_wifiList[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _ssidField.text=_wifiList[indexPath.row];
    _pskField.text=[CommanParameters Get_String:_ssidField.text];
    _ssidBgView.hidden=YES;
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

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    //隐藏键盘
    [_ssidField resignFirstResponder];
    [_pskField resignFirstResponder];
}

// 开始编辑输入框时，键盘出现，视图的Y坐标向上移动offset个单位，腾出空间显示键盘
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    CGRect textFrame = textField.frame;
    CGPoint textPoint = [textField convertPoint:CGPointMake(0, textField.frame.size.height) toView:self.view];// 关键的一句，一定要转换
    int offset = textPoint.y + textFrame.size.height + 216 - self.view.frame.size.height + 70;// 50是textfield和键盘上方的间距，可以自由设定
    
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    
    // 将视图的Y坐标向上移动offset个单位，以使下面腾出地方用于软键盘的显示
    if (offset > 0) {
        self.view.frame = CGRectMake(0.0f, -offset, self.view.frame.size.width, self.view.frame.size.height);
    }
    
    [UIView commitAnimations];
}

// 用户输入时
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    // 输入结束后，将视图恢复到原始状态
    self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    return YES;
}
@end
