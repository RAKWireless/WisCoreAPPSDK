//
//  ApAddWaitViewController.m
//  WisCore
//
//  Created by rakwireless on 2017/4/23.
//  Copyright © 2017年 rak. All rights reserved.
//

#import "ApAddWaitViewController.h"
#import "CommanParameters.h"
#import "Rak_Lx52x_Device_Control.h"
#import "DeviceData.h"
#import "DeviceInfo.h"
#import "ApAddEndViewController.h"

@interface ApAddWaitViewController ()
{
    int count;
    NSTimer *_scanTimer;
    bool _isExit;
    bool _isConfigured;
    Rak_Lx52x_Device_Control *_deviceScan;
    DeviceData *_deviceData;
}
@end

@implementation ApAddWaitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = NO;
    _isExit = NO;
    _isConfigured = NO;
    if ([_apAddWaitSsid isEqualToString:@""]) {
        _isConfigured = YES;
    }
    
    [self.view setBackgroundColor:INFO_TEXT_COLOR];
    
    _backBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    _backBtn.frame = CGRectMake(0, 0, viewH*44/view_fix_height, viewH*44/view_fix_height);
    [_backBtn setImage:[UIImage imageNamed:@"pre_nor@3x.png"] forState:UIControlStateNormal];
    [_backBtn setImage:[UIImage imageNamed:@"pre_pre@3x.png"] forState:UIControlStateHighlighted];
    [_backBtn setTitleColor:[UIColor lightGrayColor]forState:UIControlStateNormal];
    [_backBtn setTitleColor:[UIColor grayColor]forState:UIControlStateHighlighted];
    _backBtn.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
    [_backBtn addTarget:nil action:@selector(_backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view  addSubview:_backBtn];
    
    _noteTitle= [[UILabel alloc] initWithFrame:CGRectMake(viewW*50/view_fix_width, viewH*206/view_fix_height,viewW-viewW*100/view_fix_width, viewH*20/view_fix_height)];
    _noteTitle.text = NSLocalizedString(@"main_add_wait_label1", nil);
    _noteTitle.font = [UIFont boldSystemFontOfSize: main_text_size];
    _noteTitle.backgroundColor = [UIColor clearColor];
    _noteTitle.textColor = [UIColor blackColor];
    _noteTitle.numberOfLines = 0;
    _noteTitle.textAlignment=NSTextAlignmentLeft;
    [self.view addSubview:_noteTitle];
    
    _noteText= [[UILabel alloc] initWithFrame:CGRectMake(viewW*50/view_fix_width, viewH*238/view_fix_height,viewW-viewW*100/view_fix_width, viewH*20/view_fix_height)];
    _noteText.textColor=MAIN_TEXT_COLOR;
    _noteText.font = [UIFont systemFontOfSize: contact_text_size];
    _noteText.backgroundColor = [UIColor clearColor];
    _noteText.numberOfLines = 0;
    _noteText.text = NSLocalizedString(@"main_add_wait_label2", nil);
    _noteText.lineBreakMode = UILineBreakModeWordWrap;
    _noteText.textAlignment=NSTextAlignmentLeft;
    [self.view addSubview:_noteText];
    
    _noteProgress=[[UIProgressView alloc]initWithProgressViewStyle:UIProgressViewStyleDefault];
    //设置的高度对进度条的高度没影响，整个高度=进度条的高度，进度条也是个圆角矩形
    //但slider滑动控件：设置的高度对slider也没影响，但整个高度=设置的高度，可以设置背景来检验
    _noteProgress.frame=CGRectMake(viewW*18/view_fix_width, viewH*379/view_fix_height,viewW-viewW*70/view_fix_width, viewH*14/view_fix_height);
    _noteProgress.transform = CGAffineTransformMakeScale(1.0f,12.0f);
    //设置进度条颜色
    _noteProgress.trackTintColor=[UIColor whiteColor];
    //设置进度默认值，这个相当于百分比，范围在0~1之间，不可以设置最大最小值
    _noteProgress.progress=0.0;
    //设置进度条上进度的颜色
    _noteProgress.progressTintColor=PROGRESS_COLOR;
    [self.view addSubview:_noteProgress];
    
    _noteProgressValue= [[UILabel alloc] initWithFrame:CGRectMake(viewW-viewW*50/view_fix_width, 0,viewW*40/view_fix_width, viewH*14/view_fix_height)];
    _noteProgressValue.center=CGPointMake(_noteProgressValue.center.x, _noteProgress.center.y);
    _noteProgressValue.textColor=[UIColor whiteColor];
    _noteProgressValue.font = [UIFont systemFontOfSize: about_copyright_size];
    _noteProgressValue.backgroundColor = [UIColor clearColor];
    _noteProgressValue.numberOfLines = 0;
    _noteProgressValue.text = @"0%";
    _noteProgressValue.lineBreakMode = UILineBreakModeWordWrap;
    _noteProgressValue.textAlignment=NSTextAlignmentLeft;
    [self.view addSubview:_noteProgressValue];
    
    _isExit=NO;
    count=0;
    _scanTimer=[NSTimer scheduledTimerWithTimeInterval:0.6 target:self selector:@selector(_scanTimerCount) userInfo:nil repeats:YES];
    [self scanDevice];

}

- (void)_backBtnClick{
    _isExit=YES;
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)_scanTimerCount{
    count++;
    _noteProgress.progress=count/100.0;
    _noteProgressValue.text=[NSString stringWithFormat:@"%d%@",(int)(count),@"%"];
    if (count>100) {
        _isExit=YES;
        count=0;
        [_scanTimer invalidate];
        _scanTimer = nil;
        ApAddEndViewController *v = [[ApAddEndViewController alloc] init];
        v.apAddSuccess=@"no";
        v.apAddEndSsid=_apAddWaitSsid;
        v.apAddEndDeviceId=_apAddWaitDeviceId;
        [self.navigationController pushViewController: v animated:true];
    }
}

#pragma mark -- scanDevice
- (void)scanDevice
{
    if (_isExit) {
        return;
    }
    [NSThread detachNewThreadSelector:@selector(scanDeviceTask) toTarget:self withObject:nil];
}

- (void)scanDeviceTask
{
    _deviceScan = [[Rak_Lx52x_Device_Control alloc] init];
    Lx52x_Device_Info *result = [_deviceScan ScanDeviceWithTime:1.5f];
    [self performSelectorOnMainThread:@selector(scanDeviceOver:) withObject:result waitUntilDone:NO];
}

//Listen
-(void)setOnResultListener:(int)statusCode :(NSString*)body :(int)type{
    if (type==JOIN_WIFI) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (statusCode==200)
            {
                [_apWaitParametersConfig restartNet];
            }
            else{
                _isExit=YES;
                count=0;
                [_scanTimer invalidate];
                _scanTimer = nil;
                ApAddEndViewController *v = [[ApAddEndViewController alloc] init];
                v.apAddSuccess=@"no";
                v.apAddEndSsid=_apAddWaitSsid;
                v.apAddEndDeviceId=_apAddWaitDeviceId;
                [self.navigationController pushViewController: v animated:true];
                [CommanParameters showAllTextDialog:self.view :NSLocalizedString(@"main_config_ssid_timeout", nil)];
            }
        });
    }
    else if (type==RESTART_NET) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (statusCode==200)
            {
                _isConfigured=YES;
                [NSThread sleepForTimeInterval:2.0];
                [self scanDevice];
            }
            else{
                _isExit=YES;
                count=0;
                [_scanTimer invalidate];
                _scanTimer = nil;
                ApAddEndViewController *v = [[ApAddEndViewController alloc] init];
                v.apAddSuccess=@"no";
                v.apAddEndSsid=_apAddWaitSsid;
                v.apAddEndDeviceId=_apAddWaitDeviceId;
                [self.navigationController pushViewController: v animated:true];
                [CommanParameters showAllTextDialog:self.view :NSLocalizedString(@"main_config_reset_failed", nil)];
            }
        });
    }
}

- (void)scanDeviceOver:(Lx52x_Device_Info *)result;
{
    if (result.Device_ID_Arr.count > 0) {
        NSLog(@"Scan Over...");
        if (_isConfigured) {
            bool tempsame=NO;
            int idx=0;
            for (idx=0;idx<result.Device_ID_Arr.count;idx++) {
                NSString *deviceId = [result.Device_ID_Arr objectAtIndex:idx];
                if ([deviceId compare:_apAddWaitDeviceId]==NSOrderedSame){
                    tempsame=YES;
                    break;
                }
            }
            if (tempsame) {
                _isExit=YES;
                [_scanTimer invalidate];
                _scanTimer = nil;
                DeviceData *_device_Data=[[DeviceData alloc]init];
                DeviceInfo *device=[[DeviceInfo alloc]init];
                device.deviceID=[result.Device_ID_Arr objectAtIndex:idx];
                device.deviceIp=[result.Device_IP_Arr objectAtIndex:idx];
                device.deviceName=[_device_Data getDeviceNameById:device.deviceID];
                device.deviceStatus=_deviceOffline;
                [_device_Data saveDeviceById:device.deviceID :device.deviceName :device.deviceIp :_deviceOffline];
                ApAddEndViewController *v = [[ApAddEndViewController alloc] init];
                v.apAddSuccess=@"yes";
                v.apAddEndSsid=_apAddWaitSsid;
                v.apAddEndDeviceId=_apAddWaitDeviceId;
                [self.navigationController pushViewController: v animated:true];
            }
            else{
                [self scanDevice];
            }
        }
        else{
            _apAddWaitDeviceId=[result.Device_ID_Arr objectAtIndex:0];
            _apWaitParametersConfig=[[ParametersConfig alloc]init:self ip:[result.Device_IP_Arr objectAtIndex:0] password:@"admin"];
             [_apWaitParametersConfig joinWifi:_apAddWaitSsid :_apAddWaitPsk :@"psk2"];
        }
    }
    else
    {
        NSLog(@"Scan nothing...");
        [self scanDevice];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
