//
//  AppDelegate.h
//  WisCore
//
//  Created by rakwireless on 2017/4/19.
//  Copyright © 2017年 rak. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWRevealViewController.h"
#import "ViewController.h"


@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) ViewController *homePageVC;
@property (strong, nonatomic) SWRevealViewController *revealViewController;

@end

