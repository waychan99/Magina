//
//  MGAssetModel.h
//  Magina
//
//  Created by mac on 2025/8/20.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    MGAssetModelMediaTypePhoto = 0,
    MGAssetModelMediaTypeLivePhoto,
    MGAssetModelMediaTypePhotoGif,
    MGAssetModelMediaTypeVideo,
    MGAssetModelMediaTypeAudio
} MGAssetModelMediaType;

@class PHAsset;

@interface MGAssetModel : NSObject

@property (nonatomic, strong) PHAsset *asset;
@property (nonatomic, assign) MGAssetModelMediaType type;

+ (instancetype)modelWithAsset:(PHAsset *)asset type:(MGAssetModelMediaType)type;

@end

@class PHFetchResult;

@interface MGAlbumModel : NSObject

@property (nonatomic, strong) NSString *name;        ///< The album name
@property (nonatomic, assign) NSInteger count;       ///< Count of photos the album contain
@property (nonatomic, strong) PHFetchResult *result;
@property (nonatomic, strong) PHAssetCollection *collection;
@property (nonatomic, strong) PHFetchOptions *options;

@property (nonatomic, strong) NSArray *models;

@property (nonatomic, assign) BOOL isCameraRoll;

- (void)setResult:(PHFetchResult *)result needFetchAssets:(BOOL)needFetchAssets;

- (void)refreshFetchResult;

@end

NS_ASSUME_NONNULL_END
