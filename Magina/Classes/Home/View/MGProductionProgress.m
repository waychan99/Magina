//
//  MGProductionProgress.m
//  Magina
//
//  Created by mac on 2025/8/25.
//

#import "MGProductionProgress.h"

@interface MGProductionProgress ()<CAAnimationDelegate>
@property (nonatomic, strong) CAShapeLayer *backLayer;
@property (nonatomic, strong) CAShapeLayer *progressLayer;
@property (nonatomic, assign) CGFloat lastProgress;
@end

@implementation MGProductionProgress

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self seupUIComponents];
    }
    return self;
}

- (void)setProgress:(CGFloat)progress {
    _progress = MAX(MIN(1, progress), 0);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self startAnimation];
    });
}

- (void)startAnimation {
    [self.progressLayer addAnimation:[self pathAnimation] forKey:@"strokeEndAnimation"];
    _lastProgress = _progress;
}

- (void)seupUIComponents {
    [self.layer addSublayer:self.backLayer];
    [self.layer addSublayer:self.progressLayer];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat selfW = self.lv_width;
    CGFloat selfH = self.lv_height;
    
    self.backLayer.frame = CGRectMake(0, 0, selfW, selfH);
    self.backLayer.lineWidth = 8;
    self.backLayer.path = [self getRoundedPath].CGPath;
    
    self.progressLayer.frame = CGRectMake(0, 0, selfW, selfH);
    self.progressLayer.lineWidth = 8;
    self.progressLayer.path = [self getRoundedPath].CGPath;
}

- (UIBezierPath *)getRoundedPath {
    return [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:15.0f];
}

#pragma mark - getter
- (CAShapeLayer *)backLayer {
    if (!_backLayer) {
        _backLayer = [CAShapeLayer layer];
        _backLayer.fillColor = [UIColor clearColor].CGColor;
        _backLayer.lineWidth = 8;
        _backLayer.strokeColor = [UIColor colorWithWhite:0.4 alpha:0.4].CGColor;
        _backLayer.lineCap = @"round";
    }
    return _backLayer;
}

- (CAShapeLayer *)progressLayer {
    if (!_progressLayer) {
        _progressLayer = [CAShapeLayer layer];
        _progressLayer.fillColor = [UIColor clearColor].CGColor;
        _progressLayer.lineWidth = 8;
        _progressLayer.strokeColor = [UIColor whiteColor].CGColor;
        _progressLayer.lineCap = @"round";
    }
    return _progressLayer;
}

- (CAAnimation *)pathAnimation {
    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    pathAnimation.duration = 1.0;
    pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    pathAnimation.fromValue = [NSNumber numberWithFloat:self.lastProgress];
    pathAnimation.toValue = [NSNumber numberWithFloat:self.progress];
    pathAnimation.fillMode = kCAFillModeForwards;
    pathAnimation.removedOnCompletion = NO;
    return pathAnimation;
}

@end
