//
//  MGHomeListCell.h
//  Magina
//
//  Created by mac on 2025/8/13.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

static NSString * const MGHomeListCellKey = @"MGHomeListCell";

@class MGTemplateListModel;

@interface MGHomeListCell : UICollectionViewCell

@property (nonatomic, strong) MGTemplateListModel *templateListModel;

@end

NS_ASSUME_NONNULL_END
