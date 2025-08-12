//
//  UIView+LPRadius.m
//  LongPartner
//
//  Created by mac on 2021/12/8.
//

#import "UIView+LPRadius.h"
#import "UIImage+LP.h"

static NSOperationQueue *lp_operationQueue;
static char lp_operationKey;

@implementation UIView (LPRadius)

+ (void)load {
    lp_operationQueue = [[NSOperationQueue alloc] init];
}

- (NSOperation *)lp_getOperation {
    id operation = objc_getAssociatedObject(self, &lp_operationKey);
    return operation;
}

- (void)lp_setImageWithOperation:(NSOperation *)operation {
    objc_setAssociatedObject(self, &lp_operationKey, operation, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)lp_cancelOperation {
    NSOperation *operation = [self lp_getOperation];
    [operation cancel];
    [self lp_setImageWithOperation:nil];
}

- (void)lp_setImageWithRadius:(LPRadius)radius
                        image:(UIImage *)image
                  borderColor:(UIColor *)borderColor
                  borderWidth:(CGFloat)borderWidth
              backgroundColor:(UIColor *)backgroundColor
                  contentMode:(UIViewContentMode)contentMode
                     forState:(UIControlState)state
                   completion:(void (^)(UIImage * _Nonnull))completion {
    
    [self lp_cancelOperation];
    
    CGSize size_ = self.bounds.size;
    __block LPRadius radius_ = radius;
    __block UIColor *backgroundColor_ = backgroundColor;
    __block UIImage *image_ = (UIImage *)image;
    
    __weak typeof(self) weakSelf = self;
    NSBlockOperation *blockOperation = [NSBlockOperation blockOperationWithBlock:^{
        if ([[weakSelf lp_getOperation] isCancelled]) return;
        
        CGSize pixelSize = CGSizeMake(pixel(size_.width), pixel(size_.height));
        
        if (!backgroundColor_) backgroundColor_ = [UIColor whiteColor];
        
        if (image_) {
            image_ = [image_ lp_scaleToSize:pixelSize withContentMode:contentMode backgroundColor:backgroundColor_];
        } else {
            image_ = [UIImage lp_imageWithColor:backgroundColor_];
        }
        
        UIGraphicsBeginImageContextWithOptions(pixelSize, NO, UIScreen.mainScreen.scale);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGRect rect = CGRectMake(0, 0, pixelSize.width, pixelSize.height);
        CGContextScaleCTM(context, 1, -1);
        CGContextTranslateCTM(context, 0, -rect.size.height);
        CGFloat height = pixelSize.height;
        CGFloat width = pixelSize.width;
        radius_ = [weakSelf transformationLPRadius:radius_ size:pixelSize borderWidth:borderWidth];
        
        UIBezierPath *path = [[UIBezierPath alloc] init];
        [path addArcWithCenter:CGPointMake(width - radius_.topRightRadius, height - radius_.topRightRadius) radius:radius_.topRightRadius startAngle:0 endAngle:M_PI_2 clockwise:YES];
        [path addArcWithCenter:CGPointMake(radius_.topLeftRadius, height - radius_.topLeftRadius) radius:radius_.topLeftRadius startAngle:M_PI_2 endAngle:M_PI clockwise:YES];
        [path addArcWithCenter:CGPointMake(radius_.bottomLeftRadius, radius_.bottomLeftRadius) radius:radius_.bottomLeftRadius startAngle:M_PI endAngle:3.0 * M_PI_2 clockwise:YES];
        [path addArcWithCenter:CGPointMake(width - radius_.bottomRightRadius, radius_.bottomRightRadius) radius:radius_.bottomRightRadius startAngle:3.0 * M_PI_2 endAngle:2.0 * M_PI clockwise:YES];
        [path closePath];
        
        [path addClip];
        CGContextDrawImage(context, rect, image_.CGImage);
        path.lineWidth = borderWidth;
        [borderColor setStroke];
        [path stroke];
        
        UIImage *currentImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            __strong typeof(weakSelf) self = weakSelf;
            if ([[self lp_getOperation] isCancelled]) return;
            self.frame = CGRectMake(pixel(self.frame.origin.x), pixel(self.frame.origin.y), pixelSize.width, pixelSize.height);
            if ([self isKindOfClass:[UIImageView class]]) {
                ((UIImageView *)self).image = currentImage;
            } else if ([self isKindOfClass:[UIButton class]]) {
                [((UIButton *)self) setBackgroundImage:currentImage forState:state];
            } else if ([self isKindOfClass:[UILabel class]]) { //label切圆角貌似不起效果
                self.layer.backgroundColor = [UIColor colorWithPatternImage:currentImage].CGColor;
            } else {
                self.layer.contents = (__bridge id _Nullable)(currentImage.CGImage);
            }
            if (completion) completion(currentImage);
        }];
        
    }];
    
    [self lp_setImageWithOperation:blockOperation];
    [lp_operationQueue addOperation:blockOperation];
    
}

- (LPRadius)transformationLPRadius:(LPRadius)radius size:(CGSize)size borderWidth:(CGFloat)borderWidth {
    radius.topLeftRadius = minimum(size.width, size.height, radius.topLeftRadius);
    radius.topRightRadius = minimum(size.width - radius.topLeftRadius, size.height, radius.topRightRadius);
    radius.bottomLeftRadius = minimum(size.width, size.height - radius.topLeftRadius, radius.bottomLeftRadius);
    radius.bottomRightRadius = minimum(size.width - radius.bottomLeftRadius, size.height - radius.topRightRadius, radius.bottomRightRadius);
    return radius;
}

static inline CGFloat pixel(CGFloat num) {
    CGFloat unit = 1.0 / [UIScreen mainScreen].scale;
    CGFloat remain = fmod(num, unit);
    return num - remain + (remain >= unit / 2.0? unit: 0);
}

static inline CGFloat minimum(CGFloat a, CGFloat b, CGFloat c) {
    CGFloat minimum = MIN(MIN(a, b), c);
    return MAX(minimum, 0);
}

@end
