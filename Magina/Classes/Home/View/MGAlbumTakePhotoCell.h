//
//  MGAlbumTakePhotoCell.h
//  Magina
//
//  Created by mac on 2025/8/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

static NSString * const MGAlbumTakePhotoCellKey = @"MGAlbumTakePhotoCell";

@class MGAssetModel;

@interface MGAlbumTakePhotoCell : UICollectionViewCell

@property (nonatomic, strong) MGAssetModel *assetModel;

@end

NS_ASSUME_NONNULL_END
