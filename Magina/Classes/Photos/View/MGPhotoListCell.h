//
//  MGPhotoListCell.h
//  Magina
//
//  Created by 陈志伟 on 2025/8/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class MGFavoriteTemplateModel;

static NSString * const MGPhotoListCellKey = @"MGPhotoListCell";

@interface MGPhotoListCell : UICollectionViewCell

@property (nonatomic, strong) MGFavoriteTemplateModel *favoriteModel;

@end

NS_ASSUME_NONNULL_END
