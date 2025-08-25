//
//  MGImageManager.h
//  Magina
//
//  Created by mac on 2025/8/20.
//

#import <Foundation/Foundation.h>
#import "MGAssetModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MGImageManager : NSObject

+ (instancetype)shareInstance;

/// Default is 600px / 默认600像素宽
@property (nonatomic, assign) CGFloat photoPreviewMaxWidth;
/// The pixel width of output image, Default is 828px / 导出图片的宽度，默认828像素宽
@property (nonatomic, assign) CGFloat photoWidth;

@property (nonatomic, assign) BOOL shouldFixOrientation;

/// Get Album 获得相册/相册数组
- (void)getCameraRollAlbumWithFetchAssets:(BOOL)needFetchAssets completion:(void (^)(MGAlbumModel *model))completion;
- (void)getAllAlbumsWithFetchAssets:(BOOL)needFetchAssets completion:(void (^)(NSArray<MGAlbumModel *> *models))completion;

/// Get Assets 获得Asset数组
- (void)getAssetsFromFetchResult:(PHFetchResult *)result completion:(void (^)(NSArray<MGAssetModel *> *models))completion;

/// Get photo 获得照片
- (PHImageRequestID)getPhotoWithAsset:(PHAsset *)asset completion:(void (^)(UIImage *photo,NSDictionary *info,BOOL isDegraded))completion;
- (PHImageRequestID)getPhotoWithAsset:(PHAsset *)asset photoWidth:(CGFloat)photoWidth completion:(void (^)(UIImage *photo,NSDictionary *info,BOOL isDegraded))completion;
- (PHImageRequestID)getPhotoWithAsset:(PHAsset *)asset completion:(void (^)(UIImage *photo,NSDictionary *info,BOOL isDegraded))completion progressHandler:(void (^)(double progress, NSError *error, BOOL *stop, NSDictionary *info))progressHandler networkAccessAllowed:(BOOL)networkAccessAllowed;
- (PHImageRequestID)getPhotoWithAsset:(PHAsset *)asset photoWidth:(CGFloat)photoWidth completion:(void (^)(UIImage *photo,NSDictionary *info,BOOL isDegraded))completion progressHandler:(void (^)(double progress, NSError *error, BOOL *stop, NSDictionary *info))progressHandler networkAccessAllowed:(BOOL)networkAccessAllowed;

/// Get postImage  获取封面图
- (PHImageRequestID)getPostImageWithAlbumModel:(MGAlbumModel *)model completion:(void (^)(UIImage *postImage))completion;

@end

NS_ASSUME_NONNULL_END
