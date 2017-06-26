//
//  CommanParameters.h
//  WisCore
//
//  Created by rakwireless on 2017/4/20.
//  Copyright © 2017年 rak. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

///////////   size     /////////////
#define view_fix_height 667  //UI设计时总高度，通过这个值和屏幕高度的比例，设置每个控件的高度
#define view_fix_width 375   //UI设计时总宽度，通过这个值和屏幕宽度的比例，设置每个控件的宽度
#define viewH [UIScreen mainScreen].bounds.size.height  //屏幕高度
#define viewW [UIScreen mainScreen].bounds.size.width   //屏幕宽度
#define diff_top  viewH*20/view_fix_height         //距离上边界距离
#define diff_x  10           //距离左右边界距离

#define easy_add_progress_size viewH*36/view_fix_height
#define main_title_size viewH*20/view_fix_height   //主界面标题大小
#define choose_text_size viewH*18/view_fix_height
#define main_text_size viewH*16/view_fix_height
#define contact_text_size viewH*14/view_fix_height
#define about_copyright_size viewH*12/view_fix_height
#define menu_title_size viewH*30/view_fix_height
#define list_row_height viewH*44/view_fix_height
#define action_list_row_height viewH*75/view_fix_height
#define device_list_row_height viewH*98/view_fix_height
#define device_info_list_row_height viewH*48/view_fix_height
#define ssid_list_row_height viewH*44/view_fix_height

///////////   color     /////////////
#define MAIN_BG_COLOR [UIColor colorWithRed:(250 / 255.0f) green:(250 / 255.0f) blue:(250 / 255.0f) alpha:1.0]
#define MAIN_TITLE_BG_COLOR [UIColor colorWithRed:(248 / 255.0f) green:(249 / 255.0f) blue:(250 / 255.0f) alpha:1.0]
#define MAIN_TEXT_BG_COLOR [UIColor colorWithRed:(241 / 255.0f) green:(243 / 255.0f) blue:(245 / 255.0f) alpha:1.0]
#define MAIN_TEXT_COLOR [UIColor colorWithRed:(52 / 255.0f) green:(58 / 255.0f) blue:(64 / 255.0f) alpha:1.0]
#define SUCCESS_TEXT_COLOR [UIColor colorWithRed:(56 / 255.0f) green:(217 / 255.0f) blue:(169 / 255.0f) alpha:1.0]
#define INFO_TEXT_COLOR [UIColor colorWithRed:(59 / 255.0f) green:(201 / 255.0f) blue:(216 / 255.0f) alpha:1.0]
#define ADD_NOTE_COLOR [UIColor colorWithRed:(134 / 255.0f) green:(142 / 255.0f) blue:(150 / 255.0f) alpha:1.0]
#define LOGIN_TEXT_COLOR [UIColor colorWithRed:(26 / 255.0f) green:(166 / 255.0f) blue:(205 / 255.0f) alpha:1.0]
#define LOGIN_NOTE_COLOR [UIColor colorWithRed:(34 / 255.0f) green:(67 / 255.0f) blue:(42 / 255.0f) alpha:1.0]
#define LOGIN_NOTE2_COLOR [UIColor colorWithRed:(121 / 255.0f) green:(136 / 255.0f) blue:(137 / 255.0f) alpha:1.0]
#define LOGIN_LINE_COLOR [UIColor colorWithRed:(209 / 255.0f) green:(214 / 255.0f) blue:(215 / 255.0f) alpha:1.0]
#define SHADOW_COLOR [UIColor colorWithRed:(0 / 255.0f) green:(0 / 255.0f) blue:(0 / 255.0f) alpha:0.3]
#define LOAD_SHADOW_COLOR [UIColor colorWithRed:(0 / 255.0f) green:(0 / 255.0f) blue:(0 / 255.0f) alpha:0.7]
#define PROGRESS_COLOR [UIColor colorWithRed:(87 / 255.0f) green:(238 / 255.0f) blue:(192 / 255.0f) alpha:1.0]

///////////   key     /////////////
#define CONFIGURED_SSID  @"CONFIGURED_SSID_KEY"

@interface CommanParameters : NSObject
+(void)Save_String:(NSString *)value :(NSString *)key;
+(NSString *)Get_String:(NSString *)key;
+(void)Save_MutableArray:(NSMutableArray *)value :(NSString *)key;
+(NSMutableArray *)Get_MutableArray:(NSString *)key;
+(void)showAllTextDialog:(UIView *)view :(NSString *)str;
+ (void)setInfoViewFrame:(UIView*)infoView :(BOOL)isDown;
+(NSString *)getWifiName;
+(void)gotoWifiSettings;
@end
