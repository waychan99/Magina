//
//  SWDeviceCenter.m
//  SWSDK
//
//  Created by 朱盛雄 on 17/1/18.
//  Copyright © 2017年 Sunniwell. All rights reserved.
//

#import "SWDeviceCenter.h"
#import <sys/utsname.h>
#import <UIKit/UIKit.h>
#import "SWKeyChainStore.h"
//#import "Macros.h"

#define kSWDeviceCenter [SWDeviceCenter defaultCenter]

@interface SWDeviceCenter ()

@property (nonatomic, strong)NSString *macAddr;

@property (nonatomic, strong)NSString *hardwareVersion;

@property (nonatomic, strong)NSString *softwareVersion;

@end

@implementation SWDeviceCenter

+ (SWDeviceCenter *)defaultCenter {
    static SWDeviceCenter *center;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        center = [[SWDeviceCenter alloc] init];
    });
    return center;
}

+ (NSString *)softwareVersion {
    if (!kSWDeviceCenter.softwareVersion) {
        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        kSWDeviceCenter.softwareVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    }
    return kSWDeviceCenter.softwareVersion;
}

+ (NSString *)hardwareVersion {
    if (!kSWDeviceCenter.hardwareVersion) {

        kSWDeviceCenter.hardwareVersion = [NSString stringWithFormat:@"%@ %@ %@",
                                           [self deviceModel],
                                           [[UIDevice currentDevice] systemName],
                                           [[UIDevice currentDevice] systemVersion]];

        
    }
    return kSWDeviceCenter.hardwareVersion;
}

+ (NSString *)deviceModel {
    //if (!kSWDeviceCenter.hardwareVersion) {
        struct utsname systemInfo;
        uname(&systemInfo);
        NSString *deviceModel = [NSString stringWithCString:systemInfo.machine
                                                   encoding:NSUTF8StringEncoding];
        
        // 模拟器
        if ([deviceModel isEqualToString:@"i386"])         return @"Simulator";
        if ([deviceModel isEqualToString:@"x86_64"])       return @"Simulator";
        
        // iPhone 系列
        if ([deviceModel isEqualToString:@"iPhone1,1"])    return @"iPhone 1G";
        if ([deviceModel isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
        if ([deviceModel isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
        if ([deviceModel isEqualToString:@"iPhone3,1"])    return @"iPhone 4 (GSM)";
        if ([deviceModel isEqualToString:@"iPhone3,2"])    return @"Verizon iPhone 4";
        if ([deviceModel isEqualToString:@"iPhone3,3"])    return @"iPhone 4 (CDMA/Verizon/Sprint)";
        if ([deviceModel isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
        if ([deviceModel isEqualToString:@"iPhone5,1"])    return @"iPhone 5";
        if ([deviceModel isEqualToString:@"iPhone5,2"])    return @"iPhone 5";
        if ([deviceModel isEqualToString:@"iPhone5,3"])    return @"iPhone 5C";
        if ([deviceModel isEqualToString:@"iPhone5,4"])    return @"iPhone 5C";
        if ([deviceModel isEqualToString:@"iPhone6,1"])    return @"iPhone 5S";
        if ([deviceModel isEqualToString:@"iPhone6,2"])    return @"iPhone 5S";
        if ([deviceModel isEqualToString:@"iPhone7,1"])    return @"iPhone 6 Plus";
        if ([deviceModel isEqualToString:@"iPhone7,2"])    return @"iPhone 6";
        if ([deviceModel isEqualToString:@"iPhone8,1"])    return @"iPhone 6s";
        if ([deviceModel isEqualToString:@"iPhone8,2"])    return @"iPhone 6s Plus";
        if ([deviceModel isEqualToString:@"iPhone8,4"])    return @"iPhone SE";
        if ([deviceModel isEqualToString:@"iPhone9,1"])    return @"iPhone 7 (CDMA)";
        if ([deviceModel isEqualToString:@"iPhone9,3"])    return @"iPhone 7 (GSM)";
        if ([deviceModel isEqualToString:@"iPhone9,2"])    return @"iPhone 7 Plus (CDMA)";
        if ([deviceModel isEqualToString:@"iPhone9,4"])    return @"iPhone 7 Plus (GSM)";
        if ([deviceModel isEqualToString:@"iPhone10,1"])    return @"iPhone 8 (CDMA)";
        if ([deviceModel isEqualToString:@"iPhone10,4"])    return @"iPhone 8 (GSM)";
        if ([deviceModel isEqualToString:@"iPhone10,2"])    return @"iPhone 8 Plus (CDMA)";
        if ([deviceModel isEqualToString:@"iPhone10,5"])    return @"iPhone 8 Plus (GSM)";
        if ([deviceModel isEqualToString:@"iPhone10,3"])    return @"iPhone X (CDMA)";
        if ([deviceModel isEqualToString:@"iPhone10,6"])    return @"iPhone X (GSM)";
        
        // iPod 系列
        if ([deviceModel isEqualToString:@"iPod1,1"])      return @"iPod Touch 1G";
        if ([deviceModel isEqualToString:@"iPod2,1"])      return @"iPod Touch 2G";
        if ([deviceModel isEqualToString:@"iPod3,1"])      return @"iPod Touch 3G";
        if ([deviceModel isEqualToString:@"iPod4,1"])      return @"iPod Touch 4G";
        if ([deviceModel isEqualToString:@"iPod5,1"])      return @"iPod Touch 5G";
        if ([deviceModel isEqualToString:@"iPod7,1"])      return @"iPod Touch 6G";
        
        // iPad 系列
        if ([deviceModel isEqualToString:@"iPad1,1"])      return @"iPad";
        if ([deviceModel isEqualToString:@"iPad1,2"])      return @"iPad 3G";
        
        if ([deviceModel isEqualToString:@"iPad2,1"])      return @"iPad 2 (WiFi)";
        if ([deviceModel isEqualToString:@"iPad2,2"])      return @"iPad 2 (GSM)";
        if ([deviceModel isEqualToString:@"iPad2,3"])      return @"iPad 2 (CDMA)";
        if ([deviceModel isEqualToString:@"iPad2,4"])      return @"iPad 2 (32nm)";
        if ([deviceModel isEqualToString:@"iPad2,5"])      return @"iPad Mini (WiFi)";
        if ([deviceModel isEqualToString:@"iPad2,6"])      return @"iPad Mini (GSM)";
        if ([deviceModel isEqualToString:@"iPad2,7"])      return @"iPad Mini (CDMA)";
        
        if ([deviceModel isEqualToString:@"iPad3,1"])      return @"iPad 3(WiFi)";
        if ([deviceModel isEqualToString:@"iPad3,2"])      return @"iPad 3(CDMA)";
        if ([deviceModel isEqualToString:@"iPad3,3"])      return @"iPad 3(4G)";
        if ([deviceModel isEqualToString:@"iPad3,4"])      return @"iPad 4 (WiFi)";
        if ([deviceModel isEqualToString:@"iPad3,5"])      return @"iPad 4 (4G)";
        if ([deviceModel isEqualToString:@"iPad3,6"])      return @"iPad 4 (CDMA)";
        
        if ([deviceModel isEqualToString:@"iPad4,1"])      return @"iPad Air";
        if ([deviceModel isEqualToString:@"iPad4,2"])      return @"iPad Air";
        if ([deviceModel isEqualToString:@"iPad4,3"])      return @"iPad Air";
        if ([deviceModel isEqualToString:@"iPad4,4"])      return @"iPad Mini 2";
        if ([deviceModel isEqualToString:@"iPad4,5"])      return @"iPad Mini 2";
        if ([deviceModel isEqualToString:@"iPad4,6"])      return @"iPad Mini 2";
        if ([deviceModel isEqualToString:@"iPad4,7"])      return @"iPad Mini 3";
        if ([deviceModel isEqualToString:@"iPad4,8"])      return @"iPad Mini 3";
        if ([deviceModel isEqualToString:@"iPad4,9"])      return @"iPad Mini 3";
        
        if ([deviceModel isEqualToString:@"iPad5,1"])      return @"iPad Mini 4";
        if ([deviceModel isEqualToString:@"iPad5,2"])      return @"iPad Mini 4";
        if ([deviceModel isEqualToString:@"iPad5,3"])      return @"iPad Air 2";
        if ([deviceModel isEqualToString:@"iPad5,4"])      return @"iPad Air 2";
        
        if ([deviceModel isEqualToString:@"iPad6,3"])      return @"iPad PRO (12.9)";
        if ([deviceModel isEqualToString:@"iPad6,4"])      return @"iPad PRO (12.9)";
        if ([deviceModel isEqualToString:@"iPad6,7"])      return @"iPad PRO (9.7)";
        if ([deviceModel isEqualToString:@"iPad6,8"])      return @"iPad PRO (9.7)";
        if ([deviceModel isEqualToString:@"iPad6,11"])      return @"iPad 5";
        if ([deviceModel isEqualToString:@"iPad6,12"])      return @"iPad 5";
        
        if ([deviceModel isEqualToString:@"iPad7,1"])      return @"iPad PRO 2 (12.9)";
        if ([deviceModel isEqualToString:@"iPad7,2"])      return @"iPad PRO 2 (12.9)";
        if ([deviceModel isEqualToString:@"iPad7,3"])      return @"iPad PRO (10.5)";
        if ([deviceModel isEqualToString:@"iPad7,4"])      return @"iPad PRO (10.5)";
        
        return deviceModel;
//    }
//    return kSWDeviceCenter.hardwareVersion;
}

+ (SWNetworkMode)networkMode {
    return [kSWDeviceCenter getNetWorkStates];
}

+ (NSString *)mac {
    if (!kSWDeviceCenter.macAddr) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"yy:MM:dd:HH:mm:ss"];
        NSDate *nowDate = [NSDate date];
        kSWDeviceCenter.macAddr = [dateFormatter stringFromDate:nowDate];
    }
    return kSWDeviceCenter.macAddr;
}

- (SWNetworkMode)getNetWorkStates {
    UIApplication *app = [UIApplication sharedApplication];
    NSArray *children = [[[app valueForKeyPath:@"statusBar"]valueForKeyPath:@"foregroundView"]subviews];
    SWNetworkMode state = SW_NETWORKMODE_UNKNOWN;
    int netType = 0;
    //获取到网络返回码
    for (id child in children) {
        if ([child isKindOfClass:NSClassFromString(@"UIStatusBarDataNetworkItemView")]) {
            //获取到状态栏
            netType = [[child valueForKeyPath:@"dataNetworkType"]intValue];
            switch (netType) {
                case 0:
                    state = SW_NETWORKMODE_UNKNOWN;
                    break;
                case 1:
                    state = SW_NETWORKMODE_WIFI_DHCP;
                    break;
                case 2:
                    state = SW_NETWORKMODE_WIFI_DHCP;
                    break;
                case 3:
                    state = SW_NETWORKMODE_WIFI_DHCP;
                    break;
                case 5:
                    state = SW_NETWORKMODE_WIFI_DHCP;
                    break;
                default:
                    break;
            }
        }
    }
    //根据状态选择
    return state;
}

+ (NSString *)getUUID {
    NSString *strUUID = (NSString *)[SWKeyChainStore load:SWKeyChainStoreUUIDKey];
    //首次执行该方法时，uuid为空
    if ([strUUID isEqualToString:@""] || !strUUID) {
        //生成一个uuid的方法
        CFUUIDRef uuidRef = CFUUIDCreate(kCFAllocatorDefault);
        
        strUUID = (NSString *)CFBridgingRelease(CFUUIDCreateString(kCFAllocatorDefault,uuidRef));
        
        //将该uuid保存到keychain
        [SWKeyChainStore save:SWKeyChainStoreUUIDKey data:strUUID];
    }
    return strUUID;
}

+ (NSString *)networkDesc {
    UIApplication *app = [UIApplication sharedApplication];
    NSArray *children;
    if ([[app valueForKeyPath:@"_statusBar"] isKindOfClass:NSClassFromString(@"UIStatusBar_Modern")]) {
        children = [[[[app valueForKeyPath:@"_statusBar"] valueForKeyPath:@"_statusBar"] valueForKeyPath:@"foregroundView"] subviews];
    } else {
        children = [[[app valueForKeyPath:@"_statusBar"] valueForKeyPath:@"foregroundView"] subviews];
    }
    
    //NSArray *children = [[[app valueForKeyPath:@"statusBar"]valueForKeyPath:@"foregroundView"]subviews];
    NSString *state = @"未知";
    int netType = 0;
    //获取到网络返回码
    for (id child in children) {
        if ([child isKindOfClass:NSClassFromString(@"UIStatusBarDataNetworkItemView")]) {
            //获取到状态栏
            netType = [[child valueForKeyPath:@"dataNetworkType"]intValue];
            switch (netType) {
                case 0:
                    state = @"未知";
                    break;
                case 1:
                    state = @"2G";
                    break;
                case 2:
                    state = @"3G";
                    break;
                case 3:
                    state = @"4G";
                    break;
                case 5:
                    state = @"WIFI";
                    break;
                default:
                    break;
            }
        }
    }
    //根据状态选择
    return state;
}



@end










