//
//  UIView+Layout.h
//  LongPartner
//
//  Created by mac on 2021/11/25.
//
//  前缀lv是LongVision的缩写

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, LVShowViewAnimateType) {
    LVShowViewAnimateTypeAlpha,         // 透明度
    LVShowViewAnimateTypeFromTop,      // 从上面弹出
    LVShowViewAnimateTypeFromLeft,     // 从左面弹出
    LVShowViewAnimateTypeFromBottom,   // 从下面弹出
    LVShowViewAnimateTypeFromRight     // 从右面弹出
};

@interface UIView (Layout)

@property (nonatomic, assign) CGFloat lv_x;
@property (nonatomic, assign) CGFloat lv_y;
@property (nonatomic, assign) CGFloat lv_centerX;
@property (nonatomic, assign) CGFloat lv_centerY;
@property (nonatomic, assign) CGFloat lv_width;
@property (nonatomic, assign) CGFloat lv_height;
@property (nonatomic, assign) CGSize  lv_size;
@property (nonatomic, assign) CGPoint lv_origin;
@property (nonatomic, assign) CGFloat lv_bottom;
@property (nonatomic, assign) CGFloat lv_right;
@property (nonatomic, assign) CGPoint lv_bottomLeft;
@property (nonatomic, assign) CGPoint lv_bottomRight;
@property (nonatomic, assign) CGPoint lv_topRight;

// 右边距离父视图rightOffset为正值
- (void)lv_alignRight:(CGFloat)rightOffset;

// 下边距离父视图bottomOffset为正值
- (void)lv_alignBottom:(CGFloat)bottomOffset;

// 与父视图中心对齐
- (void)lv_alignCenter;

// 与父视图的中心x对齐
- (void)lv_alignCenterX;

// 与父视图的中心y对齐
- (void)lv_alignCenterY;

- (void)lv_showWithAnimateType:(LVShowViewAnimateType)animateType completion:(nullable void (^)(BOOL finished))completion;
- (void)lv_showWithAnimateType:(LVShowViewAnimateType)animateType dismissTapEnable:(BOOL)enable completion:(nullable void (^)(BOOL finished))completion;
- (void)lv_showWithAnimateType:(LVShowViewAnimateType)animateType dismissTapEnable:(BOOL)enable bgColor:(UIColor *)bgColor completion:(nullable void (^)(BOOL finished))completion;
- (void)lv_dismiss;
- (void)lv_dismissNoAnimation;


- (UIViewController *_Nullable)viewController;

@end

NS_ASSUME_NONNULL_END
