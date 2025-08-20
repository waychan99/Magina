//
//  MGAlbumPhotoListCell.h
//  Magina
//
//  Created by mac on 2025/8/20.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

static NSString * const MGAlbumPhotoListCellKey = @"MGAlbumPhotoListCell";

@class MGAssetModel;

@interface MGAlbumPhotoListCell : UICollectionViewCell

@property (nonatomic, strong) MGAssetModel *assetModel;

@property (nonatomic, copy) NSString *representedAssetIdentifier;

@property (nonatomic, assign) int32_t imageRequestID;

@end

NS_ASSUME_NONNULL_END
