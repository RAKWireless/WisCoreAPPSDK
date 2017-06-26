//
//  ParametersConfig.h
//  AoSmart
//
//  Created by rakwireless on 2017/4/14.
//  Copyright © 2017年 rak. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ParametersConfigDelegate <NSObject>
-(void)setOnResultListener:(int)statusCode :(NSString*)body :(int)type;
@end

@interface ParametersConfig : NSObject
@property(nonatomic,weak) id <ParametersConfigDelegate> delegate;
-(id) init:(id<ParametersConfigDelegate>)delegate ip:(NSString*)ip password:(NSString*)password;
- (void)setUsername:(NSString*)username;
- (void)setPassword:(NSString*)password;

typedef enum {
    UPDATE_USERNAME_PASSWORD,
    GET_USERNAME_PASSWORD,
    GET_SSID_LIST,
    JOIN_WIFI,
    GET_VERSION,
    GET_PARAMETERS,
    GET_WIFI_STATUS,
    ALEXA_LOGIN,
    ALEXA_SEND_CODE,
    ALEXA_SIGN_OUT,
    RESTART,
    RESTART_NET
} RequestType;

- (void)updateUsernameAndPassword:(NSString*)newUsername :(NSString*)newPassword;
- (void)getUsernameAndPassword;
- (void)getSsidList;
- (void)joinWifi:(NSString*)ssid :(NSString*)password :(NSString*)encrypt;
- (void)getVersion;
- (void)getParameters;
- (void)getWifiStatus;
- (void)alexaLogin;
- (void)alexaSendCode:(NSString*)client_id :(NSString*)redirect_uri :(NSString*)authorize_code;
- (void)alexaSignOut;
- (void)restart;
- (void)restartNet;
@end
