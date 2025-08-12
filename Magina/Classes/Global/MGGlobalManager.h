//
//  MGGlobalManager.h
//  Magina
//
//  Created by mac on 2025/8/12.
//

#import <Foundation/Foundation.h>
#import "SWDeviceCenter.h"

NS_ASSUME_NONNULL_BEGIN

@interface MGGlobalManager : NSObject

/** mac地址 */
@property (nonatomic, copy, readonly) NSString *macAddr;

/** app版本号 */
@property (nonatomic, copy, readonly) NSString *appVersion;

/** 设备型号 */
@property (nonatomic, copy) NSString *deviceType;

/** 用户本地信息参数 */
@property (nonatomic, strong) NSMutableDictionary *userLocalInfoParams;

+ (instancetype)shareInstance;

// 请求用户本地信息
- (void)requestUserLocalInfo;
// 存储用户本地信息
- (void)saveUserLocalInfo:(NSDictionary *)localInfo;

// 获取缓存大小 根据路径获得文件大小
- (void)getCacheSizeWithDirectoryPath:(NSString *)directoryPath completion:(void (^ __nullable)(NSString *totalStr, NSInteger totalSize))completion;
// 清除缓存
- (void)removeCacheWithDirectoryPath:(NSString *)directoryPath completion:(void (^ __nullable)(void))completion;
// 定期清理缓存
- (void)clearCacheRegularlyWithSecondsLimit:(NSInteger)secondsLimit;

@end

NS_ASSUME_NONNULL_END
