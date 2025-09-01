//
//  MGReviewImageController.h
//  Magina
//
//  Created by mac on 2025/8/29.
//

#import "MGBaseController.h"

NS_ASSUME_NONNULL_BEGIN

@class MGTemplateListModel;

@interface MGReviewImageController : MGBaseController

@property (nonatomic, strong) MGImageWorksModel *worksModel;

@property (nonatomic, strong) MGTemplateListModel *templateModel;

@property (nonatomic, assign) NSInteger currentIndex;

@end

NS_ASSUME_NONNULL_END
