//
//  UIView+LPRadius.h
//  LongPartner
//
//  Created by mac on 2021/12/8.
//

#import <UIKit/UIKit.h>

struct LPRadius {
    CGFloat topLeftRadius;
    CGFloat topRightRadius;
    CGFloat bottomLeftRadius;
    CGFloat bottomRightRadius;
};
typedef struct LPRadius LPRadius;

static inline LPRadius LPRadiusMake(CGFloat topLeftRadius, CGFloat topRightRadius, CGFloat bottomLeftRadius, CGFloat bottomRightRadius) {
    LPRadius radius;
    radius.topLeftRadius = topLeftRadius;
    radius.topRightRadius = topRightRadius;
    radius.bottomLeftRadius = bottomLeftRadius;
    radius.bottomRightRadius = bottomRightRadius;
    return radius;
}

static inline NSString * _Nullable NSStringFromLPRadius(LPRadius radius) {
    return [NSString stringWithFormat:@"{%.2f, %.2f, %.2f, %.2f}", radius.topLeftRadius, radius.topRightRadius, radius.bottomLeftRadius, radius.bottomRightRadius];
}

NS_ASSUME_NONNULL_BEGIN

@interface UIView (LPRadius)

- (void)lp_setImageWithRadius:(LPRadius)radius
                        image:(UIImage * __nullable)image
                  borderColor:(UIColor * __nullable)borderColor
                  borderWidth:(CGFloat)borderWidth
              backgroundColor:(UIColor * __nullable)backgroundColor
                  contentMode:(UIViewContentMode)contentMode
                     forState:(UIControlState)state
                   completion:(void (^ __nullable)(UIImage * image))completion;

@end

NS_ASSUME_NONNULL_END
