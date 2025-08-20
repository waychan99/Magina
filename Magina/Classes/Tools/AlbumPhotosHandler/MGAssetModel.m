//
//  MGAssetModel.m
//  Magina
//
//  Created by mac on 2025/8/20.
//

#import "MGAssetModel.h"
#import "MGImageManager.h"

@implementation MGAssetModel

+ (instancetype)modelWithAsset:(PHAsset *)asset type:(MGAssetModelMediaType)type {
    MGAssetModel *model = [[MGAssetModel alloc] init];
    model.asset = asset;
    model.type = type;
    return model;
}

@end

@implementation MGAlbumModel

- (void)setResult:(PHFetchResult *)result needFetchAssets:(BOOL)needFetchAssets {
    _result = result;
    if (needFetchAssets) {
        [[MGImageManager shareInstance] getAssetsFromFetchResult:result completion:^(NSArray<MGAssetModel *> * _Nonnull models) {
            self->_models = models;
        }];
    }
}

@end
