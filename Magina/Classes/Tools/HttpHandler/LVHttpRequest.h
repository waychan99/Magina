//
//  LVHttpRequest.h
//  Enjoy
//
//  Created by mac on 2025/4/25.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>
#import "LVHttpRequestHelper.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^LVHttpResponseCompletion)(NSInteger status, NSString *message, id _Nullable result, NSError * _Nullable error, id _Nullable responseObject);

@interface LVUploadParam : NSObject

/** 上传文件 */
@property (nonatomic, strong) NSData *data;

/** 文件参数名，必须与服务器一致 */
@property (nonatomic, copy) NSString *paramName;

/** 文件名 */
@property (nonatomic, copy) NSString *fileName;

/** 上传文件类型 */
@property (nonatomic, copy) NSString *mineType;

- (instancetype)initWithData:(NSData *)data
                   paramName:(NSString *)paramName
                    fileName:(NSString *)fileName
                    mineType:(NSString *)mineType;

@end

@interface LVHttpRequest : NSObject

+ (instancetype)shareInstance;

@property (nonatomic, strong, readonly) AFHTTPSessionManager *sessionManager;

/**
 * get请求 *********************************
 * @param path                  : 请求路径
 * @param param                 : 请求参数
 * @param header                : 请求头
 * @param baseUrlType           : 服务器路径类型
 * @param isNeedPublickParam    : 是否需要设置公共参数
 * @param isNeedPublickHeader   : 是否需要设置公共头信息
 * @param isNeedEncryptHeader   : 是否需要加密头信息
 * @param isNeedEncryptParam    : 是否需要加密参数
 * @param isNeedDecryptResponse : 是否需要解密返回数据
 * @param encryptType           : 加密类型
 * @param timeout               : 超时时间
 * @param modelClass            : 需要解析的模型类名
 */
+ (void)get:(NSString *)path
                param:(NSDictionary *)param
               header:(NSDictionary  * _Nullable)header
          baseUrlType:(CDHttpBaseUrlType)baseUrlType
   isNeedPublickParam:(BOOL)isNeedPublickParam
  isNeedPublickHeader:(BOOL)isNeedPublickHeader
  isNeedEncryptHeader:(BOOL)isNeedEncryptHeader
   isNeedEncryptParam:(BOOL)isNeedEncryptParam
isNeedDecryptResponse:(BOOL)isNeedDecryptResponse
          encryptType:(CDHttpBaseUrlType)encryptType
              timeout:(NSTimeInterval)timeout
           modelClass:(Class __nullable)modelClass
           completion:(LVHttpResponseCompletion)completion;

/**
 * post请求 *********************************
 * @param path                  : 请求路径
 * @param param                 : 请求参数
 * @param header                : 请求头
 * @param baseUrlType           : 服务器路径类型
 * @param isNeedPublickParam    : 是否需要设置公共参数
 * @param isNeedPublickHeader   : 是否需要设置公共头信息
 * @param isNeedEncryptHeader   : 是否需要加密头信息
 * @param isNeedEncryptParam    : 是否需要加密参数
 * @param isNeedDecryptResponse : 是否需要解密返回数据
 * @param encryptType           : 加密类型
 * @param timeout               : 超时时间
 * @param modelClass            : 需要解析的模型类名
 */
+ (void)post:(NSString *)path
                param:(NSDictionary *)param
               header:(NSDictionary  * _Nullable)header
          baseUrlType:(CDHttpBaseUrlType)baseUrlType
   isNeedPublickParam:(BOOL)isNeedPublickParam
  isNeedPublickHeader:(BOOL)isNeedPublickHeader
  isNeedEncryptHeader:(BOOL)isNeedEncryptHeader
   isNeedEncryptParam:(BOOL)isNeedEncryptParam
isNeedDecryptResponse:(BOOL)isNeedDecryptResponse
          encryptType:(CDHttpBaseUrlType)encryptType
              timeout:(NSTimeInterval)timeout
           modelClass:(Class __nullable)modelClass
           completion:(LVHttpResponseCompletion)completion;

/**
 * post(上传文件)请求 *********************************
 * @param path                  : 请求路径
 * @param param                 : 请求参数
 * @param header                : 请求头
 * @param uploadParam           : 上传参数
 */
+ (void)upload:(NSString *)path
         param:(NSDictionary *)param
        header:(NSDictionary  * _Nullable)header
   uploadParam:(LVUploadParam *)uploadParam
       success:(void (^)(id result))success
       failure:(void (^)(NSError *error))failure;

+ (void)upload:(NSString *)path
         param:(NSDictionary *)param
        header:(NSDictionary  * _Nullable)header
   uploadParam:(LVUploadParam *)uploadParam
      progress:(nullable void (^)(NSProgress * _Nonnull))progress
       success:(void (^)(id result))success
       failure:(void (^)(NSError *error))failure;

@end

NS_ASSUME_NONNULL_END
