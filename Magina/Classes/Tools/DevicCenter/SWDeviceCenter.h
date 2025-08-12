//
//  SWDeviceCenterDeviceCenter.h
//  SWDeviceCenterSDK
//
//  Created by 朱盛雄 on 17/1/18.
//  Copyright © 2017年 Sunniwell. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    SW_NETWORKMODE_UNKNOWN,
    SW_NETWORKMODE_LAN_DHCP,
    SW_NETWORKMODE_LAN_STATIC,
    SW_NETWORKMODE_LAN_PPPOE,
    SW_NETWORKMODE_WIFI_DHCP,
    SW_NETWORKMODE_WIFI_STATIC,
    SW_NETWORKMODE_WIFI_PPPOE
}SWNetworkMode;


@interface SWDeviceCenter : NSObject

+ (NSString *)softwareVersion;

+ (NSString *)hardwareVersion;

+ (SWNetworkMode)networkMode;

+ (NSString *)mac;//时间

+ (NSString *)getUUID;

+ (NSString *)networkDesc;

+ (NSString *)deviceModel;

@end
