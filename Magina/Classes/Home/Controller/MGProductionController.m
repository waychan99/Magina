//
//  MGProductionController.m
//  Magina
//
//  Created by mac on 2025/8/25.
//

#import "MGProductionController.h"
#import "MGProductionProgress.h"
#import "MGTemplateListModel.h"
#import "UIView+GradientColors.h"
#import "LVTimer.h"

@interface MGProductionController ()
@property (nonatomic, strong) CAGradientLayer *bgViewGradientLayer;
@property (nonatomic, strong) UIImageView *contentImageView;
@property (nonatomic, strong) MGProductionProgress *progressView;
@property (nonatomic, copy) NSString *timerIdentifier;
@property (nonatomic, assign) CGFloat progress;
@property (weak, nonatomic) IBOutlet UIButton *memberAccelerationBtn;
@property (weak, nonatomic) IBOutlet UIButton *seeLaterBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *firstTextTopMargin;
@end

@implementation MGProductionController

#pragma mark - lifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUIComponents];
}

- (void)dealloc {
    LVLog(@"MGProductionController -- dealloc");
}

#pragma mark - override
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    [self.view.layer insertSublayer:self.bgViewGradientLayer atIndex:0];
    
    CGFloat selfW = self.view.lv_width;
    CGFloat progressViewW = selfW - 86 * 2;
    self.progressView.frame = CGRectMake(86, 88, progressViewW, progressViewW * 361 / 203);
    self.contentImageView.frame = CGRectMake(1, 1, self.progressView.lv_width - 2, self.progressView.lv_height - 2);
    self.firstTextTopMargin.constant = CGRectGetMaxY(self.progressView.frame) + 46;
}

#pragma mark - setupUIComponents
- (void)setupUIComponents {
    [self.view addSubview:self.progressView];
    [self.progressView addSubview:self.contentImageView];
    
    [self.contentImageView sd_setImageWithURL:[NSURL URLWithString:self.templateModel.change_face_thumbnai] placeholderImage:nil];
}

#pragma mark - eventClick
- (IBAction)clickMemberAccelerationBtn:(UIButton *)sender {
//    self.progressView.progress += 0.02;
    
    if (self.timerIdentifier.length > 0) [LVTimer cancelTask:self.timerIdentifier];
    __weak typeof(self) weakSelf = self;
    self.timerIdentifier = [LVTimer execTask:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.progress += 0.02;
            weakSelf.progressView.progress = weakSelf.progress;
        });
        if (weakSelf.progress >= 1) {
            [LVTimer cancelTask:weakSelf.timerIdentifier];
        }
    } start:1 interval:0.05 repeats:YES async:YES];
}

- (IBAction)clickSeeLaterBtn:(UIButton *)sender {
    
}

#pragma mark - getter
- (CAGradientLayer *)bgViewGradientLayer {
    if (!_bgViewGradientLayer) {
        _bgViewGradientLayer = [self.view setGradientColors:@[(__bridge id)HEX_COLOR(0x220A51).CGColor,(__bridge id)HEX_COLOR(0x000000).CGColor] andGradientPosition:PositonVertical frame:CGRectZero];
    }
    return _bgViewGradientLayer;
}

- (UIImageView *)contentImageView {
    if (!_contentImageView) {
        _contentImageView = [[UIImageView alloc] init];
        _contentImageView.layer.cornerRadius = 14.0f;
        _contentImageView.contentMode = UIViewContentModeScaleAspectFill;
        _contentImageView.clipsToBounds = YES;
    }
    return _contentImageView;
}

- (MGProductionProgress *)progressView {
    if (!_progressView) {
        _progressView = [[MGProductionProgress alloc] initWithFrame:CGRectZero];
    }
    return _progressView;
}

@end
