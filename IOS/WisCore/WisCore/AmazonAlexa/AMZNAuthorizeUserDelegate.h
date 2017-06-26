//
//  AMZNAuthorizeUserDelegate.h
//  loginTest
//
//  Created by 韦伟 on 16/6/25.
//  Copyright © 2016年 韦伟. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <LoginWithAmazon/LoginWithAmazon.h>
#import "LoginStep1ViewController.h"
@interface AMZNAuthorizeUserDelegate : UIViewController<AIAuthenticationDelegate>{
    LoginStep1ViewController* parentViewController;
}
- (id)initWithParentController:(LoginStep1ViewController *)aViewController;
@end
