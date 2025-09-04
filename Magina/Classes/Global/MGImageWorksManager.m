//
//  MGImageWorksManager.m
//  Magina
//
//  Created by mac on 2025/8/27.
//

#import "MGImageWorksManager.h"
#import "NSString+LP.h"
#import "EventSource.h"

@interface MGImageWorksManager ()
@property (nonatomic, strong) dispatch_queue_t imageWorksQueue;
@property (nonatomic, strong) EventSource *eventSource;
@property (nonatomic, strong) NSURL *sseUrl;
@property (nonatomic, strong) NSMutableArray<MGImageWorksModel *> *inProductionWorksList;
@end

@implementation MGImageWorksManager

static MGImageWorksManager *_instance;

+ (id)allocWithZone:(struct _NSZone *)zone {
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
        _imageWorksQueue = dispatch_queue_create("imageWorksQueue", DISPATCH_QUEUE_SERIAL);
        [self createImageWorksSandBoxDirectory];
    }
    return self;
}

- (void)productionImageWorksWithName:(NSString *)name generatedTag:(NSString *)generatedTag worksCount:(NSInteger)worksCount completion:(void (^)(MGImageWorksModel * _Nonnull))completion {
    if (![MGGlobalManager shareInstance].isLoggedIn || generatedTag.length <= 0 || worksCount <= 0) return;
    NSMutableIndexSet *productionIndexSet = [NSMutableIndexSet indexSet];
    [self.inProductionWorksList enumerateObjectsUsingBlock:^(MGImageWorksModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.generatedImageWorksList.count == obj.generatedImageWorksCount) {
            [productionIndexSet addIndex:idx];
        }
    }];
    if (productionIndexSet.count > 0) {
        [self.inProductionWorksList removeObjectsAtIndexes:productionIndexSet];
    }
    if (self.inProductionWorksList.count <= 0) {
        [self.eventSource close];
    }
    self.eventSource = [EventSource eventSourceWithURL:self.sseUrl];
    MGImageWorksModel *worksModel = [[MGImageWorksModel alloc] init];
    worksModel.generatedTag = generatedTag;
    worksModel.generatedImageWorksCount = worksCount;
    if (name.length > 0) worksModel.name = name;
    [self.inProductionWorksList addObject:worksModel];
    
    NSMutableArray *generatedSuccessedArrM = [NSMutableArray array];
    [self.eventSource onMessage:^(Event *event) {
        LVLog(@"onMessage: %@", event.data);
        dispatch_async(self->_imageWorksQueue, ^{
            if ([event.data containsString:@"finish"]) {
                [self.inProductionWorksList enumerateObjectsUsingBlock:^(MGImageWorksModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if ([event.data containsString:obj.generatedTag]) {
                        NSDictionary *info = [event.data mj_JSONObject];
                        NSString *imageUrl = info[@"image"];
                        if ([obj.generatedImageWorksList containsObject:imageUrl]) {
                            LVLog(@"重复返回同一张图片");
                            *stop = YES;
                            return;
                        }
                        [obj.generatedImageWorksList addObject:imageUrl];
                        if (obj.generatedImageWorksList.count == obj.generatedImageWorksCount) {
                            [generatedSuccessedArrM addObject:obj];
                            NSArray *generatedTags = [self.imageWorks valueForKeyPath:@"generatedTag"];
                            if (![generatedTags containsObject:obj.generatedTag]) {
                                long long currentTimeStamp = (long long)([[NSDate date] timeIntervalSince1970] * 1000);
                                obj.generatedTime = currentTimeStamp;
                                [self.imageWorks insertObject:obj atIndex:0];
                                [self saveImageWorksCompletion:^(NSMutableArray<MGImageWorksModel *> * _Nonnull imageWorks) {
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        !completion ?: completion(obj); //此处赋值block回调的话，sse一直不断开，回调也能成功，但无法做UI操作，具体原因不知，用通知则正常
                                        [[NSNotificationCenter defaultCenter] postNotificationName:MG_IMAGE_WORKS_GENERATED_SUCCESSED_NOTI object:obj];
                                    });
                                    [self downloadImageWorksModel:obj completion:nil];
                                }];
                            }
                        }
                        *stop = YES;
                    }
                }];
                if (generatedSuccessedArrM.count > 0) {
                    [self.inProductionWorksList removeObjectsInArray:generatedSuccessedArrM];
                    [generatedSuccessedArrM removeAllObjects];
                }
                if (self.inProductionWorksList.count <= 0) {
                    [self.eventSource close];
                }
            }
        });
    }];
}

- (void)loadImageWorksCompletion:(void (^)(NSMutableArray<MGImageWorksModel *> * _Nonnull))completion {
    dispatch_async(_imageWorksQueue, ^{
        self.imageWorks = [MGImageWorksModel mj_objectArrayWithKeyValuesArray:[[NSMutableArray alloc] initWithContentsOfFile:[NSString lp_documentFilePathWithFileName:[NSString stringWithFormat:@"%@_%@", MG_IMAGE_WORKS_LIST_CACHE_PATH, [MGGlobalManager shareInstance].accountInfo.user_id]]]];
        !completion ?: completion(self.imageWorks);
    });
}

- (void)saveImageWorksCompletion:(void (^)(NSMutableArray<MGImageWorksModel *> * _Nonnull))completion {
    dispatch_async(_imageWorksQueue, ^{
        [[MGImageWorksModel mj_keyValuesArrayWithObjectArray:self.imageWorks] writeToFile:[NSString lp_documentFilePathWithFileName:[NSString stringWithFormat:@"%@_%@", MG_IMAGE_WORKS_LIST_CACHE_PATH, [MGGlobalManager shareInstance].accountInfo.user_id]] atomically:YES];
        !completion ?: completion(self.imageWorks);
    });
}

- (void)downloadImageWorksModel:(MGImageWorksModel *)worksModel completion:(void (^)(MGImageWorksModel * _Nonnull))completion {
    if (!worksModel) return;
    dispatch_async(_imageWorksQueue, ^{
        NSMutableArray *needDownloadArrM = [NSMutableArray array];
        for (NSString *imageUrlStr in worksModel.generatedImageWorksList) {
            if ([worksModel.downloadedImagePathInfo objectForKey:imageUrlStr].length > 0) {
                continue;
            }
            [needDownloadArrM addObject:imageUrlStr];
        }
        if (needDownloadArrM.count > 0) {
            dispatch_group_t group = dispatch_group_create();
            for (NSString* downloadUrlStr in needDownloadArrM) {
                dispatch_group_enter(group);
                [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:downloadUrlStr] options:SDWebImageDownloaderContinueInBackground progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
                    if (finished) {
                        NSString *fileName = [downloadUrlStr MD5ForLower32Bate];
                        NSString *filePath = [self.dataFilePath stringByAppendingPathComponent:fileName];
                        [worksModel.downloadedImagePathInfo setObject:fileName forKey:downloadUrlStr];
                        [data writeToFile:filePath atomically:YES];
                        dispatch_group_leave(group);
                    }
                }];
            }
            dispatch_group_notify(group, self->_imageWorksQueue, ^{
                worksModel.isDownloaded = YES;
                [self saveImageWorksCompletion:^(NSMutableArray<MGImageWorksModel *> * _Nonnull imageWorks) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        !completion ?: completion(worksModel);
                        [[NSNotificationCenter defaultCenter] postNotificationName:MG_IMAGE_WORKS_DID_DOWNLOADED_NOTI object:nil];
                    });
                }];
            });
        } else {
            if (!worksModel.isDownloaded) {
                worksModel.isDownloaded = YES;
                [self saveImageWorksCompletion:^(NSMutableArray<MGImageWorksModel *> * _Nonnull imageWorks) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        !completion ?: completion(worksModel);
                        [[NSNotificationCenter defaultCenter] postNotificationName:MG_IMAGE_WORKS_DID_DOWNLOADED_NOTI object:nil];
                    });
                }];
            }
        }
    });
}

- (void)downloadImageWorks {
    NSMutableArray *needDownloadWorks = [NSMutableArray array];
    for (MGImageWorksModel *works in self.imageWorks) {
        if (!works.isDownloaded) {
            [needDownloadWorks addObject:works];
        }
    }
    if (needDownloadWorks.count > 0) {
        for (MGImageWorksModel *downloadWorks in needDownloadWorks) {
            [self downloadImageWorksModel:downloadWorks completion:nil];
        }
    }
}

- (void)createImageWorksSandBoxDirectory {
    NSString *documentDir = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    _dataFilePath = [documentDir stringByAppendingPathComponent:MG_IMAGE_WORKS_FILES_DIRECTORY_PATH];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir = NO;
    BOOL existed = [fileManager fileExistsAtPath:_dataFilePath isDirectory:&isDir];
    if ( !(isDir == YES && existed == YES) ) {
        [fileManager createDirectoryAtPath:_dataFilePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
}

- (NSMutableArray<MGImageWorksModel *> *)imageWorks {
    if (!_imageWorks) {
        _imageWorks = [NSMutableArray array];
    }
    return _imageWorks;
}

- (NSURL *)sseUrl {
    if (!_sseUrl) {
        NSString *domainStrig = [MGGlobalManager shareInstance].sse_url;
        NSString *userID = [MGGlobalManager shareInstance].accountInfo.user_id;
        long long currentTimeStamp = (long long)([[NSDate date] timeIntervalSince1970] * 1000);
        NSString *timeStampString = [NSString stringWithFormat:@"%lld", currentTimeStamp];
        NSString *paramString = [NSString stringWithFormat:@"time=%@&user_id=%@", timeStampString, userID];
        NSString *encryptionParamString = [LVHttpRequestHelper encryptionString:paramString keyType:CDHttpBaseUrlTypeMagina];
        NSString *encodeEncryption = [LVHttpRequestHelper URLEncodedString:encryptionParamString];
        NSString *sseUrlString = [NSString stringWithFormat:@"%@?%@&rsv_t=%@", domainStrig, paramString, encodeEncryption];
        _sseUrl = [NSURL URLWithString:sseUrlString];
    }
    return _sseUrl;
}

- (NSMutableArray<MGImageWorksModel *> *)inProductionWorksList {
    if (!_inProductionWorksList) {
        _inProductionWorksList = [NSMutableArray array];
    }
    return _inProductionWorksList;
}

@end
