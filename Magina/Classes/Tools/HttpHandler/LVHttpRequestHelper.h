//
//  LVHttpRequestHelper.h
//  Enjoy
//
//  Created by mac on 2025/4/25.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, CDHttpBaseUrlType) {
    CDHttpBaseUrlTypeCloundDesktop = 0,//使用云桌面的
    CDHttpBaseUrlTypeLongTVTotal = 10,//使用longtv总服务器那边的密钥
    CDHttpBaseUrlTypeLongTVSub = 20,//longtv子服务器
    CDHttpBaseUrlTypeLongTVMall = 30,//使用商城的服务器
    CDHttpBaseUrlTypeCommonDomain = 40,//普通域名
    CDHttpBaseUrlTypeAppUpdate = 50,//app更新接口使用
    CDHttpBaseUrlTypeBigMembership = 60,//大会员
    CDHttpBaseUrlTypeLongPartner = 70,//LongPartner
    CDHttpBaseUrlTypeNewAddedLongTV = 80,//LongPartner
    CDHttpBaseUrlTypeAds = 90,//Ads
    CDHttpBaseUrlTypeEnjoy_qwy = 100,
    CDHttpBaseUrlTypeEnjoy_lxc_mall = 110,
    CDHttpBaseUrlTypeEnjoy_lxc_video = 120,
    CDHttpBaseUrlTypeEnjoy_lxc_shared = 130,
    CDHttpBaseUrlTypeFullLink,
};

@interface LVHttpRequestHelper : NSObject

/** 根据baseUrlType拼接请求完整路径 */
+ (NSString *)getRequestPathWithPath:(NSString *)path baseUrlType:(CDHttpBaseUrlType)baseUrlType;

/** 获取公共参数 */
+ (NSMutableDictionary *)getPublicParam;

/** 获取公共头部参数 */
+ (NSMutableDictionary *)getPublicHeaderParam;

/** 参数加密 */
+ (NSMutableDictionary *)paramEncryption:(NSDictionary *)param keyType:(CDHttpBaseUrlType)type;

/** 参数加密成字符串 */
+ (NSString *)encryptionDict:(NSDictionary *)dict keyType:(CDHttpBaseUrlType)type;

/** 头部参数加密 */
+ (NSMutableDictionary *)headerEncryption:(NSDictionary *)header keyType:(CDHttpBaseUrlType)type;

/** 加密字符串 */
+ (NSString *)encryptionString:(NSString *)needEncryptionStr keyType:(CDHttpBaseUrlType)type;

/** 解密字符串 */
+ (NSString *)aesDecryString:(NSString *)needDecryStr keyType:(CDHttpBaseUrlType)type;

/** 将参数键值对转换成'key1=value1&key2=value2'格式 */
+ (NSString *)formatterParam:(NSDictionary *)param;

/** 获取当前语言 */
+ (NSString *)getCurrentLanguage;

/** 拼接两个字典 */
+ (NSMutableDictionary *)dict:(NSDictionary *)dict byAppendingDict:(NSDictionary *)aDict;

/** 非字符串、null或者@""都返回yes */
+ (BOOL)isNullStr:(NSString *)string;

/** 解密响应数据 */
+ (NSDictionary *)aesDecryHttpResponseStringBy:(NSString *)encryString keyType:(CDHttpBaseUrlType)type;

+ (NSString *)URLEncodedString:(NSString *)str;

+ (NSString *)URLDecodedString:(NSString *)str;

@end

NS_ASSUME_NONNULL_END
