//
//  MGProductionController.m
//  Magina
//
//  Created by mac on 2025/8/25.
//

#import "MGProductionController.h"
#import "MGGeneratedListController.h"
#import "MGMainNavigationController.h"
#import "MGProductionProgress.h"
#import "MGTemplateListModel.h"
#import "MGImageWorksModel.h"
#import "UIView+GradientColors.h"
#import "LVTimer.h"

@interface MGProductionController ()
@property (weak, nonatomic) IBOutlet UIButton *memberAccelerationBtn;
@property (weak, nonatomic) IBOutlet UIButton *seeLaterBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *firstTextTopMargin;
@property (nonatomic, strong) CAGradientLayer *bgViewGradientLayer;
@property (nonatomic, strong) UIImageView *contentImageView;
@property (nonatomic, strong) UILabel *progressLab;
@property (nonatomic, strong) MGProductionProgress *progressView;
@property (nonatomic, copy) NSString *timerIdentifier;
@property (nonatomic, assign) CGFloat currentProgress;
@property (nonatomic, assign) CGFloat finalProgress;
@property (nonatomic, strong) MGImageWorksModel *generatedWorksModel;
@end

@implementation MGProductionController

#pragma mark - lifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(genertedSuccessed:) name:MG_IMAGE_WORKS_GENERATED_SUCCESSED_NOTI object:nil];
    
    [self setupUIComponents];
    [self productionImageWorks];
    
    self.finalProgress = 0.9;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    if (self.timerIdentifier.length > 0) {
        [LVTimer cancelTask:self.timerIdentifier];
    }
}

- (void)genertedSuccessed:(NSNotification *)notification {
    MGImageWorksModel *worksModel = (MGImageWorksModel *)notification.object;
    if ([worksModel.generatedTag isEqualToString:self.generatedTag]) {
        self.finalProgress = 1.0;
        self.generatedWorksModel = worksModel;
    }
}

#pragma mark - override
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    [self.view.layer insertSublayer:self.bgViewGradientLayer atIndex:0];
    
    CGFloat selfW = self.view.lv_width;
    CGFloat progressViewW = selfW - 76 * 2;
    self.progressView.frame = CGRectMake(76, 88, progressViewW, progressViewW * 361 / 203);
    self.contentImageView.frame = CGRectMake(1, 1, self.progressView.lv_width - 2, self.progressView.lv_height - 2);
    self.progressLab.frame = CGRectMake(10, (self.progressView.lv_height - 60) / 2, self.progressView.lv_width - 20, 60);
    self.firstTextTopMargin.constant = CGRectGetMaxY(self.progressView.frame) + 46;
}

#pragma mark - setupUIComponents
- (void)setupUIComponents {
    [(MGMainNavigationController *)self.navigationController assignPopToControllerClass:NSStringFromClass(self.navigationController.viewControllers.firstObject.class)];
    
    [self.view addSubview:self.progressView];
    [self.progressView addSubview:self.contentImageView];
    [self.progressView addSubview:self.progressLab];
    
    [self.contentImageView sd_setImageWithURL:[NSURL URLWithString:self.templateModel.change_face_thumbnai] placeholderImage:nil];
}

#pragma mark - eventClick
- (IBAction)clickMemberAccelerationBtn:(UIButton *)sender {
    
}

- (IBAction)clickSeeLaterBtn:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - assistMethod
- (void)productionImageWorks {
    if (self.timerIdentifier.length > 0) {
        [LVTimer cancelTask:self.timerIdentifier];
    }
    __weak typeof(self) weakSelf = self;
    self.timerIdentifier = [LVTimer execTask:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (weakSelf.currentProgress < weakSelf.finalProgress) {
                weakSelf.currentProgress += 0.01;
                weakSelf.progressLab.text = [NSString stringWithFormat:@"%.0f%%", weakSelf.currentProgress * 100];
                weakSelf.progressView.progress = weakSelf.currentProgress;
                if (weakSelf.currentProgress >= 1.0) {
                    [LVTimer cancelTask:weakSelf.timerIdentifier];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.75 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        MGGeneratedListController *vc = [[MGGeneratedListController alloc] init];
                        vc.worksModel = weakSelf.generatedWorksModel;
                        [weakSelf.navigationController pushViewController:vc animated:YES];
                    });
                }
            }
        });
    } start:0 interval:0.03 repeats:YES async:YES];
    
    [[MGImageWorksManager shareInstance] productionImageWorksWithName:nil generatedTag:self.generatedTag worksCount:self.imageWorksCount completion:^(MGImageWorksModel * _Nonnull imageWorksModel) {
        
    }];
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

- (UILabel *)progressLab {
    if (!_progressLab) {
        _progressLab = [[UILabel alloc] init];
        _progressLab.textColor = [UIColor whiteColor];
        _progressLab.font = [UIFont systemFontOfSize:41.0 weight:UIFontWeightBold];
        _progressLab.textAlignment = NSTextAlignmentCenter;
    }
    return _progressLab;
}

- (MGProductionProgress *)progressView {
    if (!_progressView) {
        _progressView = [[MGProductionProgress alloc] initWithFrame:CGRectZero];
    }
    return _progressView;
}

@end
