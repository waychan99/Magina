//
//  MGHomeListController.h
//  Magina
//
//  Created by mac on 2025/8/12.
//

#import <UIKit/UIKit.h>
#import "JXCategoryListContainerView.h"

NS_ASSUME_NONNULL_BEGIN

@class MGTemplateCategoryModel;

@interface MGHomeListController : UIViewController<JXCategoryListContentViewDelegate>

@property (nonatomic, strong) MGTemplateCategoryModel *cateogryModel;

@end

NS_ASSUME_NONNULL_END
