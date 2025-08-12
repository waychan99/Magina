//
//  LVHttpRequest.m
//  Enjoy
//
//  Created by mac on 2025/4/25.
//

#import "LVHttpRequest.h"

static const NSInteger k_httpFailtureStatus = -1;

@implementation LVUploadParam

- (instancetype)initWithData:(NSData *)data
                   paramName:(NSString *)paramName
                    fileName:(NSString *)fileName
                    mineType:(NSString *)mineType {
    if (self = [super init]) {
        _data = data;
        _paramName = paramName;
        _fileName = fileName;
        _mineType = mineType;
    }
    return self;
}

@end


@interface LVHttpRequest ()

@property (nonatomic, strong) AFHTTPSessionManager *sessionManager;

@end

@implementation LVHttpRequest

static LVHttpRequest *_instance;

+ (id)allocWithZone:(struct _NSZone *)zone{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    return _instance;
}

+ (instancetype)shareInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}

- (id)copyWithZone:(NSZone *)zone {
    return _instance;
}

- (instancetype)init {
    if (self = [super init]) {
        self.sessionManager = [AFHTTPSessionManager manager];
        
//        self.sessionManager.requestSerializer = [AFJSONRequestSerializer serializer];
//        [self.sessionManager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        self.sessionManager.requestSerializer.timeoutInterval = 20.0;
        
        self.sessionManager.responseSerializer = [AFJSONResponseSerializer serializer];
        self.sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain",@"application/x-www-form-urlencoded", nil];
    }
    return self;
}

+ (void)get:(NSString *)path
                param:(NSDictionary *)param
               header:(NSDictionary  * _Nullable )header
          baseUrlType:(CDHttpBaseUrlType)baseUrlType
   isNeedPublickParam:(BOOL)isNeedPublickParam
  isNeedPublickHeader:(BOOL)isNeedPublickHeader
  isNeedEncryptHeader:(BOOL)isNeedEncryptHeader
   isNeedEncryptParam:(BOOL)isNeedEncryptParam
isNeedDecryptResponse:(BOOL)isNeedDecryptResponse
          encryptType:(CDHttpBaseUrlType)encryptType
              timeout:(NSTimeInterval)timeout
           modelClass:(Class __nullable)modelClass
           completion:(nonnull LVHttpResponseCompletion)completion {
    __block NSDictionary *parameter = param;
    __block NSDictionary *passedHeader = header;
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{ //在异步线程下执行参数拼接、加密、遍历排序等稍微耗时的操作，以提高流畅度
    LVHttpRequest *request = [LVHttpRequest shareInstance];
        if (timeout > 0) {
            request.sessionManager.requestSerializer.timeoutInterval = timeout;
        }
        __block NSMutableDictionary *decryParam = [NSMutableDictionary dictionaryWithDictionary:parameter];
        if (isNeedPublickParam) {
            parameter = [LVHttpRequestHelper dict:parameter byAppendingDict:[LVHttpRequestHelper getPublicParam]];
            decryParam = [NSMutableDictionary dictionaryWithDictionary:parameter];
        }
        if (isNeedEncryptParam) {
            parameter = [LVHttpRequestHelper paramEncryption:parameter keyType:encryptType];
        }
        if (isNeedPublickHeader) {
            NSMutableDictionary *publickHeader = [LVHttpRequestHelper getPublicHeaderParam];
            passedHeader = [LVHttpRequestHelper dict:passedHeader ? passedHeader : @{} byAppendingDict:publickHeader];
            if (isNeedEncryptHeader) {
                passedHeader = [LVHttpRequestHelper headerEncryption:passedHeader keyType:encryptType];
            }
        }
        
        [request.sessionManager GET:[LVHttpRequestHelper getRequestPathWithPath:path baseUrlType:baseUrlType] parameters:parameter headers:passedHeader progress:^(NSProgress * _Nonnull downloadProgress) {
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            NSError *error = nil;
            NSDictionary *resultDict = nil;
            if ([responseObject isKindOfClass:[NSDictionary class]] || [responseObject isKindOfClass:[NSArray class]]) {
                resultDict = responseObject;
            } else {
                resultDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&error];
            }
            if (!resultDict) {
                if ([responseObject isKindOfClass:[NSData class]]) {
                    NSString *resultStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
                    LVLog(@"HttpFailure(**json parsing**)\nURL:%@\nallheadeField:%@\nparams:%@\ndecryParam:%@\nresponseObject:%@\nerrorDes:%@\nerrorData:%@",task.currentRequest.URL,task.currentRequest.allHTTPHeaderFields,parameter,decryParam,resultStr,error?error.localizedDescription:@"",error);
                    completion(k_httpFailtureStatus, @"get a error json.!", resultStr, error, responseObject);
                    return;
                } else {
                    completion(k_httpFailtureStatus, @"get json is error.!", responseObject, error, responseObject);
                    return;
                }
            }
            
            id resultData = resultDict;
            NSNumber *statusTemp = [resultDict objectForKey:@"status"] ?: [resultDict objectForKey:@"code"];
            NSString *statusStr = [NSString stringWithFormat:@"%@", statusTemp ? statusTemp : @(0)];
            NSInteger status = [statusStr intValue];
            NSString *resultMsg = [resultDict objectForKey:@"msg"];
            if (!resultMsg) {
                resultMsg = [resultDict objectForKey:@"message"];
                if (!resultMsg) resultMsg = @"";
            }
            if ([resultData isKindOfClass:[NSDictionary class]] && [resultData objectForKey:@"data"]) {
                resultData = [resultData objectForKey:@"data"];
                if (isNeedDecryptResponse) {
                    if ([resultData isKindOfClass:[NSString class]]) {
                        NSDictionary *decryResultDict = [LVHttpRequestHelper aesDecryHttpResponseStringBy:resultData keyType:encryptType];
                        if (!decryResultDict) {
                            LVLog(@"HttpFailure(**decrypt resultData**)\nURL:%@\nallheadeField:%@\nparams:%@\ndecryParam:%@\nresponseObject:%@\nerrorDes:%@\nerrorData:%@",task.currentRequest.URL,task.currentRequest.allHTTPHeaderFields,parameter,decryParam,resultDict,error?error.localizedDescription:@"",error);
                            completion(k_httpFailtureStatus, @"responseObject decry failture.", resultData, nil, responseObject);
                            return;
                        }
                        resultData =  decryResultDict;
                    }
                }
            }
            
            id finalResultData = resultData;
            if (modelClass) {
                if ([resultData isKindOfClass:[NSArray class]]) {
                    finalResultData = [modelClass mj_objectArrayWithKeyValuesArray:(NSArray *)resultData];
                } else if ([resultData isKindOfClass:[NSDictionary class]]) {
                    finalResultData = [modelClass mj_objectWithKeyValues:resultData];
                }
                completion(status, resultMsg, finalResultData, nil, responseObject);
            } else {
                completion(status, resultMsg, finalResultData, nil, responseObject);
            }
            
            LVLog(@"HttpRequestSuccess!^_^!\nURL:%@\nheader:%@\nparams:%@\ndecryParam:%@\nresponseObject:%@",task.currentRequest.URL,task.currentRequest.allHTTPHeaderFields,parameter,decryParam,responseObject);
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSData *errorData = error.userInfo[@"com.alamofire.serialization.response.error.data"];
            NSString *errorDes = errorData ? [[NSString alloc]initWithData:errorData encoding:NSUTF8StringEncoding] : NSLocalizedString(@"LP_networkErrorDescription", nil);
            LVLog(@"HttpRequestFailure!~_~!!!\nURL:%@\nheader:%@\nparam:%@\ndecryParam:%@\nrquestErro:%@",task.currentRequest.URL,task.currentRequest.allHTTPHeaderFields,parameter,decryParam,error.userInfo);
            LVLog(@"errorDes = %@",errorDes);
            LVLog(@"error = %@",error);
            completion(k_httpFailtureStatus, errorDes, nil, error, nil);
        }];
//    });
}

+ (void)post:(NSString *)path
                param:(NSDictionary *)param
               header:(NSDictionary *)header
          baseUrlType:(CDHttpBaseUrlType)baseUrlType
   isNeedPublickParam:(BOOL)isNeedPublickParam
  isNeedPublickHeader:(BOOL)isNeedPublickHeader
  isNeedEncryptHeader:(BOOL)isNeedEncryptHeader
   isNeedEncryptParam:(BOOL)isNeedEncryptParam
isNeedDecryptResponse:(BOOL)isNeedDecryptResponse
          encryptType:(CDHttpBaseUrlType)encryptType
              timeout:(NSTimeInterval)timeout
           modelClass:(Class)modelClass
           completion:(LVHttpResponseCompletion)completion {
    __block NSDictionary *parameter = param;
    __block NSDictionary *passedHeader = header;
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        LVHttpRequest *request = [LVHttpRequest shareInstance];
        if (timeout > 0) {
            request.sessionManager.requestSerializer.timeoutInterval = timeout;
        }
        __block NSMutableDictionary *decryParam = [NSMutableDictionary dictionaryWithDictionary:parameter];
        if (isNeedPublickParam) {
            parameter = [LVHttpRequestHelper dict:parameter byAppendingDict:[LVHttpRequestHelper getPublicParam]];
            decryParam = [NSMutableDictionary dictionaryWithDictionary:parameter];
        }
        if (isNeedEncryptParam) {
            parameter = [LVHttpRequestHelper paramEncryption:parameter keyType:encryptType];
        }
        if (isNeedPublickHeader) {
            NSMutableDictionary *publickHeader = [LVHttpRequestHelper getPublicHeaderParam];
            passedHeader = [LVHttpRequestHelper dict:passedHeader ? passedHeader : @{} byAppendingDict:publickHeader];
            if (isNeedEncryptHeader) {
                passedHeader = [LVHttpRequestHelper headerEncryption:passedHeader keyType:encryptType];
            }
        }
        
        [request.sessionManager POST:[LVHttpRequestHelper getRequestPathWithPath:path baseUrlType:baseUrlType] parameters:parameter headers:passedHeader progress:^(NSProgress * _Nonnull uploadProgress) {
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            NSError *error = nil;
            NSDictionary *resultDict = nil;
            if ([responseObject isKindOfClass:[NSDictionary class]] || [responseObject isKindOfClass:[NSArray class]]) {
                resultDict = responseObject;
            } else {
                resultDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&error];
            }
            if (!resultDict) {
                if ([responseObject isKindOfClass:[NSData class]]) {
                    NSString *resultStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
                    LVLog(@"HttpFailure(**json parsing**)\nURL:%@\nallheadeField:%@\nparams:%@\ndecryParam:%@\nresponseObject:%@\nerrorDes:%@\nerrorData:%@",task.currentRequest.URL,task.currentRequest.allHTTPHeaderFields,parameter,decryParam,resultStr,error?error.localizedDescription:@"",error);
                    completion(k_httpFailtureStatus, @"get a error json.!", resultStr, error, responseObject);
                    return;
                } else {
                    completion(k_httpFailtureStatus, @"get json is error.!", responseObject, error, responseObject);
                    return;
                }
            }
            
            id resultData = resultDict;
            NSNumber *statusTemp = [resultDict objectForKey:@"status"] ?: [resultDict objectForKey:@"code"];
            NSString *statusStr = [NSString stringWithFormat:@"%@", statusTemp ? statusTemp : @(0)];
            NSInteger status = [statusStr intValue];
            NSString *resultMsg = [resultDict objectForKey:@"msg"];
            if (!resultMsg) {
                resultMsg = [resultDict objectForKey:@"message"];
                if (!resultMsg) resultMsg = @"";
            }
            if ([resultData isKindOfClass:[NSDictionary class]] && [resultData objectForKey:@"data"]) {
                resultData = [resultData objectForKey:@"data"];
                if (isNeedDecryptResponse) {
                    if ([resultData isKindOfClass:[NSString class]]) {
                        NSDictionary *decryResultDict = [LVHttpRequestHelper aesDecryHttpResponseStringBy:resultData keyType:encryptType];
                        if (!decryResultDict) {
                            LVLog(@"HttpFailure(**decrypt resultData**)\nURL:%@\nallheadeField:%@\nparams:%@\ndecryParam:%@\nresponseObject:%@\nerrorDes:%@\nerrorData:%@",task.currentRequest.URL,task.currentRequest.allHTTPHeaderFields,parameter,decryParam,resultDict,error?error.localizedDescription:@"",error);
                            completion(k_httpFailtureStatus, @"responseObject decry failture.", resultData, nil, responseObject);
                            return;
                        }
                        resultData =  decryResultDict;
                    }
                }
            }
            
            id finalResultData = resultData;
            if (modelClass) {
                if ([resultData isKindOfClass:[NSArray class]]) {
                    finalResultData = [modelClass mj_objectArrayWithKeyValuesArray:(NSArray *)resultData];
                } else if ([resultData isKindOfClass:[NSDictionary class]]) {
                    finalResultData = [modelClass mj_objectWithKeyValues:resultData];
                }
                completion(status, resultMsg, finalResultData, nil, responseObject);
            } else {
                completion(status, resultMsg, finalResultData, nil, responseObject);
            }
            
            LVLog(@"HttpRequestSuccess!^_^!\nURL:%@\nheader:%@\nparams:%@\ndecryParam:%@\nresponseObject:%@",task.currentRequest.URL,task.currentRequest.allHTTPHeaderFields,parameter,decryParam,responseObject);
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSData *errorData = error.userInfo[@"com.alamofire.serialization.response.error.data"];
            NSString *errorDes = errorData ? [[NSString alloc]initWithData:errorData encoding:NSUTF8StringEncoding] : NSLocalizedString(@"LP_networkErrorDescription", nil);
            LVLog(@"HttpRequestFailure!~_~!!!\nURL:%@\nheader:%@\nparam:%@\ndecryParam:%@\nrquestErro:%@",task.currentRequest.URL,task.currentRequest.allHTTPHeaderFields,parameter,decryParam,error.userInfo);
            LVLog(@"errorDes = %@",errorDes);
            LVLog(@"error = %@",error);
            completion(k_httpFailtureStatus, errorDes, nil, error, nil);
        }];
//    });
}

+ (void)upload:(NSString *)path
         param:(NSDictionary *)param
        header:(NSDictionary  * _Nullable )header
   uploadParam:(LVUploadParam *)uploadParam
       success:(void (^)(id result))success
       failure:(void (^)(NSError *error))failure {
    LVHttpRequest *request = [LVHttpRequest shareInstance];
    [request.sessionManager POST:path parameters:param headers:header constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:uploadParam.data name:uploadParam.paramName fileName:uploadParam.fileName mimeType:uploadParam.mineType];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        !success ?: success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        !failure ?: failure(error);
    }];
}

+ (void)upload:(NSString *)path
         param:(NSDictionary *)param
        header:(NSDictionary  * _Nullable )header
   uploadParam:(LVUploadParam *)uploadParam
      progress:(nullable void (^)(NSProgress * _Nonnull))progress
       success:(void (^)(id result))success
       failure:(void (^)(NSError *error))failure {
    LVHttpRequest *request = [LVHttpRequest shareInstance];
    [request.sessionManager POST:path parameters:param headers:header constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:uploadParam.data name:uploadParam.paramName fileName:uploadParam.fileName mimeType:uploadParam.mineType];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        !progress ?: progress(uploadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        !success ?: success(responseObject);
        LVLog(@"HttpRequestSuccess!^_^!\nURL:%@\nheader:%@\nparams:%@\nresponseObject:%@",task.currentRequest.URL,task.currentRequest.allHTTPHeaderFields,param,responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        !failure ?: failure(error);
        
        NSData *errorData = error.userInfo[@"com.alamofire.serialization.response.error.data"];
        NSString *errorDes = errorData ? [[NSString alloc]initWithData:errorData encoding:NSUTF8StringEncoding] : NSLocalizedString(@"LP_networkErrorDescription", nil);
        LVLog(@"HttpRequestFailure!~_~!!!\nURL:%@\nheader:%@\nrquestErro:%@",task.currentRequest.URL,task.currentRequest.allHTTPHeaderFields,error.userInfo);
        LVLog(@"errorDes = %@",errorDes);
        LVLog(@"error = %@",error);
        
    }];
}

@end
