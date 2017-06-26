//
//  NetworkInformationViewController.m
//  WisCore
//
//  Created by rakwireless on 2017/4/20.
//  Copyright © 2017年 rak. All rights reserved.
//

#import "NetworkInformationViewController.h"
#import "CommanParameters.h"
#import "LoadingView.h"

@interface NetworkInformationViewController ()
{
    LoadingView *_loadingView;
}
@end

@implementation NetworkInformationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:MAIN_BG_COLOR];
    _networkParametersConfig=[[ParametersConfig alloc]init:self ip:_networkDeviceIp password:@"admin"];
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
    _topTitle.text = NSLocalizedString(@"main_device_network_info", nil);
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
    
    _networkViewImg=[[UIImageView alloc]init];
    _networkViewImg.frame=CGRectMake(0, viewH*40/view_fix_height, viewH*70/view_fix_height, viewH*70/view_fix_height);
    _networkViewImg.center=CGPointMake(viewW*0.5, _networkViewImg.center.y);
    _networkViewImg.image=[UIImage imageNamed:@"teal@3x.png"];
    [_bg addSubview:_networkViewImg];
    
    _networkTableview= [[UITableView alloc] initWithFrame:CGRectMake(0, viewH*156/view_fix_height, viewW, viewH*48*4/view_fix_height) style:UITableViewStylePlain];
    _networkTableview.dataSource = self;
    _networkTableview.delegate = self;
    _networkTableview.scrollEnabled=NO;
    _networkTableview.backgroundColor=[UIColor whiteColor];
    _networkTableview.separatorInset=UIEdgeInsetsMake(0, 0, 0, 0);
    [_mainBg addSubview:_networkTableview];
    
    _networkSSIDLabel= [[UILabel alloc] initWithFrame:CGRectMake(viewW*0.5-viewW*12/view_fix_width, viewH*170/view_fix_height,viewW*0.5, viewH*20/view_fix_height)];
    _networkSSIDLabel.text = @"";
    _networkSSIDLabel.font = [UIFont systemFontOfSize: main_text_size];
    _networkSSIDLabel.backgroundColor = [UIColor clearColor];
    _networkSSIDLabel.textColor = INFO_TEXT_COLOR;
    _networkSSIDLabel.numberOfLines = 0;
    _networkSSIDLabel.textAlignment=NSTextAlignmentRight;
    [_mainBg addSubview:_networkSSIDLabel];
    
    _networkMACLabel= [[UILabel alloc] initWithFrame:CGRectMake(viewW*0.5-viewW*12/view_fix_width, viewH*266/view_fix_height,viewW*0.5, viewH*20/view_fix_height)];
    _networkMACLabel.text = @"";
    _networkMACLabel.font = [UIFont systemFontOfSize: main_text_size];
    _networkMACLabel.backgroundColor = [UIColor clearColor];
    _networkMACLabel.textColor = INFO_TEXT_COLOR;
    _networkMACLabel.numberOfLines = 0;
    _networkMACLabel.textAlignment=NSTextAlignmentRight;
    [_mainBg addSubview:_networkMACLabel];
    
    UIView *_bg2=[[UIView alloc]init];
    _bg2.frame = CGRectMake(0, viewH*410/view_fix_height, viewW, viewH*5/view_fix_height);
    _bg2.userInteractionEnabled=YES;
    [_bg2 setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:_bg2];
    
    //IPV4
    _networkIPV4= [[UILabel alloc] initWithFrame:CGRectMake(viewW*60/view_fix_width, viewH*349/view_fix_height,viewW*100/view_fix_width, viewH*20/view_fix_height)];
    _networkIPV4.text = NSLocalizedString(@"main_network_ip_info", nil);
    _networkIPV4.font = [UIFont systemFontOfSize: main_text_size];
    _networkIPV4.backgroundColor = [UIColor clearColor];
    _networkIPV4.textColor = ADD_NOTE_COLOR;
    _networkIPV4.numberOfLines = 0;
    _networkIPV4.textAlignment=NSTextAlignmentLeft;
    [_mainBg addSubview:_networkIPV4];
    
    _networkIPV4Value= [[UILabel alloc] initWithFrame:CGRectMake(viewW*0.5, viewH*349/view_fix_height,viewW*120/view_fix_width, viewH*20/view_fix_height)];
    _networkIPV4Value.font = [UIFont systemFontOfSize: main_text_size];
    _networkIPV4Value.backgroundColor = [UIColor clearColor];
    _networkIPV4Value.textColor = INFO_TEXT_COLOR;
    _networkIPV4Value.numberOfLines = 0;
    _networkIPV4Value.textAlignment=NSTextAlignmentLeft;
    [_mainBg addSubview:_networkIPV4Value];
    
    //Mask
    _networkMask= [[UILabel alloc] initWithFrame:CGRectMake(viewW*60/view_fix_width, viewH*371/view_fix_height,viewW*100/view_fix_width, viewH*20/view_fix_height)];
    _networkMask.text = NSLocalizedString(@"main_network_ip_mask", nil);
    _networkMask.font = [UIFont systemFontOfSize: main_text_size];
    _networkMask.backgroundColor = [UIColor clearColor];
    _networkMask.textColor = ADD_NOTE_COLOR;
    _networkMask.numberOfLines = 0;
    _networkMask.textAlignment=NSTextAlignmentLeft;
    [_mainBg addSubview:_networkMask];
    
    _networkMaskValue= [[UILabel alloc] initWithFrame:CGRectMake(viewW*0.5, viewH*371/view_fix_height,viewW*120/view_fix_width, viewH*20/view_fix_height)];
    _networkMaskValue.font = [UIFont systemFontOfSize: main_text_size];
    _networkMaskValue.backgroundColor = [UIColor clearColor];
    _networkMaskValue.textColor = INFO_TEXT_COLOR;
    _networkMaskValue.numberOfLines = 0;
    _networkMaskValue.textAlignment=NSTextAlignmentLeft;
    [_mainBg addSubview:_networkMaskValue];
    
    //Gateway
    _networkGateway= [[UILabel alloc] initWithFrame:CGRectMake(viewW*60/view_fix_width, viewH*393/view_fix_height,viewW*100/view_fix_width, viewH*20/view_fix_height)];
    _networkGateway.text = NSLocalizedString(@"main_network_ip_gateway", nil);
    _networkGateway.font = [UIFont systemFontOfSize: main_text_size];
    _networkGateway.backgroundColor = [UIColor clearColor];
    _networkGateway.textColor = ADD_NOTE_COLOR;
    _networkGateway.numberOfLines = 0;
    _networkGateway.textAlignment=NSTextAlignmentLeft;
    [_mainBg addSubview:_networkGateway];
    
    _networkGatewayValue= [[UILabel alloc] initWithFrame:CGRectMake(viewW*0.5, viewH*393/view_fix_height,viewW*120/view_fix_width, viewH*20/view_fix_height)];
    _networkGatewayValue.font = [UIFont systemFontOfSize: main_text_size];
    _networkGatewayValue.backgroundColor = [UIColor clearColor];
    _networkGatewayValue.textColor = INFO_TEXT_COLOR;
    _networkGatewayValue.numberOfLines = 0;
    _networkGatewayValue.textAlignment=NSTextAlignmentLeft;
    [_mainBg addSubview:_networkGatewayValue];
    
    //DNS
    _networkDNS= [[UILabel alloc] initWithFrame:CGRectMake(viewW*60/view_fix_width, viewH*415/view_fix_height,viewW*100/view_fix_width, viewH*20/view_fix_height)];
    _networkDNS.text = NSLocalizedString(@"main_network_ip_dns", nil);
    _networkDNS.font = [UIFont systemFontOfSize: main_text_size];
    _networkDNS.backgroundColor = [UIColor clearColor];
    _networkDNS.textColor = ADD_NOTE_COLOR;
    _networkDNS.numberOfLines = 0;
    _networkDNS.textAlignment=NSTextAlignmentLeft;
    //[_mainBg addSubview:_networkDNS];
    
    _networkDNSValue= [[UILabel alloc] initWithFrame:CGRectMake(viewW*0.5, viewH*415/view_fix_height,viewW*120/view_fix_width, viewH*20/view_fix_height)];
    _networkDNSValue.text = NSLocalizedString(@"main_network_ip_dns", nil);
    _networkDNSValue.font = [UIFont systemFontOfSize: main_text_size];
    _networkDNSValue.backgroundColor = [UIColor clearColor];
    _networkDNSValue.textColor = INFO_TEXT_COLOR;
    _networkDNSValue.numberOfLines = 0;
    _networkDNSValue.textAlignment=NSTextAlignmentLeft;
    //[_mainBg addSubview:_networkDNSValue];
    
    _loadingView = [[LoadingView alloc] initWithFrame:self.view.frame];
    [_loadingView setLoadingShow:NO :@""];
    [self.view addSubview:_loadingView];
    [_loadingView setLoadingShow:YES :NSLocalizedString(@"main_get_network_info_text", nil)];
    [_networkParametersConfig getWifiStatus];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//Listen
-(void)setOnResultListener:(int)statusCode :(NSString*)body :(int)type{
    NSLog(@"%@",body);
    dispatch_async(dispatch_get_main_queue(), ^{
        [_loadingView setLoadingShow:NO :@""];
        if (type==GET_WIFI_STATUS) {
            if (statusCode==200) {
                _networkSSIDLabel.text=[self parseJsonString:body :@"\"ap_ssid\":\""];
                if ([_networkSSIDLabel.text isEqualToString:@""]==NO) {
                    _networkMACLabel.text=[self parseJsonString:body :@"\"ap_bssid\":\""];
                    _networkIPV4Value.text=[self parseJsonString:body :@"\"ap_addr\":\""];
                    _networkMaskValue.text=[self parseJsonString:body :@"\"ap_mask\":\""];
                    _networkGatewayValue.text=[self parseJsonString:body :@"\"ap_gateway\":\""];
                }
                else{
                    _networkSSIDLabel.text=[self parseJsonString:body :@"\"sta_ssid\":\""];
                    _networkMACLabel.text=[self parseJsonString:body :@"\"sta_bssid\":\""];
                    _networkIPV4Value.text=[self parseJsonString:body :@"\"sta_addr\":\""];
                    _networkMaskValue.text=[self parseJsonString:body :@"\"sta_mask\":\""];
                    _networkGatewayValue.text=[self parseJsonString:body :@"\"sta_gateway\":\""];
                }
            }
            else{
                [CommanParameters showAllTextDialog:self.view :NSLocalizedString(@"main_get_network_info_failed", nil)];
            }
        }
    });
}
//{"wifistatus":[{"ap_ssid":"RAK_2.4GHz_1","ap_bssid":"B8:F8:83:33:B6:8D","ap_channel":"6","ap_encryption":"WPA2 PSK (CCMP)","ap_addr":"192.168.230.1","ap_mask":"255.255.255.0"}]}

-(NSString *)parseJsonString:(NSString *)str :(NSString *)keyStr{
    NSString *srcStr=str;
    NSString *endStr=@"\"";
    NSString *_ssid=@"";
    NSRange range=[srcStr rangeOfString:keyStr];
    if (range.location != NSNotFound) {
        int i=(int)range.location;
        srcStr=[srcStr substringFromIndex:i+keyStr.length];
        NSRange range1=[srcStr rangeOfString:endStr];
        if (range1.location != NSNotFound) {
            int j=(int)range1.location;
            NSRange diffRange=NSMakeRange(0, j);
            _ssid=[srcStr substringWithRange:diffRange];
        }
    }
    return _ssid;
}


- (void)_backBtnClick{
    NSLog(@"_backBtnClick");
    [self.navigationController popViewControllerAnimated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return device_info_list_row_height;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
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
            cell.textLabel.text=NSLocalizedString(@"main_network_ssid", nil);
            break;
        }
        case 1:
        {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.textLabel.text=NSLocalizedString(@"main_network_update", nil);
            break;
        }
        case 2:
        {
            cell.textLabel.text=NSLocalizedString(@"main_network_mac", nil);
            break;
        }
        case 3:
        {
            cell.textLabel.text=NSLocalizedString(@"main_network_ip", nil);
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
            break;
        }
        case 1:
        {
            [CommanParameters showAllTextDialog:self.view :@"Waiting for development..."];
            break;
        }
        case 2:
        {
            break;
        }
        default:
            break;
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
