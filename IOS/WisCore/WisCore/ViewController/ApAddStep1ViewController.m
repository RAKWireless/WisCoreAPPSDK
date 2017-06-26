//
//  ApAddStep1ViewController.m
//  WisCore
//
//  Created by rakwireless on 2017/4/20.
//  Copyright © 2017年 rak. All rights reserved.
//

#import "ApAddStep1ViewController.h"
#import "CommanParameters.h"
#import "APAddStep3ViewController.h"

@interface ApAddStep1ViewController ()

@end

@implementation ApAddStep1ViewController

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
    
    _apAddStep1Img=[[UIImageView alloc]init];
    _apAddStep1Img.frame=CGRectMake(0, viewH*70/view_fix_height, viewH*40*555/159/view_fix_height,viewH*40/view_fix_height);
    _apAddStep1Img.center=CGPointMake(viewW*0.5, _apAddStep1Img.center.y);
    _apAddStep1Img.image=[UIImage imageNamed:@"light show bule@3x.png"];
    [_mainBg addSubview:_apAddStep1Img];
    
    _apAddStep1Label= [[UILabel alloc] initWithFrame:CGRectMake(viewW*25/view_fix_width, viewH*161/view_fix_height,viewW-viewW*50/view_fix_width, viewH*200/view_fix_height)];
    _apAddStep1Label.text = NSLocalizedString(@"main_add_step1_text", nil);
    _apAddStep1Label.font = [UIFont systemFontOfSize: main_text_size];
    _apAddStep1Label.backgroundColor = [UIColor clearColor];
    _apAddStep1Label.textColor = MAIN_TEXT_COLOR;
    _apAddStep1Label.numberOfLines = 0;
    _apAddStep1Label.lineBreakMode = UILineBreakModeWordWrap;
    _apAddStep1Label.textAlignment=NSTextAlignmentLeft;
    [_mainBg addSubview:_apAddStep1Label];
    
    _checkBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    _checkBtn.frame = CGRectMake(viewW*54/view_fix_width, viewH*410/view_fix_height, viewH*20/view_fix_height, viewH*20/view_fix_height);
    [_checkBtn setBackgroundImage:[UIImage imageNamed:@"remember_nor@3x.png"] forState:UIControlStateNormal];
    _checkBtn.tag=2;
    _checkBtn.contentHorizontalAlignment=UIControlContentHorizontalAlignmentCenter;
    [_checkBtn addTarget:nil action:@selector(_checkBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_mainBg  addSubview:_checkBtn];
    
    _checkLabel= [[UILabel alloc] initWithFrame:CGRectMake(_checkBtn.frame.origin.x+_checkBtn.frame.size.width+viewW*10/view_fix_width, viewH*410/view_fix_height,viewW, viewH*20/view_fix_height)];
    _checkLabel.text = NSLocalizedString(@"main_add_step1_check", nil);
    _checkLabel.font = [UIFont systemFontOfSize: main_text_size];
    _checkLabel.backgroundColor = [UIColor clearColor];
    _checkLabel.textColor = MAIN_TEXT_COLOR;
    _checkLabel.numberOfLines = 0;
    _checkLabel.lineBreakMode = UILineBreakModeWordWrap;
    _checkLabel.textAlignment=NSTextAlignmentLeft;
    [_mainBg addSubview:_checkLabel];
    
    _continueBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    _continueBtn.frame = CGRectMake(viewW*54/view_fix_width, viewH*449/view_fix_height, viewW*267/view_fix_width, viewH*48/view_fix_height);
    [_continueBtn setTitle:NSLocalizedString(@"main_add_step1_btn", nil) forState:UIControlStateNormal];
    [_continueBtn setTitleColor:MAIN_TEXT_COLOR forState:UIControlStateNormal];
    [_continueBtn setBackgroundImage:[UIImage imageNamed:@"long_oc_nor@3x.png"] forState:UIControlStateNormal];
    [_continueBtn setBackgroundImage:[UIImage imageNamed:@"long_oc_pre@3x.png"] forState:UIControlStateHighlighted];
    _continueBtn.contentHorizontalAlignment=UIControlContentHorizontalAlignmentCenter;
    [_continueBtn addTarget:nil action:@selector(_continueBtnClick) forControlEvents:UIControlEventTouchUpInside];
    _continueBtn.titleLabel.font=[UIFont systemFontOfSize: main_text_size];
    _continueBtn.enabled=NO;
    [_mainBg  addSubview:_continueBtn];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)_backBtnClick{
    NSLog(@"_backBtnClick");
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)_checkBtnClick{
    if (_checkBtn.tag==2) {
        [_checkBtn setBackgroundImage:[UIImage imageNamed:@"remember_sel@3x.png"] forState:UIControlStateNormal];
        _checkBtn.tag=1;
        _continueBtn.enabled=YES;
    }
    else{
        [_checkBtn setBackgroundImage:[UIImage imageNamed:@"remember_nor@3x.png"] forState:UIControlStateNormal];
        _checkBtn.tag=2;
        _continueBtn.enabled=NO;
    }
}

- (void)_continueBtnClick{
    if (_checkBtn.tag==2) {
        [CommanParameters showAllTextDialog:self.view :NSLocalizedString(@"main_add_step1_check_first", nil)];
        return;
    }
    APAddStep3ViewController *v = [[APAddStep3ViewController alloc] init];
    [self.navigationController pushViewController: v animated:true];
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
