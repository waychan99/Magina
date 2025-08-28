//
//  MGImageWorksManager.m
//  Magina
//
//  Created by mac on 2025/8/27.
//

#import "MGImageWorksManager.h"
#import "NSString+LP.h"

@interface MGImageWorksManager ()
@property (nonatomic, strong) dispatch_queue_t imageWorksQueue;
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

- (void)loadImageWorksCompletion:(void (^)(NSMutableArray<MGImageWorksModel *> * _Nonnull))completion { //路劲不对，还需处理登录情况
    dispatch_async(_imageWorksQueue, ^{
        self.imageWorks = [MGImageWorksModel mj_objectArrayWithKeyValuesArray:[[NSMutableArray alloc] initWithContentsOfFile:[NSString lp_documentFilePathWithFileName:MG_IMAGE_WORKS_LIST_CACHE_PATH]]];
        !completion ?: completion(self.imageWorks);
    });
}

- (void)saveImageWorksCompletion:(void (^)(NSMutableArray<MGImageWorksModel *> * _Nonnull))completion {
    dispatch_async(_imageWorksQueue, ^{
        [[MGImageWorksModel mj_keyValuesArrayWithObjectArray:self.imageWorks] writeToFile:[NSString lp_documentFilePathWithFileName:MG_IMAGE_WORKS_LIST_CACHE_PATH] atomically:YES];
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

@end
