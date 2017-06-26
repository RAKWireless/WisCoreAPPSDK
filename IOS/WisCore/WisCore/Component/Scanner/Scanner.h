//
//  lx52xDevice.h
//  SkyEye
//
//  Created by 韦伟 on 15/6/15.
//  Copyright (c) 2015年 william.wei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Scanner : NSObject
@property (nonatomic,retain) NSArray* Device_IP_Arr;
@property (nonatomic,retain) NSArray* Device_ID_Arr;
-(Scanner*)ScanDeviceWithTime:(NSTimeInterval)time;


@end
