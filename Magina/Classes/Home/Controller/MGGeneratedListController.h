//
//  MGGeneratedListController.h
//  Magina
//
//  Created by mac on 2025/8/27.
//

#import "MGBaseController.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, MGGeneratedListControllerType) {
    MGGeneratedListControllerTypeNewGenerated,
    MGGeneratedListControllerTypeViewWorks,
};

@interface MGGeneratedListController : MGBaseController

@property (nonatomic, strong) MGImageWorksModel *worksModel;

@property (nonatomic, assign) MGGeneratedListControllerType type;

@end

NS_ASSUME_NONNULL_END
