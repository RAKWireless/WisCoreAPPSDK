//
//  LogoutViewController.m
//  WisCore
//
//  Created by rakwireless on 2017/4/20.
//  Copyright © 2017年 rak. All rights reserved.
//

#import "LogoutViewController.h"
#import "CommanParameters.h"
#import "LoadingView.h"

@interface LogoutViewController ()
{
    LoadingView *_loadingView;
}
@end

@implementation LogoutViewController

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
    _topTitle.text = NSLocalizedString(@"main_logout_title", nil);
    _topTitle.center=CGPointMake(_topBg.center.x, _topTitle.center.y);
    _topTitle.font = [UIFont boldSystemFontOfSize: main_title_size];
    _topTitle.backgroundColor = [UIColor clearColor];
    _topTitle.textColor = [UIColor blackColor];
    _topTitle.numberOfLines = 0;
    _topTitle.textAlignment=NSTextAlignmentCenter;
    [_topBg addSubview:_topTitle];
    
    _logoutBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    _logoutBtn.frame=CGRectMake(viewW-viewW*92/view_fix_width, 0,viewW*80/view_fix_width, viewH*20/view_fix_height);
    _logoutBtn.center=CGPointMake(_logoutBtn.center.x, _topTitle.center.y);
    _logoutBtn.titleLabel.font = [UIFont systemFontOfSize: main_text_size];
    _logoutBtn.backgroundColor = [UIColor clearColor];
    [_logoutBtn setTitle:NSLocalizedString(@"main_logout_sign_out", nil) forState:UIControlStateNormal];
    [_logoutBtn setTitleColor:LOGIN_TEXT_COLOR forState:UIControlStateNormal];
    [_logoutBtn setTitleColor:LOGIN_LINE_COLOR forState:UIControlStateHighlighted];
    [_logoutBtn addTarget:nil action:@selector(_logoutBtnClick) forControlEvents:UIControlEventTouchUpInside];
    _logoutBtn.contentHorizontalAlignment=UIControlContentHorizontalAlignmentRight;
    [_topBg addSubview:_logoutBtn];
    
    //主界面
    _mainBg=[[UIView alloc]init];
    _mainBg.frame = CGRectMake(0, viewH*64/view_fix_height, viewW, viewH-viewH*64/view_fix_height);
    _mainBg.userInteractionEnabled=YES;
    [_mainBg setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:_mainBg];
    
    _logoutImg=[[UIImageView alloc]init];
    _logoutImg.frame=CGRectMake(0, viewH*38/view_fix_height, viewH*87*558/261/view_fix_height, viewH*87/view_fix_height);
    _logoutImg.center=CGPointMake(viewW*0.5, _logoutImg.center.y);
    _logoutImg.image=[UIImage imageNamed:@"amazon alexa logo@3x.png"];
    [_mainBg addSubview:_logoutImg];
    
    _signOutTitle= [[UILabel alloc] initWithFrame:CGRectMake(viewW*25/view_fix_width, viewH*150/view_fix_height,viewW-viewW*50/view_fix_width, viewH*90/view_fix_height)];
    _signOutTitle.text = NSLocalizedString(@"main_logout_note", nil);
    _signOutTitle.font = [UIFont systemFontOfSize: main_text_size];
    _signOutTitle.backgroundColor = [UIColor clearColor];
    _signOutTitle.textColor = LOGIN_NOTE_COLOR;
    _signOutTitle.numberOfLines = 0;
    _signOutTitle.textAlignment=NSTextAlignmentCenter;
    [_mainBg addSubview:_signOutTitle];
    
    UIButton *_labelBtn1=[UIButton buttonWithType:UIButtonTypeCustom];
    _labelBtn1.frame = CGRectMake(viewW*32/view_fix_width, viewH*241/view_fix_height,viewW*220/view_fix_width, viewH*38/view_fix_height);
    [_labelBtn1 setTitle:NSLocalizedString(@"main_logout_ask1", nil) forState:UIControlStateNormal];
    [_labelBtn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_labelBtn1 setBackgroundImage:[UIImage imageNamed:@"cyan@3x.png"] forState:UIControlStateNormal];
    _labelBtn1.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
    _labelBtn1.titleLabel.font=[UIFont systemFontOfSize: contact_text_size];
    [_mainBg  addSubview:_labelBtn1];
    
    UIButton *_labelBtn2=[UIButton buttonWithType:UIButtonTypeCustom];
    _labelBtn2.frame = CGRectMake(viewW-viewW*252/view_fix_width, viewH*291/view_fix_height,viewW*220/view_fix_width, viewH*38/view_fix_height);
    [_labelBtn2 setTitle:NSLocalizedString(@"main_logout_ask2", nil) forState:UIControlStateNormal];
    [_labelBtn2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_labelBtn2 setBackgroundImage:[UIImage imageNamed:@"bule-gray@3x.png"] forState:UIControlStateNormal];
    _labelBtn2.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
    _labelBtn2.titleLabel.font=[UIFont systemFontOfSize: contact_text_size];
    [_mainBg  addSubview:_labelBtn2];
    
    UIButton *_labelBtn3=[UIButton buttonWithType:UIButtonTypeCustom];
    _labelBtn3.frame = CGRectMake(viewW*32/view_fix_width, viewH*341/view_fix_height,viewW*220/view_fix_width, viewH*38/view_fix_height);
    [_labelBtn3 setTitle:NSLocalizedString(@"main_logout_ask3", nil) forState:UIControlStateNormal];
    [_labelBtn3 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_labelBtn3 setBackgroundImage:[UIImage imageNamed:@"cyan@3x.png"] forState:UIControlStateNormal];
    _labelBtn3.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
    _labelBtn3.titleLabel.font=[UIFont systemFontOfSize: contact_text_size];
    [_mainBg  addSubview:_labelBtn3];
    
    UIButton *_labelBtn4=[UIButton buttonWithType:UIButtonTypeCustom];
    _labelBtn4.frame = CGRectMake(viewW-viewW*252/view_fix_width, viewH*391/view_fix_height,viewW*220/view_fix_width, viewH*38/view_fix_height);
    [_labelBtn4 setTitle:NSLocalizedString(@"main_logout_ask4", nil) forState:UIControlStateNormal];
    [_labelBtn4 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_labelBtn4 setBackgroundImage:[UIImage imageNamed:@"bule-gray@3x.png"] forState:UIControlStateNormal];
    _labelBtn4.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
    _labelBtn4.titleLabel.font=[UIFont systemFontOfSize: contact_text_size];
    [_mainBg  addSubview:_labelBtn4];
    
    UIView *line =[[UIImageView alloc]init];
    line.frame=CGRectMake(0, viewH*477/view_fix_height, viewW*312/view_fix_width, 1);
    line.center=CGPointMake(viewW*0.5, line.center.y);
    line.backgroundColor=LOGIN_LINE_COLOR;
    [_mainBg addSubview:line];
    
    _logoutInfo= [[UILabel alloc] initWithFrame:CGRectMake(viewW*55/view_fix_width, viewH*500/view_fix_height,viewW-viewW*110/view_fix_width, viewH*50/view_fix_height)];
    _logoutInfo.font = [UIFont systemFontOfSize: about_copyright_size];
    _logoutInfo.backgroundColor = [UIColor clearColor];
    _logoutInfo.textColor = LOGIN_NOTE2_COLOR;
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"main_logout_info", nil)];
    [str addAttribute:NSForegroundColorAttributeName value:LOGIN_TEXT_COLOR range:NSMakeRange(59,9)];
    _logoutInfo.attributedText=str;
    _logoutInfo.numberOfLines = 0;
    _logoutInfo.lineBreakMode = UILineBreakModeWordWrap;
    _logoutInfo.textAlignment=NSTextAlignmentCenter;
    [_mainBg addSubview:_logoutInfo];
    
    _loginOutStep1ParametersConfig=[[ParametersConfig alloc]init:self ip:_loginOutStep1DeviceIp password:@"admin"];
    _loadingView = [[LoadingView alloc] initWithFrame:self.view.frame];
    [_loadingView setLoadingShow:NO :@""];
    [self.view addSubview:_loadingView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//Listen
-(void)setOnResultListener:(int)statusCode :(NSString*)body :(int)type{
    if (type==ALEXA_SIGN_OUT) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [_loadingView setLoadingShow:NO :@""];
            if (statusCode==200) {
                NSLog(@"%@",body);
                if ([body isEqualToString:@"{\"value\": \"0\"}"]) {
                    [self.navigationController popViewControllerAnimated:YES];
                }
                else{
                    [CommanParameters showAllTextDialog:self.view :NSLocalizedString(@"main_logout_sign_out_failed", nil)];
                }
            }
            else{
                [CommanParameters showAllTextDialog:self.view :NSLocalizedString(@"main_logout_sign_out_failed", nil)];
            }
        });
        
    }
}

- (void)_backBtnClick{
    NSLog(@"_backBtnClick");
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)_logoutBtnClick{
    NSLog(@"_logoutBtnClick");
    //[AIMobileLib clearAuthorizationState:nil];
    [_loadingView setLoadingShow:YES :NSLocalizedString(@"main_logout_sign_out_text", nil)];
    [_loginOutStep1ParametersConfig alexaSignOut];
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
