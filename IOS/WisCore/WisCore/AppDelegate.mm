//
//  AppDelegate.m
//  WisCore
//
//  Created by rakwireless on 2017/4/19.
//  Copyright © 2017年 rak. All rights reserved.
//

#import "AppDelegate.h"
#import "MenuViewController.h"
#import "RotateNavigationControllerViewController.h"
#import <LoginWithAmazon/LoginWithAmazon.h>

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    NSLog(@"application openURL:%@",url);
    // Pass on the url to the SDK to parse authorization code from the url.
    BOOL isValidRedirectLogInURL = [AIMobileLib handleOpenURL:url sourceApplication:sourceApplication];
    
    if(!isValidRedirectLogInURL)
        return NO;
    
    // App may also want to handle url
    return YES;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [UIApplication sharedApplication].idleTimerDisabled = YES;
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    [self.window makeKeyAndVisible];
    //左侧菜单栏
    MenuViewController *menuViewController = [[MenuViewController alloc] init];
    self.homePageVC = [[ViewController alloc] init];
    
    self.revealViewController = [[SWRevealViewController alloc] initWithRearViewController:menuViewController frontViewController:self.homePageVC];
    self.revealViewController.rightViewController = nil;
    
    //浮动层离左边距的宽度
    self.revealViewController.rearViewRevealWidth = self.homePageVC.view.frame.size.width*281/375;
    //    revealViewController.rightViewRevealWidth = 230;
    //是否让浮动层弹回原位
    //mainRevealController.bounceBackOnOverdraw = NO;
    [self.revealViewController setFrontViewPosition:FrontViewPositionLeft animated:YES];
    
    self.window.rootViewController = [[RotateNavigationControllerViewController alloc] initWithRootViewController:self.revealViewController];
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    NSLog(@"---applicationWillResignActive----");
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    NSLog(@"---applicationDidEnterBackground----");
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    NSLog(@"---applicationWillEnterForeground----");
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    NSLog(@"---applicationDidBecomeActive----");
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    NSLog(@"---applicationWillTerminate----");
}


@end
