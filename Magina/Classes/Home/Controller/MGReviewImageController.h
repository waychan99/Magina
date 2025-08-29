//
//  MGReviewImageController.h
//  Magina
//
//  Created by mac on 2025/8/29.
//

#import "MGBaseController.h"

NS_ASSUME_NONNULL_BEGIN

@interface MGReviewImageController : MGBaseController

@property (nonatomic, strong) MGImageWorksModel *worksModel;

@property (nonatomic, assign) NSInteger currentIndex;

@end

NS_ASSUME_NONNULL_END
