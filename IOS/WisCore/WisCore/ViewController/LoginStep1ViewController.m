//
//  LoginStep1ViewController.m
//  WisCore
//
//  Created by rakwireless on 2017/4/20.
//  Copyright © 2017年 rak. All rights reserved.
//

#import "LoginStep1ViewController.h"
#import "CommanParameters.h"
#import "LogoutViewController.h"
#import <LoginWithAmazon/LoginWithAmazon.h>
#import "LoadingView.h"

@interface LoginStep1ViewController ()<AIAuthenticationDelegate>
{
    LoadingView *_loadingView;
    NSString *kProduct_id;
    NSString *kProduct_dsn;
    NSString *kCodeChallenge;
    NSString *kCodeChallengeMethod;
    
    
    NSString *kClient_id;
    NSString *kRedirectUri;
    NSString *kAuthCode;
    NSTimer *timeOut;
}
@end

@implementation LoginStep1ViewController

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
    _topTitle.text = NSLocalizedString(@"main_login_step1_title", nil);
    _topTitle.center=CGPointMake(_topBg.center.x, _topTitle.center.y);
    _topTitle.font = [UIFont boldSystemFontOfSize: main_title_size];
    _topTitle.backgroundColor = [UIColor clearColor];
    _topTitle.textColor = [UIColor blackColor];
    _topTitle.numberOfLines = 0;
    _topTitle.textAlignment=NSTextAlignmentCenter;
    [_topBg addSubview:_topTitle];
    
    _skipTitle= [[UILabel alloc] initWithFrame:CGRectMake(viewW-viewH*44/view_fix_height, 0,viewH*44/view_fix_height, viewH*20/view_fix_height)];
    _skipTitle.center=CGPointMake(_skipTitle.center.x, _topTitle.center.y);
    _skipTitle.text = NSLocalizedString(@"main_login_step1_skip", nil);
    _skipTitle.font = [UIFont systemFontOfSize: main_text_size];
    _skipTitle.backgroundColor = [UIColor clearColor];
    _skipTitle.textColor = LOGIN_TEXT_COLOR;
    _skipTitle.numberOfLines = 0;
    _skipTitle.textAlignment=NSTextAlignmentLeft;
    //[_topBg addSubview:_skipTitle];
    
    //主界面
    _mainBg=[[UIView alloc]init];
    _mainBg.frame = CGRectMake(0, viewH*64/view_fix_height, viewW, viewH-viewH*64/view_fix_height);
    _mainBg.userInteractionEnabled=YES;
    [_mainBg setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:_mainBg];
    
    _loginStep1Img=[[UIImageView alloc]init];
    _loginStep1Img.frame=CGRectMake(0, viewH*38/view_fix_height, viewH*87*558/261/view_fix_height, viewH*87/view_fix_height);
    _loginStep1Img.center=CGPointMake(viewW*0.5, _loginStep1Img.center.y);
    _loginStep1Img.image=[UIImage imageNamed:@"amazon alexa logo@3x.png"];
    [_mainBg addSubview:_loginStep1Img];
    
    _loginStep1Label1= [[UILabel alloc] initWithFrame:CGRectMake(viewW*25/view_fix_width, viewH*170/view_fix_height,viewW-viewW*50/view_fix_width, viewH*90/view_fix_height)];
    _loginStep1Label1.text = NSLocalizedString(@"main_login_step1_note1", nil);
    _loginStep1Label1.font = [UIFont systemFontOfSize: main_text_size];
    _loginStep1Label1.backgroundColor = [UIColor clearColor];
    _loginStep1Label1.textColor = LOGIN_NOTE_COLOR;
    _loginStep1Label1.numberOfLines = 0;
    _loginStep1Label1.lineBreakMode = UILineBreakModeWordWrap;
    _loginStep1Label1.textAlignment=NSTextAlignmentCenter;
    [_mainBg addSubview:_loginStep1Label1];
    
    _loginStep1Label2= [[UILabel alloc] initWithFrame:CGRectMake(viewW*25/view_fix_width, viewH*290/view_fix_height,viewW-viewW*50/view_fix_width, viewH*100/view_fix_height)];
    _loginStep1Label2.text = NSLocalizedString(@"main_login_step1_note2", nil);
    _loginStep1Label2.font = [UIFont systemFontOfSize: contact_text_size];
    _loginStep1Label2.backgroundColor = [UIColor clearColor];
    _loginStep1Label2.textColor = LOGIN_NOTE2_COLOR;
    _loginStep1Label2.numberOfLines = 0;
    _loginStep1Label2.lineBreakMode = UILineBreakModeWordWrap;
    _loginStep1Label2.textAlignment=NSTextAlignmentCenter;
    [_mainBg addSubview:_loginStep1Label2];
    
    _loginStep1Btn=[UIButton buttonWithType:UIButtonTypeCustom];
    _loginStep1Btn.frame = CGRectMake(viewW*54/view_fix_width, viewH*481/view_fix_height, viewW*267/view_fix_width, viewH*48/view_fix_height);
    [_loginStep1Btn setTitle:NSLocalizedString(@"main_login_step1_btn", nil) forState:UIControlStateNormal];
    [_loginStep1Btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_loginStep1Btn setBackgroundImage:[UIImage imageNamed:@"long_oc_nor@3x.png"] forState:UIControlStateNormal];
    [_loginStep1Btn setBackgroundImage:[UIImage imageNamed:@"long_oc_pre@3x.png"] forState:UIControlStateHighlighted];
    _loginStep1Btn.contentHorizontalAlignment=UIControlContentHorizontalAlignmentCenter;
    [_loginStep1Btn addTarget:nil action:@selector(_loginStep1BtnClick) forControlEvents:UIControlEventTouchUpInside];
    _loginStep1Btn.titleLabel.font=[UIFont systemFontOfSize: main_text_size];
    [_mainBg  addSubview:_loginStep1Btn];
    _loginStep1ParametersConfig=[[ParametersConfig alloc]init:self ip:_loginStep1DeviceIp password:@"admin"];
    _loadingView = [[LoadingView alloc] initWithFrame:self.view.frame];
    [_loadingView setLoadingShow:NO :@""];
    [self.view addSubview:_loadingView];
}

-(void)viewDidAppear:(BOOL)animated{
    NSLog(@"viewDidappear");
    [super viewDidAppear:animated];
}

-(void)viewDidDisappear:(BOOL)animated{
    NSLog(@"viewDidDisappear");
    [super viewDidDisappear:animated];
    if (timeOut) {
        [timeOut invalidate];
        timeOut = nil;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//Listen
-(void)setOnResultListener:(int)statusCode :(NSString*)body :(int)type{
    if (type==ALEXA_LOGIN) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (statusCode==200) {
                NSLog(@"%@",body);
                kProduct_id=[self parseJsonString:body :@"\"product_id\":\""];
                kProduct_dsn=[self parseJsonString:body :@"\"product_dsn\":\""];
                kCodeChallengeMethod=[self parseJsonString:body :@"\"codechallengemethod\":\""];
                kCodeChallenge=[self parseJsonString:body :@"\"codechallenge\":\""];
                [self amazonLogin];
            }
            else{
                [_loadingView setLoadingShow:NO :@""];
                [CommanParameters showAllTextDialog:self.view :NSLocalizedString(@"main_login_step1_check_failed", nil)];
            }
        });
        
    }
    else if (type==ALEXA_SEND_CODE) {
        [_loadingView setLoadingShow:NO :@""];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (statusCode==200) {
                if ([body isEqualToString:@"{\"value\": \"0\"}"]) {
                    LogoutViewController *v = [[LogoutViewController alloc] init];
                    v.loginOutStep1DeviceIp=_loginStep1DeviceIp;
                    [self.navigationController pushViewController: v animated:true];
                }
                else{
                    [CommanParameters showAllTextDialog:self.view :NSLocalizedString(@"main_login_step1_send_failed", nil)];
                }
            }
            else{
                [CommanParameters showAllTextDialog:self.view :NSLocalizedString(@"main_login_step1_send_failed", nil)];
            }
        });
        
    }
}

//{"product_id":"my_device","product_dsn":"333334","codechallengemethod":"S256","codechallenge":"SBGqJIiXi3TuWWgWUbhLDqq0NShITlakcRRLOONVxPM"}

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

- (void)_loginStep1BtnClick{
    NSLog(@"_loginStep1BtnClick");
    [_loadingView setLoadingShow:YES :NSLocalizedString(@"main_login_step1_check_text", nil)];
    [_loginStep1ParametersConfig alexaLogin];
}

-(void)amazonLogin{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (timeOut) {
            [timeOut invalidate];
            timeOut = nil;
        }
        timeOut = [NSTimer scheduledTimerWithTimeInterval:120.0f target:self selector:@selector(timeOut) userInfo:nil repeats:NO];
    });
    NSArray *requestScopes = [NSArray arrayWithObjects:@"alexa:all", nil];
    NSMutableDictionary *options = [[NSMutableDictionary alloc] init];
    NSString* scopeData = [NSString stringWithFormat:@"{\"alexa:all\":{\"productID\":\"%@\","
                           "\"productInstanceAttributes\":{\"deviceSerialNumber\":\"%@\"}}}",
                           kProduct_id, kProduct_dsn];
    NSLog(@"scopeData:%@",scopeData);
    options[kAIOptionScopeData] = scopeData;
    options[kAIOptionReturnAuthCode] = @YES;
    options[kAIOptionCodeChallenge] = kCodeChallenge;
    options[kAIOptionCodeChallengeMethod] = kCodeChallengeMethod;
    NSLog(@"kAIOptionCodeChallenge:%@",kCodeChallenge);
    NSLog(@"kCodeChallengeMethod:%@",kCodeChallengeMethod);
    dispatch_async(dispatch_get_main_queue(), ^{
        [AIMobileLib authorizeUserForScopes:requestScopes delegate:self options:options];
    });
}
// 0104YCHGcmw
-(void)timeOut{
    NSLog(@"alexa timeOut........");
    [_loadingView setLoadingShow:NO :@""];
}

- (void)requestDidSucceed:(APIResult *)apiResult {
    // Your code after the user authorizes Application for requested scopes.
    
    // You can now load new view controller with user identifying information as the user is now successfully signed in or simple get the user profile information if the authorization was for "profile" scope.
    NSLog(@"AMZNAuthorizeUserDelegate requestDidSucceed:%@",apiResult.result);
    if (apiResult.result) {
        kClient_id = [AIMobileLib getClientId];
        kRedirectUri = [AIMobileLib getRedirectUri];
        kAuthCode = apiResult.result;
        dispatch_async(dispatch_get_main_queue(), ^{
            if (timeOut) {
                [timeOut invalidate];
                timeOut = nil;
            }
            timeOut = [NSTimer scheduledTimerWithTimeInterval:50.0f target:self selector:@selector(timeOut) userInfo:nil repeats:NO];
            [_loadingView setLoadingText:NSLocalizedString(@"main_login_step1_send_text", nil)];
        });
        [_loginStep1ParametersConfig alexaSendCode:kClient_id :kRedirectUri :kAuthCode];
    }
}

/*
 Delegate method that gets a call when the user authoriation for requested scope fails.
 */
- (void)requestDidFail:(APIError *)errorResponse {
    // Your code when the authorization fails.
    if (timeOut) {
        [timeOut invalidate];
        timeOut = nil;
    }
    NSLog(@"AMZNAuthorizeUserDelegate requestDidFail:%@",errorResponse.error.message);
    [[[UIAlertView alloc] initWithTitle:@"" message:[NSString stringWithFormat:@"User authorization failed with message: %@", errorResponse.error.message] delegate:nil cancelButtonTitle:@"OK"otherButtonTitles:nil] show];
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
