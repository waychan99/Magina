//
//  UIView+Layout.m
//  LongPartner
//
//  Created by mac on 2021/11/25.
//

#import "UIView+Layout.h"

@implementation UIView (Layout)

- (void)setLv_x:(CGFloat)lv_x {
    CGRect frame = self.frame;
    frame.origin.x = lv_x;
    self.frame = frame;
}

- (CGFloat)lv_x {
    return self.frame.origin.x;
}

- (void)setLv_y:(CGFloat)lv_y {
    CGRect frame = self.frame;
    frame.origin.y = lv_y;
    self.frame = frame;
}

- (CGFloat)lv_y {
    return self.frame.origin.y;
}

- (void)setLv_centerX:(CGFloat)lv_centerX {
    CGPoint center = self.center;
    center.x = lv_centerX;
    self.center = center;
}

- (CGFloat)lv_centerX {
    return self.center.x;
}

- (void)setLv_centerY:(CGFloat)lv_centerY {
    CGPoint center = self.center;
    center.y = lv_centerY;
    self.center = center;
}

- (CGFloat)lv_centerY {
    return self.center.y;
}

- (void)setLv_width:(CGFloat)lv_width {
    CGRect frame = self.frame;
    frame.size.width = lv_width;
    self.frame = frame;
}

- (CGFloat)lv_width {
    return self.frame.size.width;
}

- (void)setLv_height:(CGFloat)lv_height {
    CGRect frame = self.frame;
    frame.size.height = lv_height;
    self.frame = frame;
}

- (CGFloat)lv_height {
    return self.frame.size.height;
}

- (void)setLv_size:(CGSize)lv_size {
    CGRect frame = self.frame;
    frame.size = lv_size;
    self.frame = frame;
}

- (CGSize)lv_size {
    return self.frame.size;
}

- (void)setLv_origin:(CGPoint)lv_origin {
    CGRect frame = self.frame;
    frame.origin = lv_origin;
    self.frame = frame;
}

- (CGPoint)lv_origin {
    return self.frame.origin;
}

- (void)setLv_bottom:(CGFloat)lv_bottom {
    CGRect newframe = self.frame;
    newframe.origin.y = lv_bottom - self.frame.size.height;
    self.frame = newframe;
}

- (CGFloat)lv_bottom {
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setLv_right:(CGFloat)lv_right {
    CGRect newframe = self.frame;
    newframe.origin.x = lv_right - self.frame.size.width;
    self.frame = newframe;
}

- (CGFloat)lv_right {
    return self.frame.origin.x + self.frame.size.width;
}

#pragma mark - Other Origin
- (void)setLv_bottomRight:(CGPoint)lv_bottomRight {
    CGRect newframe = self.frame;
    newframe.origin.x = lv_bottomRight.x - self.lv_width;
    newframe.origin.y = lv_bottomRight.y - self.lv_height;
    self.frame = newframe;
}

- (CGPoint)lv_bottomRight {
    CGFloat x = self.frame.origin.x + self.frame.size.width;
    CGFloat y = self.frame.origin.y + self.frame.size.height;
    return CGPointMake(x, y);
}

- (void)setLv_bottomLeft:(CGPoint)lv_bottomLeft {
    CGRect newframe = self.frame;
    newframe.origin.x = lv_bottomLeft.x;
    newframe.origin.y = lv_bottomLeft.y - self.lv_height;
    self.frame = newframe;
}

- (CGPoint)lv_bottomLeft {
    CGFloat x = self.frame.origin.x;
    CGFloat y = self.frame.origin.y + self.frame.size.height;
    return CGPointMake(x, y);
}

- (void)setLv_topRight:(CGPoint)lv_topRight {
    CGRect newframe = self.frame;
    newframe.origin.x = lv_topRight.x - self.lv_width;
    newframe.origin.y = lv_topRight.y;
    self.frame = newframe;
}

- (CGPoint)lv_topRight {
    CGFloat x = self.frame.origin.x + self.frame.size.width;
    CGFloat y = self.frame.origin.y;
    return CGPointMake(x, y);
}

#pragma mark - Relative
- (void)lv_alignRight:(CGFloat)rightOffset {
    if (!self.superview) {
        return;
    }
    self.lv_right = self.superview.lv_width - rightOffset;
}

- (void)lv_alignBottom:(CGFloat)bottomOffset {
    if (!self.superview) {
        return;
    }
    self.lv_bottom = self.superview.lv_height - bottomOffset;
}

- (void)lv_alignCenter {
    if (!self.superview) {
        return;
    }
    self.lv_origin = CGPointMake((self.superview.lv_width-self.lv_width)/2, (self.superview.lv_height-self.lv_height)/2);
}

- (void)lv_alignCenterX {
    if (!self.superview) {
        return;
    }
    self.lv_x = (self.superview.lv_width-self.lv_width)/2;
}

- (void)lv_alignCenterY {
    if (!self.superview) {
        return;
    }
    self.lv_y = (self.superview.lv_height-self.lv_height)/2;
}

#pragma mark - show

static LVShowViewAnimateType _showViewAnimateType = LVShowViewAnimateTypeAlpha;

- (void)lv_showWithAnimateType:(LVShowViewAnimateType)animateType completion:(nullable void (^)(BOOL))completion {
    
    [self lv_showWithAnimateType:animateType dismissTapEnable:NO completion:completion];
}

- (void)lv_showWithAnimateType:(LVShowViewAnimateType)animateType dismissTapEnable:(BOOL)enable completion:(nullable void (^)(BOOL))completion {
    [self lv_showWithAnimateType:animateType dismissTapEnable:enable bgColor:[UIColor colorWithWhite:0 alpha:0.4] completion:completion];
}

- (void)lv_showWithAnimateType:(LVShowViewAnimateType)animateType dismissTapEnable:(BOOL)enable bgColor:(UIColor *)bgColor completion:(nullable void (^)(BOOL))completion {
    _showViewAnimateType = animateType;
    // 背景view
    UIButton *containButton = [[UIButton alloc] initWithFrame:[UIScreen mainScreen].bounds];
    containButton.backgroundColor = bgColor;
    if (enable) {
        [containButton addTarget:self action:@selector(lv_dismiss) forControlEvents:UIControlEventTouchUpInside];
    }
    [containButton addSubview:self];
    // 添加到window
    [[UIApplication sharedApplication].keyWindow addSubview:containButton];
    containButton.alpha = 0;
    [self p_originalTransform:animateType];
    [UIView animateWithDuration:0.3
                     animations:^{
                         [self p_endTransform:animateType];
                     }
                     completion:^(BOOL finished) {
                         !completion ?: completion(finished);
                     }];
}

- (void)lv_dismiss{
    [UIView animateWithDuration:0.3
                     animations:^{
                         [self p_originalTransform:_showViewAnimateType];
                     }
                     completion:^(BOOL finished) {
                         [self.superview removeFromSuperview];
                         [self removeFromSuperview];
                     }];
}

- (void)lv_dismissNoAnimation {
    [self.superview removeFromSuperview];
    [self removeFromSuperview];
}

#pragma mark - 私有方法
- (void)p_originalTransform:(LVShowViewAnimateType)animateType{
    
    self.superview.alpha = 0.0;
    
    switch (animateType) {
        case LVShowViewAnimateTypeAlpha:
            self.alpha = 0.0;
            break;
        case LVShowViewAnimateTypeFromTop:
            self.transform = CGAffineTransformMakeTranslation(0, -self.frame.size.height);
            break;
        case LVShowViewAnimateTypeFromLeft:
            self.transform = CGAffineTransformMakeTranslation(-self.frame.size.width, 0);
            break;
        case LVShowViewAnimateTypeFromBottom:
            self.transform = CGAffineTransformMakeTranslation(0, self.superview.frame.size.height);
            break;
        case LVShowViewAnimateTypeFromRight:
            self.transform = CGAffineTransformMakeTranslation(self.superview.frame.size.width, 0);
            break;
        default:
            break;
    }
}

- (void)p_endTransform:(LVShowViewAnimateType)animateType{
    
    self.superview.alpha = 1.0;
    
    switch (animateType) {
        case LVShowViewAnimateTypeAlpha:
            self.alpha = 1.0;
            break;
        default:
            self.transform = CGAffineTransformIdentity;
            break;
    }
}

- (UIViewController *)viewController {
    id nextResponder = [self nextResponder];
    while (nextResponder != nil) {
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            UIViewController *vc = (UIViewController *)nextResponder;
            return vc;
        }
        nextResponder = [nextResponder nextResponder];
    }
    return nil;
}


@end
