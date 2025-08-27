//
//  MGImageWorksManager.m
//  Magina
//
//  Created by mac on 2025/8/27.
//

#import "MGImageWorksManager.h"
#import "NSString+LP.h"
#import "LJ_FileInfo.h"

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

- (void)loadImageWorksCompletion:(void (^)(NSMutableArray<MGImageWorksModel *> * _Nonnull))completion {
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

- (void)downloadImageWorksModel:(MGImageWorksModel *)worksModel completion:(void (^)(MGImageWorksModel * _Nonnull))completion {
    if (!worksModel) return;
    dispatch_async(_imageWorksQueue, ^{
        NSMutableArray *worksFileInfo = [LJ_FileInfo searchAllFileFromRightDirPath:self.dataFilePath];
        NSMutableArray *worksFileNames = [worksFileInfo valueForKeyPath:@"title"];
        dispatch_group_t group = dispatch_group_create();
        for (int i = 0; i < worksModel.generatedImageWorksArr.count; i++) {
            dispatch_group_enter(group);
            NSString *fileName = [NSString stringWithFormat:@"%@_%i", worksModel.generatedTag, i];
            if ([worksFileNames containsObject:fileName]) {
                dispatch_group_leave(group);
            } else {
                NSString *imageUrl = worksModel.generatedImageWorksArr[i];
                [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:imageUrl] options:SDWebImageDownloaderContinueInBackground progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
                    if (finished) {
                        NSString *filePath = [self.dataFilePath stringByAppendingPathComponent:fileName];
                        [data writeToFile:filePath atomically:YES];
                        dispatch_group_leave(group);
                    }
                }];
            }
        }
        dispatch_group_notify(group, dispatch_get_main_queue(), ^{
            worksModel.isDownloaded = YES;
            !completion ?: completion(worksModel);
        });
    });
}

- (void)downloadImageWorks {
    [self loadImageWorksCompletion:^(NSMutableArray<MGImageWorksModel *> * _Nonnull imageWorks) {
        for (MGImageWorksModel *model in imageWorks) {
            [self downloadImageWorksModel:model completion:^(MGImageWorksModel * _Nonnull imageWorksModel) {
                [self saveImageWorksCompletion:nil];
            }];
        }
    }];
}

- (NSMutableArray<MGImageWorksModel *> *)imageWorks {
    if (!_imageWorks) {
        _imageWorks = [NSMutableArray array];
    }
    return _imageWorks;
}

@end
