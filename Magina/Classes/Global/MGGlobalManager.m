//
//  MGGlobalManager.m
//  Magina
//
//  Created by mac on 2025/8/12.
//

#import "MGGlobalManager.h"
#import "NSString+LP.h"
#import <CommonCrypto/CommonDigest.h>

@interface MGGlobalManager ()
@property (nonatomic, copy) NSString *macAddr;
@property (nonatomic, copy) NSString *appVersion;
@property (nonatomic, copy) NSString *userLocalInfoPath;
@property (nonatomic, strong) NSArray *userLocalInfoUrlArr;
@property (nonatomic, assign) NSInteger localInfoRequestIdx;
@end

@implementation MGGlobalManager

@synthesize isToday  = _isToday;
@synthesize loggedIn = _loggedIn;

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
        _rwQueue = dispatch_queue_create("rw_queue", DISPATCH_QUEUE_SERIAL);
        [self createFaceImageSandBoxDirectory];
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
    dispatch_async(_rwQueue, ^{
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

- (NSArray *)userLocalInfoUrlArr {
    if (!_userLocalInfoUrlArr) {
        _userLocalInfoUrlArr = @[LP_USER_LOCAL_INFO_REQUEST_PATH_1, LP_USER_LOCAL_INFO_REQUEST_PATH_3, LP_USER_LOCAL_INFO_REQUEST_PATH_5, LP_USER_LOCAL_INFO_REQUEST_PATH_4, LP_USER_LOCAL_INFO_REQUEST_PATH_2];
    }
    return _userLocalInfoUrlArr;
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

// 获取总积分
- (void)requestTotoalPoints {
    if (self.isLoggedIn) {
        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
        [params setValue:self.accountInfo.user_id forKey:@"user_id"];
        [LVHttpRequest get:@"/api/v1/getTotalPoints" param:params header:@{} baseUrlType:CDHttpBaseUrlTypeMagina_ljw isNeedPublickParam:YES isNeedPublickHeader:YES isNeedEncryptHeader:YES isNeedEncryptParam:YES isNeedDecryptResponse:YES encryptType:CDHttpBaseUrlTypeMagina_ljw timeout:20.0 modelClass:nil completion:^(NSInteger status, NSString * _Nonnull message, id  _Nullable result, NSError * _Nullable error, id  _Nullable responseObject) {
            if (status != 1 || error) {
                return;
            }
            self.currentPoints = [result[@"coin"] floatValue];
        }];
    }
}

// 每日赠送积分
- (void)requestDailyBonusPoints {
    if (self.isLoggedIn) {
        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
        [params setValue:self.accountInfo.user_id forKey:@"user_id"];
        [LVHttpRequest post:@"/api/v1/dailyBonus" param:params header:@{} baseUrlType:CDHttpBaseUrlTypeMagina_ljw isNeedPublickParam:YES isNeedPublickHeader:YES isNeedEncryptHeader:YES isNeedEncryptParam:YES isNeedDecryptResponse:YES encryptType:CDHttpBaseUrlTypeMagina_ljw timeout:20.0 modelClass:nil completion:^(NSInteger status, NSString * _Nonnull message, id  _Nullable result, NSError * _Nullable error, id  _Nullable responseObject) {
            if (status != 1 || error) {
                return;
            }
            self.currentPoints = [result[@"coin"] floatValue];
        }];
    }
}

- (MGAccountInfo *)accountInfo {
    if (!_accountInfo) {
        _accountInfo = [MGAccountInfo mj_objectWithKeyValues:[MGLoginFactory getAccountInfo]];
        if (!_accountInfo) {
            _accountInfo = [[MGAccountInfo alloc] init];
        }
    }
    return _accountInfo;
}

- (BOOL)isLoggedIn {
    return self.accountInfo.access_token.length;
}

- (void)setLoggedIn:(BOOL)loggedIn {
}

- (BOOL)isToday {
    return _isToday;
}

- (void)setIsToday:(BOOL)isToday {
}

- (void)checkCurrentDate {
    NSDateComponents *currentDateCmps = [[NSDate sharedCalendar] components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:[NSDate date]];
    NSDate *currentDate = [[NSDate sharedCalendar] dateFromComponents:currentDateCmps];
    NSDate *localDate = [[NSUserDefaults standardUserDefaults] objectForKey:MG_CURRENT_DATE_KEY];
    if (!localDate) {
        _isToday = NO;
        [[NSUserDefaults standardUserDefaults] setObject:currentDate forKey:MG_CURRENT_DATE_KEY];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } else {
        NSDateComponents *dayInterval = [[NSDate sharedCalendar] components:NSCalendarUnitDay fromDate:currentDate toDate:localDate options:0];
        if (dayInterval.day == 0) {
            _isToday = YES;
        } else {
            _isToday = NO;
            [[NSUserDefaults standardUserDefaults] setObject:currentDate forKey:MG_CURRENT_DATE_KEY];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }
}

- (void)refreshLocalPoints {
    if (!self.isToday && !self.isLoggedIn) {
        self.localPoints = 30.0;
    }
}

- (void)saveFavoriteTemplateRecord:(NSDictionary *)record {
    NSArray *ids = [self.favoriteTemplates valueForKeyPath:@"id"];
    ids = [ids valueForKey:@"stringValue"];
    if ([ids containsObject:record[@"id"]]) {
        [self.favoriteTemplates removeObjectAtIndex:[ids indexOfObject:record[@"id"]]];
    }
    [self.favoriteTemplates insertObject:record atIndex:0];
    [self.favoriteTemplates writeToFile:self.favoriteTemplatesPath atomically:YES];
}

- (void)deleteFavoriteTemplateRecord:(NSDictionary *)record {
    NSArray *ids = [self.favoriteTemplates valueForKeyPath:@"id"];
    ids = [ids valueForKey:@"stringValue"];
    if ([ids containsObject:record[@"id"]]) {
        [self.favoriteTemplates removeObjectAtIndex:[ids indexOfObject:record[@"id"]]];
    }
    [self.favoriteTemplates writeToFile:self.favoriteTemplatesPath atomically:YES];
}

- (void)deleteFavoriteTemplateRecords {
    [self.favoriteTemplates removeAllObjects];
    [self.favoriteTemplates writeToFile:self.favoriteTemplatesPath atomically:YES];
}

- (NSMutableArray<NSDictionary *> *)favoriteTemplates {
    if (!_favoriteTemplates) {
        _favoriteTemplates = [[NSMutableArray alloc] initWithContentsOfFile:self.favoriteTemplatesPath];
        if (!_favoriteTemplates) {
            _favoriteTemplates = [NSMutableArray array];
        }
    }
    return _favoriteTemplates;
}

- (NSString *)favoriteTemplatesPath {
    if (!_favoriteTemplatesPath) {
        _favoriteTemplatesPath = [NSString lp_documentFilePathWithFileName:[NSString stringWithFormat:@"%@_%@", MG_FAVORITE_TEMPLATE_RECORD_PATH, self.accountInfo.user_id]];
    }
    return _favoriteTemplatesPath;
}

- (void)requestSseConfig {
    [LVHttpRequest get:@"/api/v1/sseConfig" param:@{} header:@{} baseUrlType:CDHttpBaseUrlTypeMagina_ljw isNeedPublickParam:YES isNeedPublickHeader:YES isNeedEncryptHeader:YES isNeedEncryptParam:YES isNeedDecryptResponse:YES encryptType:CDHttpBaseUrlTypeMagina_ljw timeout:20.0 modelClass:nil completion:^(NSInteger status, NSString * _Nonnull message, id  _Nullable result, NSError * _Nullable error, id  _Nullable responseObject) {
        if (status != 1 || error) {
            return;
        }
        self.sse_url = result[@"sse_url"];
    }];
}

- (void)checkPasteboardSharedLink {
    if (![MGGlobalManager shareInstance].isLoggedIn) return;
    NSString *pastedString = [UIPasteboard generalPasteboard].string;
    NSString *invite_code = @"";
    if (pastedString.length > 0) {
        NSString *sharedLink = @"https://user.magina.art/share/?invite_code";
        if ([pastedString containsString:sharedLink]) {
            NSURLComponents *components = [NSURLComponents componentsWithString:pastedString];
            for (NSURLQueryItem *item in components.queryItems) {
                if ([item.name isEqualToString:@"invite_code"]) {
                    invite_code = item.value;
                    break;
                }
            }
        }
    }
    if (invite_code.length > 0) {
        [self inviteFriendsRequestWitInviteCode:invite_code];
        [UIPasteboard generalPasteboard].string = nil;
    }
}

- (void)inviteFriendsRequestWitInviteCode:(NSString *)inviteCode {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:inviteCode forKey:@"invite_code"];
    [params setValue:[MGGlobalManager shareInstance].accountInfo.access_token forKey:@"access_token"];
    [LVHttpRequest get:@"/magina-api/api/v1/update_user_relation/index.php" param:params header:@{} baseUrlType:CDHttpBaseUrlTypeMagina isNeedPublickParam:YES isNeedPublickHeader:YES isNeedEncryptHeader:YES isNeedEncryptParam:YES isNeedDecryptResponse:YES encryptType:CDHttpBaseUrlTypeMagina timeout:20.0 modelClass:nil completion:^(NSInteger status, NSString * _Nonnull message, id  _Nullable result, NSError * _Nullable error, id  _Nullable responseObject) {
        if (status != 1 || error) {
            return;
        }
    }];
}

- (void)createFaceImageSandBoxDirectory {
    NSString *documentDir = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    _faceImageDataFileDirPath = [documentDir stringByAppendingPathComponent:MG_FACE_IMAGE_FILES_DIRECTORY_PATH];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir = NO;
    BOOL existed = [fileManager fileExistsAtPath:_faceImageDataFileDirPath isDirectory:&isDir];
    if ( !(isDir == YES && existed == YES) ) {
        [fileManager createDirectoryAtPath:_faceImageDataFileDirPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
}

- (NSString *)faceImageRecordsPath {
    if (!_faceImageRecordsPath) {
        _faceImageRecordsPath = [NSString lp_documentFilePathWithFileName:[NSString stringWithFormat:@"%@_%@", MG_FACE_IMAGE_LIST_CACHE_PATH, self.accountInfo.user_id]];
    }
    return _faceImageRecordsPath;
}

- (NSMutableArray<NSString *> *)faceImageRecords {
    if (!_faceImageRecords) {
        _faceImageRecords = [[NSMutableArray alloc] initWithContentsOfFile:self.faceImageRecordsPath];
        if (!_faceImageRecords) {
            _faceImageRecords = [NSMutableArray array];
        }
    }
    return _faceImageRecords;
}

- (void)saveFaceImage:(UIImage *)image completion:(void (^ __nullable)(void))completion {
    dispatch_async(self.rwQueue, ^{
        NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
        NSString *imageName = [self md5Hash:imageData];
        if ([self.faceImageRecords containsObject:imageName]) {
            [self.faceImageRecords removeObject:imageName];
        }
        [self.faceImageRecords insertObject:imageName atIndex:0];
        if (self.faceImageRecords.count > 20) {
            NSString *lastRecordName = self.faceImageRecords.lastObject;
            NSString *lastFilePath = [self.faceImageDataFileDirPath stringByAppendingPathComponent:lastRecordName];
            [[NSFileManager defaultManager] removeItemAtPath:lastFilePath error:nil];
            [self.faceImageRecords removeLastObject];
        }
        [self.faceImageRecords writeToFile:self.faceImageRecordsPath atomically:YES];
        NSString *filePath = [self.faceImageDataFileDirPath stringByAppendingPathComponent:imageName];
        [imageData writeToFile:filePath atomically:YES];
        dispatch_async(dispatch_get_main_queue(), ^{
            !completion ?: completion();
        });
    });
}

- (void)deleteFaceImageRecord:(NSString *)record completion:(void (^ __nullable)(void))completion {
    dispatch_async(self.rwQueue, ^{
        if ([self.faceImageRecords containsObject:record]) {
            [self.faceImageRecords removeObject:record];
            [self.faceImageRecords writeToFile:self.faceImageRecordsPath atomically:YES];
            NSString *filePath = [self.faceImageDataFileDirPath stringByAppendingPathComponent:record];
            [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
            dispatch_async(dispatch_get_main_queue(), ^{
                !completion ?: completion();
            });
        }
    });
}

- (NSString *)md5Hash:(NSData *)data {
    if (!data) return nil;
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5(data.bytes, (CC_LONG)data.length, digest);
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [output appendFormat:@"%02x", digest[i]];
    }
    return output;
}

@end
