//
//  MGHomeListCell.h
//  Magina
//
//  Created by mac on 2025/8/13.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

static NSString * const MGHomeListCellKey = @"MGHomeListCell";

@class MGTemplateListViewModel;

@interface MGHomeListCell : UICollectionViewCell

@property (nonatomic, strong) MGTemplateListViewModel *templateListViewModel;

@end

NS_ASSUME_NONNULL_END
