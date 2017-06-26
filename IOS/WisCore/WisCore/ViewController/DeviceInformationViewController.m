//
//  DeviceInformationViewController.m
//  WisCore
//
//  Created by rakwireless on 2017/4/20.
//  Copyright © 2017年 rak. All rights reserved.
//

#import "DeviceInformationViewController.h"
#import "CommanParameters.h"
#import "LoadingView.h"

@interface DeviceInformationViewController ()
{
    LoadingView *_loadingView;
}
@end

@implementation DeviceInformationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:MAIN_BG_COLOR];
    _infoParametersConfig=[[ParametersConfig alloc]init:self ip:_infoDeviceIp password:@"admin"];
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
    _topTitle.text = NSLocalizedString(@"main_device_device_info", nil);
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
    
    UIView *_bg=[[UIView alloc]init];
    _bg.frame = CGRectMake(0, viewH*64/view_fix_height, viewW, viewH*157/view_fix_height);
    _bg.userInteractionEnabled=YES;
    [_bg setBackgroundColor:MAIN_TEXT_BG_COLOR];
    [self.view addSubview:_bg];
    
    _informationViewImg=[[UIImageView alloc]init];
    _informationViewImg.frame=CGRectMake(0, viewH*40/view_fix_height, viewH*70/view_fix_height, viewH*70/view_fix_height);
    _informationViewImg.center=CGPointMake(viewW*0.5, _informationViewImg.center.y);
    _informationViewImg.image=[UIImage imageNamed:@"teal@3x.png"];
    [_bg addSubview:_informationViewImg];
    
    _informationTableview= [[UITableView alloc] initWithFrame:CGRectMake(0, viewH*156/view_fix_height, viewW, viewH*48*3/view_fix_height) style:UITableViewStylePlain];
    _informationTableview.dataSource = self;
    _informationTableview.delegate = self;
    _informationTableview.scrollEnabled =NO;
    _informationTableview.backgroundColor=[UIColor whiteColor];
    _informationTableview.separatorInset=UIEdgeInsetsMake(0, 0, 0, 0);
    [_mainBg addSubview:_informationTableview];
    
    _infoDeviceNameLabel= [[UILabel alloc] initWithFrame:CGRectMake(viewW*0.5-viewW*12/view_fix_width, viewH*170/view_fix_height,viewW*0.5, viewH*20/view_fix_height)];
    _infoDeviceNameLabel.text = _infoDeviceName;
    _infoDeviceNameLabel.font = [UIFont systemFontOfSize: main_text_size];
    _infoDeviceNameLabel.backgroundColor = [UIColor clearColor];
    _infoDeviceNameLabel.textColor = INFO_TEXT_COLOR;
    _infoDeviceNameLabel.numberOfLines = 0;
    _infoDeviceNameLabel.textAlignment=NSTextAlignmentRight;
    [_mainBg addSubview:_infoDeviceNameLabel];
    
    _infoSNLabel= [[UILabel alloc] initWithFrame:CGRectMake(viewW*0.5-viewW*12/view_fix_width, viewH*218/view_fix_height,viewW*0.5, viewH*20/view_fix_height)];
    _infoSNLabel.text = @"";
    _infoSNLabel.font = [UIFont systemFontOfSize: main_text_size];
    _infoSNLabel.backgroundColor = [UIColor clearColor];
    _infoSNLabel.textColor = INFO_TEXT_COLOR;
    _infoSNLabel.numberOfLines = 0;
    _infoSNLabel.textAlignment=NSTextAlignmentRight;
    [_mainBg addSubview:_infoSNLabel];
    
    _infoFWLabel= [[UILabel alloc] initWithFrame:CGRectMake(viewW*120/view_fix_width, viewH*252/view_fix_height,viewW-viewW*122/view_fix_width, viewH*48/view_fix_height)];
    _infoFWLabel.text = @"";
    _infoFWLabel.font = [UIFont systemFontOfSize: main_text_size];
    _infoFWLabel.backgroundColor = [UIColor clearColor];
    _infoFWLabel.textColor = INFO_TEXT_COLOR;
    _infoFWLabel.numberOfLines = 0;
    _infoFWLabel.textAlignment=NSTextAlignmentRight;
    [_mainBg addSubview:_infoFWLabel];
    
    _loadingView = [[LoadingView alloc] initWithFrame:self.view.frame];
    [_loadingView setLoadingShow:NO :@""];
    [self.view addSubview:_loadingView];
    [_loadingView setLoadingShow:YES :NSLocalizedString(@"main_get_device_info_text", nil)];
    [_infoParametersConfig getVersion];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//Listen
-(void)setOnResultListener:(int)statusCode :(NSString*)body :(int)type{
    [_loadingView setLoadingShow:NO :@""];
    if (type==GET_VERSION) {
        NSLog(@"%@",body);
        dispatch_async(dispatch_get_main_queue(), ^{
            if (statusCode==200) {
                _infoFWLabel.text=body;
            }
            else{
                [CommanParameters showAllTextDialog:self.view :NSLocalizedString(@"main_get_device_info_failed", nil)];    
            }
        });
    }
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
    UITableViewCell *cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.frame=CGRectMake(10, 0, viewW, device_info_list_row_height);
    
    switch (indexPath.row) {
        case 0:
        {
            cell.textLabel.text=NSLocalizedString(@"main_information_name", nil);
            break;
        }
        case 1:
        {
            cell.textLabel.text=NSLocalizedString(@"main_information_sn", nil);
            break;
        }
        case 2:
        {
            cell.textLabel.text=NSLocalizedString(@"main_information_fw", nil);
            break;
        }
        default:
            break;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
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
