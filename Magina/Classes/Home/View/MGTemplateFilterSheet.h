//
//  MGTemplateFilterSheet.h
//  Magina
//
//  Created by mac on 2025/8/13.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class MGTemplateCategoryModel;

@interface MGTemplateFilterSheet : UIView

+ (instancetype)showWithGenderIndex:(NSInteger)genderIndex categoryIndex:(NSInteger)categoryIndex categorys:(NSArray<MGTemplateCategoryModel *> *)categorys resultBlock:(void (^ __nullable)(NSInteger genderIndex, NSInteger categoryIndex))resultBlock completion:(void (^ __nullable)(BOOL finished))completion;

@end

NS_ASSUME_NONNULL_END
