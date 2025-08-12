//
//  LPNetwortReachability.h
//  LongPartner
//
//  Created by mac on 2021/12/15.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

static NSString *const LP_NETWORK_STATUS_NOTI = @"LP_NETWORK_STATUS_NOTI"; // 网络状态改变通知

typedef NS_ENUM(NSUInteger, LPNetworkStatus) {
    LPNetworkStatusNoReachable, //没有网络
    LPNetworkStatusWWAN,        //手机自带网络
    LPNetworkStatusWiFi         //WiFi
};

@interface LPNetwortReachability : NSObject

+ (LPNetworkStatus)networkStatus;

/**
 开始监控网络
 */
+ (void)startMonitorNetwork;

@end

NS_ASSUME_NONNULL_END
