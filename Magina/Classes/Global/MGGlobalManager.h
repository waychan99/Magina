//
//  MGGlobalManager.h
//  Magina
//
//  Created by mac on 2025/8/12.
//

#import <Foundation/Foundation.h>
#import "SWDeviceCenter.h"
#import "MGAccountInfo.h"

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

/** 账号信息 */
@property (nonatomic, strong) MGAccountInfo * __nullable accountInfo;

/** 是否为当天 */
@property (nonatomic, assign) BOOL isToday;

/** 是否登录 */
@property (nonatomic, assign, getter=isLoggedIn) BOOL loggedIn;

/** 当前总积分（已经登录） */
@property (nonatomic, assign) CGFloat currentPoints;

/** 本地总积分（未登录） */
@property (nonatomic, assign) CGFloat localPoints;

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

// 检查是否为当天
- (void)checkCurrentDate;

// 获取总积分
- (void)requestTotoalPoints;
// 每日赠送积分
- (void)requestDailyBonusPoints;
// 刷新本地积分
- (void)refreshLocalPoints;

/** 收藏模板记录 */
@property (nonatomic, strong) NSMutableArray<NSDictionary *> * __nullable favoriteTemplates;
/** 收藏模板记录存储路径 */
@property (nonatomic, copy) NSString * __nullable favoriteTemplatesPath;
// 添加收藏模板记录
- (void)saveFavoriteTemplateRecord:(NSDictionary *)record;
// 删除收藏模板记录
- (void)deleteFavoriteTemplateRecord:(NSDictionary *)record;
// 删除全部收藏模板记录
- (void)deleteFavoriteTemplateRecords;

// 获取sse服务器配置(链接地址)
- (void)requestSseConfig;
// sse服务器地址
@property (nonatomic, copy) NSString *sse_url;

@end

NS_ASSUME_NONNULL_END

