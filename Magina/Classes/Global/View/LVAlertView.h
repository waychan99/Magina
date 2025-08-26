//
//  LVAlertView.h
//  Enjoy
//
//  Created by mac on 2025/4/25.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LVAlertView : UIView

/**
 提示框

 @param title title
 @param buttonTitle buttonTitle
 @param block 回调，0确定，1取消
 */
+ (instancetype)showAlertViewWithTitle:(NSString *)title buttonTitle:(NSString *)buttonTitle confirmBlock:(void(^ __nullable)(int index))block;

+ (instancetype)showAlertViewWithTitle:(NSString *)title message:(NSString *)message buttonTitle:(NSString *)buttonTitle confirmBlock:(void(^ __nullable)(int index))block;

+ (instancetype)showAlertViewWithTitle:(NSString *)title message:(NSString *)message buttonTitles:(NSArray *)buttonTitles confirmBlock:(void(^ __nullable)(int index))block;

+ (instancetype)alertViewWithTitle:(NSString *)title message:(NSString *)message buttonTitles:(NSArray *)buttonTitles confirmBlock:(void(^ __nullable)(int index))block;

- (void)setConfirmTitle:(NSString *)title;
- (void)dismissWithCountdown:(int)countdown;
- (void)dismiss;


@end

NS_ASSUME_NONNULL_END
