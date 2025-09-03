//
//  MGProductionLoading.h
//  Magina
//
//  Created by mac on 2025/9/3.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MGProductionLoading : UIView

+ (instancetype)createLoading;

- (void)show;

- (void)dismiss;

@end

NS_ASSUME_NONNULL_END
