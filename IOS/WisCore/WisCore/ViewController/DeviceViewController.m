//
//  DeviceViewController.m
//  WisCore
//
//  Created by rakwireless on 2017/4/20.
//  Copyright © 2017年 rak. All rights reserved.
//

#import "DeviceViewController.h"
#import "CommanParameters.h"
#import "DeviceInformationViewController.h"
#import "NetworkInformationViewController.h"
#import "LoginStep1ViewController.h"
#import "LogoutViewController.h"

@interface DeviceViewController ()

@end

@implementation DeviceViewController

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
    _topTitle.text = _deviceName;
    _topTitle.center=CGPointMake(_topBg.center.x, _topTitle.center.y);
    _topTitle.font = [UIFont boldSystemFontOfSize: main_title_size];
    _topTitle.backgroundColor = [UIColor clearColor];
    _topTitle.textColor = [UIColor blackColor];
    _topTitle.numberOfLines = 0;
    _topTitle.textAlignment=NSTextAlignmentCenter;
    [_topBg addSubview:_topTitle];
    
    //主界面
    _mainBg=[[UIView alloc]init];
    _mainBg.frame = CGRectMake(0, viewH*64/view_fix_height, viewW, viewH*300/view_fix_height);
    _mainBg.userInteractionEnabled=YES;
    [_mainBg setBackgroundColor:MAIN_TEXT_BG_COLOR];
    [self.view addSubview:_mainBg];
    
    _deviceViewImg=[[UIImageView alloc]init];
    _deviceViewImg.frame=CGRectMake(0, viewH*40/view_fix_height, viewH*70/view_fix_height, viewH*70/view_fix_height);
    _deviceViewImg.center=CGPointMake(viewW*0.5, _deviceViewImg.center.y);
    _deviceViewImg.image=[UIImage imageNamed:@"teal@3x.png"];
    [_mainBg addSubview:_deviceViewImg];
    
    _deviceInfoTableview= [[UITableView alloc] initWithFrame:CGRectMake(0, viewH*156/view_fix_height, viewW, viewH*48*3/view_fix_height) style:UITableViewStylePlain];
    _deviceInfoTableview.dataSource = self;
    _deviceInfoTableview.delegate = self;
    _deviceInfoTableview.backgroundColor=[UIColor whiteColor];
    _deviceInfoTableview.separatorInset=UIEdgeInsetsMake(0, 0, 0, 0);
    [_mainBg  addSubview:_deviceInfoTableview];
    _deviceViewParametersConfig=[[ParametersConfig alloc]init:self ip:_deviceIp password:@"admin"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)_backBtnClick{
    NSLog(@"_backBtnClick");
    [self.navigationController popViewControllerAnimated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return device_info_list_row_height;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UIImage *image=[UIImage imageNamed:@"amazon alexa@3x.png"];
    UITableViewCell *cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.frame=CGRectMake(10, 0, viewW, device_info_list_row_height);
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    switch (indexPath.row) {
        case 0:
        {
            cell.textLabel.text=NSLocalizedString(@"main_device_device_info", nil);
            break;
        }
        case 1:
        {
            cell.textLabel.text=NSLocalizedString(@"main_device_network_info", nil);
            break;
        }
        case 2:
        {
            cell.imageView.image=image;
            cell.textLabel.text=NSLocalizedString(@"main_device_amazon_info", nil);
            break;
        }
        default:
            break;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
        {
            DeviceInformationViewController *v = [[DeviceInformationViewController alloc] init];
            v.infoDeviceName=_topTitle.text;
            v.infoDeviceIp=_deviceIp;
            [self.navigationController pushViewController: v animated:true];
            break;
        }
        case 1:
        {
            NetworkInformationViewController *v = [[NetworkInformationViewController alloc] init];
            v.networkDeviceIp=_deviceIp;
            [self.navigationController pushViewController: v animated:true];
            break;
        }
        case 2:
        {
            [_deviceViewParametersConfig alexaLoginStatus];
            break;
        }
        default:
            break;
    }
    
}

//Listen
-(void)setOnResultListener:(int)statusCode :(NSString*)body :(int)type{
    if (type==GET_LOGIN_STATUS) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (statusCode==200) {
                NSLog(@"%@",body);
                if ([body isEqualToString:@"{\"value\": \"1\"}"]) {
                    LogoutViewController *v = [[LogoutViewController alloc] init];
                    v.loginOutStep1DeviceIp=_deviceIp;
                    [self.navigationController pushViewController: v animated:true];
                }
                else{
                    LoginStep1ViewController *v = [[LoginStep1ViewController alloc] init];
                    v.loginStep1DeviceIp=_deviceIp;
                    [self.navigationController pushViewController: v animated:true];
                }
            }
            else{
                LoginStep1ViewController *v = [[LoginStep1ViewController alloc] init];
                v.loginStep1DeviceIp=_deviceIp;
                [self.navigationController pushViewController: v animated:true];
            }
        });
    }
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
