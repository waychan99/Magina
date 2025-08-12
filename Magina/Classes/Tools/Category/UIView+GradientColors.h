//
//  UIView+GradientColors.h
//  Appollen
//
//  Created by mac on 2022/10/14.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (GradientColors)

typedef NS_ENUM(NSInteger, GradientPosition){
    PositonHorizontal,//横向
    PositonVertical,//竖向
    PositionUpLeft,//左上->右下
    PositionUpRight,//右上->左下
};

/// 设置渐变颜色
/// @param colors 颜色数组 (__bridge id)UIColor.redColor.CGColor
/// @param position 渐变方向
- (CAGradientLayer *)setGradientColors:(NSArray *)colors andGradientPosition:(GradientPosition)position frame:(CGRect)frame;

@end

NS_ASSUME_NONNULL_END
