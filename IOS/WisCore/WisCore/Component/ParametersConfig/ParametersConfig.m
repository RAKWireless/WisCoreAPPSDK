//
//  ParametersConfig.m
//  AoSmart
//
//  Created by rakwireless on 2017/4/14.
//  Copyright © 2017年 rak. All rights reserved.
//

#import "ParametersConfig.h"
#import "HttpRequest.h"

@implementation ParametersConfig
{
    NSString *_ip;
    NSString *_password;
    NSString *_username;
    NSString *_url;
    NSString *_body;
    int _type;
    float _timeout;
}

/**
 * Init
 */
-(id) init:(id<ParametersConfigDelegate>)delegate ip:(NSString*)ip password:(NSString*)password{
    self = [super init];
    _ip=[NSString stringWithFormat:@"%@:9999",ip];
    _password=password;
    _username=@"admin";
    
    if (self){
        self.delegate= delegate;//[delegate retain];
    }
    return  self;
}

/**
 * Set Username
 */
- (void)setUsername:(NSString*)username{
    _username=username;
}

/**
 * Set Password
 */
- (void)setPassword:(NSString*)password{
    _password=password;
}

- (void)get{
    NSThread* httpThread = [[NSThread alloc] initWithTarget:self
                                                   selector:@selector(getUrl)
                                                     object:nil];
    [httpThread start];
}

- (void)getUrl{
    NSString *way=@"GET";
    if (_body==nil) {
        way=@"GET";
    }
    else{
        way=@"POST";
    }
    if (_type==ALEXA_SEND_CODE) {
        _timeout=50.0;
    }
    else{
        _timeout=15.0;
    }
    HttpRequest* http_request = [HttpRequest HTTPRequestWithUrl:_url andData:_body andMethod:way andUserName:_username andPassword:_password andTimeout:_timeout];
    if ([_delegate respondsToSelector:@selector(setOnResultListener: : :)]) {
        [_delegate setOnResultListener:http_request.StatusCode :http_request.ResponseString :_type];
    }
}

/**
 * Description: Update Username And Password.
 * Return:
 * 			{"value": "0"} -- success.
 * 			other means failed.
 */
- (void)updateUsernameAndPassword:(NSString*)newUsername :(NSString*)newPassword{
    _type=UPDATE_USERNAME_PASSWORD;
    _body=nil;
    _url=[NSString stringWithFormat:@"http://%@/param.cgi?action=update&group=login&username=%@&password=%@",_ip,newUsername,newPassword];
    [self get];
}

/**
 * Description: Get Username And Password.
 * Return: Username and password of module.
 */
- (void)getUsernameAndPassword{
    _type=GET_USERNAME_PASSWORD;
    _body=nil;
    _url=[NSString stringWithFormat:@"http://%@/param.cgi?action=list&group=login",_ip];
    [self get];
}

/**
 * Description: Get SSID List.
 * Return: SSID List from module.
 */
- (void)getSsidList{
    _type=GET_SSID_LIST;
    _body=nil;
    _url=[NSString stringWithFormat:@"http://%@/server.command?command=get_wifilist",_ip];
    [self get];
}

/**
 * Description: Join Wifi, used to APConfig.
 */
- (void)joinWifi:(NSString*)ssid :(NSString*)password :(NSString*)encrypt{
    _type=JOIN_WIFI;
    _body=nil;
    _url=[NSString stringWithFormat:@"http://%@/param.cgi?action=update&group=wifi&sta_ssid=%@&sta_auth_key=%@&sta_encrypt_type=%@",_ip,ssid,password,encrypt];
    [self get];
}

/**
 * Description: Get Version of module.
 * Return: Version of module.
 */
- (void)getVersion{
    _type=GET_VERSION;
    _body=nil;
    _url=[NSString stringWithFormat:@"http://%@/server.command?command=get_version",_ip];
    [self get];
}

/**
 * Description: Get Parameters of module.
 * Return: Parameters of module.
 */
- (void)getParameters{
    _type=GET_PARAMETERS;
    _body=nil;
    _url=[NSString stringWithFormat:@"http://%@/param.cgi?action=list&group=wifi",_ip];
    [self get];
}

/**
 * Description: Get wifi status.
 * Return: wifi status of module.
 */
- (void)getWifiStatus{
    _type=GET_WIFI_STATUS;
    _body=nil;
    _url=[NSString stringWithFormat:@"http://%@/server.command?command=get_wifistatus",_ip];
    [self get];
}

/**
 * Description: Alexa Login.
 * Return: ID/Code/MODE.
 */
- (void)alexaLogin{
    _type=ALEXA_LOGIN;
    _body=nil;
    _url=[NSString stringWithFormat:@"http://%@/server.command?command=login&type=request",_ip];
    [self get];
}

/**
 * Description: Alexa Send Code.
 * Return: 0:success -1:failed.
 */
- (void)alexaSendCode:(NSString*)client_id :(NSString*)redirect_uri :(NSString*)authorize_code{
    _type=ALEXA_SEND_CODE;
    _body=nil;
    _url=[NSString stringWithFormat:@"http://%@/server.command?command=login&type=response&client_id=%@&redirect_uri=%@&authorize_code=%@",_ip,client_id,redirect_uri,authorize_code];
    [self get];
}

/**
 * Description: Alexa Sign out.
 * Return: 0:success -1:failed.
 */
- (void)alexaSignOut{
    _type=ALEXA_SIGN_OUT;
    _body=nil;
    _url=[NSString stringWithFormat:@"http://%@/server.command?command=logout",_ip];
    [self get];
}

/**
 * Description: Restart.
 */
- (void)restart{
    _type=RESTART;
    _body=nil;
    _url=[NSString stringWithFormat:@"http://%@/restart.cgi",_ip];
    [self get];
}

/**
 * Description: Restart net.
 */
- (void)restartNet{
    _type=RESTART_NET;
    _body=nil;
    _url=[NSString stringWithFormat:@"http://%@/param.cgi?action=restart_net",_ip];
    [self get];
}

/**
 * Description: Get Alexa login status.
 * Return: 0:not login -1:login.
 */
- (void)alexaLoginStatus{
    _type=GET_LOGIN_STATUS;
    _body=nil;
    _url=[NSString stringWithFormat:@"http://%@/server.command?command=islogin",_ip];
    [self get];
}

@end
