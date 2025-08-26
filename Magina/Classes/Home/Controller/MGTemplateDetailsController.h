//
//  MGTemplateDetailsController.h
//  Magina
//
//  Created by mac on 2025/8/19.
//

#import "MGBaseController.h"

NS_ASSUME_NONNULL_BEGIN

@class MGTemplateListModel;

@interface MGTemplateDetailsController : MGBaseController

@property (nonatomic, strong) NSArray<MGTemplateListModel *> *templateModels;

@property (nonatomic, assign) NSInteger currentTemplateIndex;

@end

NS_ASSUME_NONNULL_END
