//
//  MGPointsListCell.h
//  Magina
//
//  Created by mac on 2025/8/18.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

static NSString * const MGPointsListCellKey = @"MGPointsListCell";

@class MGPointsDetailsModel;

@interface MGPointsListCell : UICollectionViewCell

@property (nonatomic, strong) MGPointsDetailsModel *pointsDetailsModel;

@end

NS_ASSUME_NONNULL_END
