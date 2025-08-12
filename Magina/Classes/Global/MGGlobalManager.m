//
//  MGGlobalManager.m
//  Magina
//
//  Created by mac on 2025/8/12.
//

#import "MGGlobalManager.h"
#import "NSString+LP.h"

@interface MGGlobalManager () {
    dispatch_queue_t _rwQueue;
}
@property (nonatomic, copy) NSString *macAddr;
@property (nonatomic, copy) NSString *appVersion;
@property (nonatomic, copy) NSString *userLocalInfoPath;
@property (nonatomic, strong) NSArray *userLocalInfoUrlArr;
@property (nonatomic, assign) NSInteger localInfoRequestIdx;
@end

@implementation MGGlobalManager

static MGGlobalManager *_instance;

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

#pragma mark businessMethod
- (instancetype)init {
    if (self = [super init]) {
        _rwQueue = dispatch_queue_create("rw_queue", DISPATCH_QUEUE_CONCURRENT);
    }
    return self;
}

- (NSString *)macAddr {
    if (!_macAddr) {
        _macAddr = [SWDeviceCenter getUUID];
    }
    return _macAddr;
}

- (NSString *)appVersion {
    if (!_appVersion) {
        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
        _appVersion = app_Version;
    }
    return _appVersion;
}

- (NSString *)deviceType {
    if (!_deviceType) {
        _deviceType = [SWDeviceCenter hardwareVersion];
    }
    return _deviceType;
}

- (void)saveUserLocalInfo:(NSDictionary *)localInfo {
    dispatch_barrier_async(_rwQueue, ^{
        if (localInfo) {
            [localInfo writeToFile:self.userLocalInfoPath atomically:YES];
        }
        if (!self.userLocalInfoParams) {
            if (localInfo) {
                self->_userLocalInfoParams = [NSMutableDictionary dictionary];
                if (localInfo[@"query"]) {
                    [self->_userLocalInfoParams setValue:localInfo[@"query"] forKey:@"ip"];
                } else {
                    [self->_userLocalInfoParams setValue:localInfo[@"ip"] forKey:@"ip"];
                }
                
                if (localInfo[@"country"]) {
                    [self->_userLocalInfoParams setValue:localInfo[@"country"] forKey:@"common-country"];
                } else {
                    [self->_userLocalInfoParams setValue:localInfo[@"country_name"] forKey:@"common-country"];
                }
                
                if (localInfo[@"region"]) {
                    [self->_userLocalInfoParams setValue:localInfo[@"region"] forKey:@"common-region"];
                } else {
                    [self->_userLocalInfoParams setValue:localInfo[@"region_name"] forKey:@"common-region"];
                }
                
                [self->_userLocalInfoParams setValue:localInfo[@"city"] forKey:@"common-city"];
                
                if (localInfo[@"isp"]) {
                    [self->_userLocalInfoParams setValue:localInfo[@"isp"] forKey:@"common-isp"];
                } else {
                    [self->_userLocalInfoParams setValue:localInfo[@"organisation"] forKey:@"common-isp"];
                }
                
                if (localInfo[@"org"]) {
                    [self->_userLocalInfoParams setValue:localInfo[@"org"] forKey:@"common-org"];
                } else {
                    [self->_userLocalInfoParams setValue:localInfo[@"organisation"] forKey:@"common-org"];
                }
                
                if (localInfo[@"lat"]) {
                    [self->_userLocalInfoParams setValue:localInfo[@"lat"] forKey:@"common-lat"];
                } else {
                    [self->_userLocalInfoParams setValue:localInfo[@"latitude"] forKey:@"common-lat"];
                }
                
                if (localInfo[@"lon"]) {
                    [self->_userLocalInfoParams setValue:localInfo[@"lon"] forKey:@"common-lon"];
                } else {
                    [self->_userLocalInfoParams setValue:localInfo[@"longitude"] forKey:@"common-lon"];
                }
                
                if (localInfo[@"countryCode"]) {
                    [self->_userLocalInfoParams setValue:localInfo[@"countryCode"] forKey:@"country_code"];
                }
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:MG_USER_LOCAL_INFO_REQUEST_SUCCESSED_NOTI object:nil];
        });
    });
}

- (void)requestUserLocalInfo {
    [LVHttpRequest get:self.userLocalInfoUrlArr[self.localInfoRequestIdx] param:@{} header:@{} baseUrlType:CDHttpBaseUrlTypeFullLink isNeedPublickParam:NO isNeedPublickHeader:NO isNeedEncryptHeader:NO isNeedEncryptParam:NO isNeedDecryptResponse:NO encryptType:CDHttpBaseUrlTypeFullLink timeout:20.0 modelClass:nil completion:^(NSInteger status, NSString * _Nonnull message, id  _Nullable result, NSError * _Nullable error, id  _Nullable responseObject) {
        if (!error && result && [result isKindOfClass:[NSDictionary class]]) {
            if ([result objectForKey:@"status"]) {
                if ([[result objectForKey:@"status"] isEqualToString:@"success"]) {
                    self.localInfoRequestIdx = 0;
                    [self saveUserLocalInfo:result];
                } else {
                    self.localInfoRequestIdx += 1;
                    if (self.localInfoRequestIdx >= self.userLocalInfoUrlArr.count) {
                        self.localInfoRequestIdx = 0;
                        return;
                    }
                    [self requestUserLocalInfo];
                }
            } else {
                self.localInfoRequestIdx = 0;
                [self saveUserLocalInfo:result];
            }
        } else {
            self.localInfoRequestIdx += 1;
            if (self.localInfoRequestIdx >= self.userLocalInfoUrlArr.count) {
                self.localInfoRequestIdx = 0;
                return;
            }
            [self requestUserLocalInfo];
        }
    }];
}

- (void)getCacheSizeWithDirectoryPath:(NSString *)directoryPath completion:(void (^)(NSString * _Nonnull, NSInteger))completion {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSFileManager *mgr = [NSFileManager defaultManager];
        BOOL isDirectory;
        BOOL isExist =  [mgr fileExistsAtPath:directoryPath isDirectory:&isDirectory];
        if (!isDirectory || !isExist){
            NSException *excp = [NSException exceptionWithName:@"directory path error" reason:@"需要传入存在的文件夹路径" userInfo:nil];
            [excp raise];
        };
        
        NSArray *subPaths = [mgr subpathsAtPath:directoryPath];
        NSInteger totalSize = 0;
        for (NSString *subPath in subPaths) {
            NSString *filePath = [directoryPath stringByAppendingPathComponent:subPath];
            // 忽略隐藏文件
            if([filePath containsString:@".DS"]) continue;
            // 判断是否是文件夹
            BOOL isDirectory;
            BOOL isExist =  [mgr fileExistsAtPath:filePath isDirectory:&isDirectory];
            
            if(isDirectory || !isExist) continue;
            
            NSDictionary *attr = [mgr attributesOfItemAtPath:filePath error:nil];
            NSInteger fileSize = [attr fileSize];
            totalSize += fileSize;
        }
        
        NSString *totalStr = @"";
        if (totalSize >= 1000 * 1000) {
            totalStr = [NSString stringWithFormat:@"%.2fMB",totalSize / (1000.00f * 1000.00f)];
        } else if ((long)totalSize >= 1000) {
            totalStr = [NSString stringWithFormat:@"%.2fKB",totalSize / 1000.00f];
        } else {
            totalStr = [NSString stringWithFormat:@"%.2fB",totalSize / 1.00f];
        }
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            !completion ?: completion(totalStr, totalSize);
        });
    });
}

- (void)removeCacheWithDirectoryPath:(NSString *)directoryPath completion:(void (^)(void))completion {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSFileManager *mgr = [NSFileManager defaultManager];
        BOOL isDirectory;
        BOOL isExist =  [mgr fileExistsAtPath:directoryPath isDirectory:&isDirectory];
        if (!isDirectory || !isExist) {
            NSException *excp =[NSException exceptionWithName:@"directory path error" reason:@"需传入存在的文件夹路径" userInfo:nil];
            [excp raise];
        };
        
        NSArray *subPaths = [mgr contentsOfDirectoryAtPath:directoryPath error:nil];
        for (NSString *subPath in subPaths) {
            NSString *filePath = [directoryPath stringByAppendingPathComponent:subPath];
            [mgr removeItemAtPath:filePath error:nil];
        }
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            !completion ?: completion();
        });
    });
}

- (void)clearCacheRegularlyWithSecondsLimit:(NSInteger)secondsLimit {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSTimeInterval interval = [[NSDate date] timeIntervalSince1970];
        NSString *localIntervalStr = [[NSUserDefaults standardUserDefaults] stringForKey:LTV_CLEAN_CACHE_TIMESTAMPS_KEY];
        if (localIntervalStr.length > 0) {
            if ([@(interval) longLongValue] >= [localIntervalStr longLongValue]) {
                [self removeCacheWithDirectoryPath:[NSString lp_cachesFilePathWithFileName:@""] completion:^{
                    NSString *expectedIntervalStr = [NSString stringWithFormat:@"%lld", ((long long)interval + secondsLimit)];
                    [[NSUserDefaults standardUserDefaults] setObject:expectedIntervalStr forKey:LTV_CLEAN_CACHE_TIMESTAMPS_KEY];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                }];
            }
        } else {
            NSString *expectedIntervalStr = [NSString stringWithFormat:@"%lld", ((long long)interval + secondsLimit)];
            [[NSUserDefaults standardUserDefaults] setObject:expectedIntervalStr forKey:LTV_CLEAN_CACHE_TIMESTAMPS_KEY];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    });
}

@end
