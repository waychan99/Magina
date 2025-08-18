//
//  MGGetPointsFreeAlertView.h
//  Magina
//
//  Created by mac on 2025/8/15.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MGGetPointsFreeAlertView : UIView

+ (instancetype)showWithResultBlock:(void (^ __nullable)(NSInteger actionType))resultBlock completion:(void (^ __nullable)(BOOL finished))completion;

@end

NS_ASSUME_NONNULL_END
