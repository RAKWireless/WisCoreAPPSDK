//
//  AMZNAuthorizeUserDelegate.m
//  loginTest
//
//  Created by 韦伟 on 16/6/25.
//  Copyright © 2016年 韦伟. All rights reserved.
//

#import "AMZNAuthorizeUserDelegate.h"
@interface AMZNAuthorizeUserDelegate ()

@end

@implementation AMZNAuthorizeUserDelegate
- (id)initWithParentController:(LoginStep1ViewController *)aViewController{
    if(self = [super init]) {
        parentViewController = aViewController;
    }
    
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)requestDidSucceed:(APIResult *)apiResult {
    // Your code after the user authorizes Application for requested scopes.
    
    // You can now load new view controller with user identifying information as the user is now successfully signed in or simple get the user profile information if the authorization was for "profile" scope.
    NSLog(@"AMZNAuthorizeUserDelegate requestDidSucceed:%@",apiResult.result);
}

/*
 Delegate method that gets a call when the user authoriation for requested scope fails.
 */
- (void)requestDidFail:(APIError *)errorResponse {
    // Your code when the authorization fails.
    
    NSLog(@"AMZNAuthorizeUserDelegate requestDidFail:%@",errorResponse.error.message);
    [[[UIAlertView alloc] initWithTitle:@"" message:[NSString stringWithFormat:@"User authorization failed with message: %@", errorResponse.error.message] delegate:nil cancelButtonTitle:@"OK"otherButtonTitles:nil] show];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
