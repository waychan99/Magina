//
//  MGTemplateCategoryModel.h
//  Magina
//
//  Created by mac on 2025/8/13.
//

#import "MGBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MGTemplateCategoryModel : MGBaseModel

@property (nonatomic, copy) NSString *category_name;

@property (nonatomic, copy) NSString *create_time;

@property (nonatomic, copy) NSString *descriptioN;

@property (nonatomic, copy) NSString *menu_order;

@property (nonatomic, copy) NSString *slug;

@property (nonatomic, copy) NSString *term_id;

@property (nonatomic, copy) NSString *update_time;

#pragma mark - help

@property (nonatomic, copy) NSString *genderType;

@end

NS_ASSUME_NONNULL_END
