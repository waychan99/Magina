//
//  UIView+GradientColors.m
//  Appollen
//
//  Created by mac on 2022/10/14.
//

#import "UIView+GradientColors.h"

@implementation UIView (GradientColors)


- (CAGradientLayer *)setGradientColors:(NSArray *)colors andGradientPosition:(GradientPosition)position frame:(CGRect)frame {
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.colors = colors;
    switch (position) {
        case PositonHorizontal:
            gradientLayer.startPoint = CGPointMake(0, 0);
            gradientLayer.endPoint = CGPointMake(1.0, 0);
            break;
        case PositonVertical:
            gradientLayer.startPoint = CGPointMake(0, 0);
            gradientLayer.endPoint = CGPointMake(0, 1.0);
            break;
        case PositionUpLeft:
            gradientLayer.startPoint = CGPointMake(0, 0);
            gradientLayer.endPoint = CGPointMake(1.0, 1.0);
            break;
        case PositionUpRight:
            gradientLayer.startPoint = CGPointMake(1.0, 0);
            gradientLayer.endPoint = CGPointMake(0, 1.0);
            break;
        default:
            break;
    }
    if (CGRectEqualToRect(frame, CGRectZero)) {
        gradientLayer.frame = self.bounds;
    } else {
        gradientLayer.frame = frame;
    }
    [self.layer addSublayer:gradientLayer];
    
    return gradientLayer;
}

@end
