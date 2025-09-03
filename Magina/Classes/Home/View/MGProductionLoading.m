//
//  MGProductionLoading.m
//  Magina
//
//  Created by mac on 2025/9/3.
//

#import "MGProductionLoading.h"

@interface MGProductionLoading ()
@property (nonatomic, strong) UIImageView *loadingImageView;
@property (nonatomic, strong) UILabel *loadingLabel;
@property (nonatomic, strong) CABasicAnimation *anima;
@end

@implementation MGProductionLoading

+ (instancetype)createLoading {
    return [[self alloc] init];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUIComponents];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.frame = CGRectMake((UI_SCREEN_W - 93) / 2, (UI_SCREEN_H - 93) / 2 - 40, 93, 93);
    self.loadingImageView.frame = CGRectMake((self.lv_width - 32) / 2, 20, 32, 32);
    self.loadingLabel.frame = CGRectMake(5, CGRectGetMaxY(self.loadingImageView.frame) + 11, self.lv_width - 10, 13);
}

- (void)setupUIComponents {
    self.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.8];
    self.layer.cornerRadius = 18.0f;
    
    [self addSubview:self.loadingImageView];
    [self addSubview:self.loadingLabel];
}

- (UIImageView *)loadingImageView {
    if (!_loadingImageView) {
        _loadingImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MG_production_loading_icon"]];
    }
    return _loadingImageView;
}

- (UILabel *)loadingLabel {
    if (!_loadingLabel) {
        _loadingLabel = [[UILabel alloc] init];
        _loadingLabel.text = NSLocalizedString(@"Uploading..", nil);
        _loadingLabel.textColor = [UIColor whiteColor];
        _loadingLabel.font = [UIFont systemFontOfSize:11.0f weight:UIFontWeightMedium];
        _loadingLabel.textAlignment = NSTextAlignmentCenter;
        _loadingLabel.adjustsFontSizeToFitWidth = YES;
    }
    return _loadingLabel;
}

- (void)show {
    [self.loadingImageView.layer addAnimation:self.anima forKey:@"rotaionAniamtion"];
    [self lv_showWithAnimateType:LVShowViewAnimateTypeAlpha dismissTapEnable:NO completion:nil];
}

- (void)dismiss {
    [self.loadingImageView.layer removeAllAnimations];
    [self lv_dismiss];
}

- (CABasicAnimation *)anima {
    if (!_anima) {
        _anima = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        _anima.fromValue = (id)0;
        _anima.toValue = @(M_PI * 2);
        _anima.duration = 1;
        _anima.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        _anima.removedOnCompletion = NO;
        _anima.repeatCount = HUGE_VALF;
    }
    return _anima;
}

@end
