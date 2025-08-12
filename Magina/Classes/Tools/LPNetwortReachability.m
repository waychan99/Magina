//
//  LPNetwortReachability.m
//  LongPartner
//
//  Created by mac on 2021/12/15.
//

#import "LPNetwortReachability.h"
#import <AFNetworking/AFNetworkReachabilityManager.h>

static LPNetworkStatus _networkStatus = LPNetworkStatusNoReachable;

@implementation LPNetwortReachability

+ (LPNetworkStatus)networkStatus {
    return _networkStatus;
}

/**
 开始监控网络
 */
+ (void)startMonitorNetwork{
    // 1.获得网络监控的管理者
    AFNetworkReachabilityManager *mgr = [AFNetworkReachabilityManager sharedManager];
    // 2.设置网络状态改变后的处理
    [mgr setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        // 当网络状态改变了, 就会调用这个block
        switch (status) {
            case AFNetworkReachabilityStatusUnknown: // 未知网络
            case AFNetworkReachabilityStatusNotReachable:{// 没有网络(断网)
                _networkStatus = LPNetworkStatusNoReachable;
            }
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:{// 手机自带网络
                _networkStatus = LPNetworkStatusWWAN;
            }
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:{// WIFI
                _networkStatus = LPNetworkStatusWiFi;
            }
                break;
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:LP_NETWORK_STATUS_NOTI object:@(_networkStatus)];
    }];
    [mgr startMonitoring];
}

@end
