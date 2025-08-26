//
//  MGProductionController.h
//  Magina
//
//  Created by mac on 2025/8/25.
//

#import "MGBaseController.h"

NS_ASSUME_NONNULL_BEGIN

@class MGTemplateListModel;

@interface MGProductionController : MGBaseController

@property (nonatomic, strong) MGTemplateListModel *templateModel;

@property (nonatomic, copy) NSString *tagString;

@end

NS_ASSUME_NONNULL_END
