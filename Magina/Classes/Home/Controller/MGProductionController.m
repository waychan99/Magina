//
//  MGProductionController.m
//  Magina
//
//  Created by mac on 2025/8/25.
//

#import "MGProductionController.h"
#import "MGGeneratedListController.h"
#import "MGProductionProgress.h"
#import "MGTemplateListModel.h"
#import "UIView+GradientColors.h"
#import "LVTimer.h"
#import "EventSource.h"

@interface MGProductionController ()
@property (weak, nonatomic) IBOutlet UIButton *memberAccelerationBtn;
@property (weak, nonatomic) IBOutlet UIButton *seeLaterBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *firstTextTopMargin;
@property (nonatomic, strong) CAGradientLayer *bgViewGradientLayer;
@property (nonatomic, strong) UIImageView *contentImageView;
@property (nonatomic, strong) MGProductionProgress *progressView;
@property (nonatomic, copy) NSString *timerIdentifier;
@property (nonatomic, assign) CGFloat progress;
@property (nonatomic, strong) EventSource *eventSource;
@end

@implementation MGProductionController

#pragma mark - lifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUIComponents];
    
    [self connectSseServices];
}

- (void)dealloc {
    LVLog(@"MGProductionController -- dealloc");
    [self.eventSource close];
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
}

- (IBAction)clickSeeLaterBtn:(UIButton *)sender {
    
}

#pragma mark - assistMethod
- (void)connectSseServices {
    if (self.timerIdentifier.length > 0) [LVTimer cancelTask:self.timerIdentifier];
    __weak typeof(self) weakSelf = self;
    self.timerIdentifier = [LVTimer execTask:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (weakSelf.progress < 0.8) {
                weakSelf.progress += 0.1;
                weakSelf.progressView.progress = weakSelf.progress;
            } else {
                [LVTimer cancelTask:weakSelf.timerIdentifier];
            }
        });
    } start:0 interval:1 repeats:YES async:YES];
    
    NSString *domainStrig = [MGGlobalManager shareInstance].sse_url;
    NSString *userID = [MGGlobalManager shareInstance].accountInfo.user_id;
    long long currentTimeStamp = (long long)([[NSDate date] timeIntervalSince1970] * 1000);
    NSString *timeStampString = [NSString stringWithFormat:@"%lld", currentTimeStamp];
    NSString *paramString = [NSString stringWithFormat:@"time=%@&user_id=%@", timeStampString, userID];
    NSString *encryptionParamString = [LVHttpRequestHelper encryptionString:paramString keyType:CDHttpBaseUrlTypeMagina];
    NSString *encodeEncryption = [LVHttpRequestHelper URLEncodedString:encryptionParamString];
    NSString *sseUrlString = [NSString stringWithFormat:@"%@?%@&rsv_t=%@", domainStrig, paramString, encodeEncryption];
    
    @lv_weakify(self)
    self.eventSource = [EventSource eventSourceWithURL:[NSURL URLWithString:sseUrlString]];
    [self.eventSource onReadyStateChanged:^(Event *event) {
        LVLog(@"onReadyStateChanged = %@ -- %i", event.data, event.readyState);
    }];
    
    // 监听消息事件
    [self.eventSource onMessage:^(Event *event) {
        LVLog(@"onMessage: %@", event.data);
        @lv_strongify(self)
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([event.data containsString:self.worksModel.generatedTag]) {
                NSDictionary *info = [event.data mj_JSONObject];
                LVLog(@"生成图片 = %@ -- %@", self.worksModel.generatedTag, info[@"image"]);
                [self.worksModel.generatedImageWorksList addObject:info[@"image"]];
            }
            if (self.worksModel.generatedImageWorksList.count == self.worksModel.generatedImageWorksCount) {
                [self.eventSource close];
                long long currentTimeStamp = (long long)([[NSDate date] timeIntervalSince1970] * 1000);
                self.worksModel.generatedTime = currentTimeStamp;
                [[MGImageWorksManager shareInstance].imageWorks insertObject:self.worksModel atIndex:0];
                [[MGImageWorksManager shareInstance] saveImageWorksCompletion:^(NSMutableArray<MGImageWorksModel *> * _Nonnull imageWorks) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        MGGeneratedListController *vc = [[MGGeneratedListController alloc] init];
                        vc.needDownload = YES;
                        vc.worksModel = self.worksModel;
                        [self.navigationController pushViewController:vc animated:YES];
                    });
                }];
            }
        });
    }];

    // 错误处理
    [self.eventSource onError:^(Event *event) {
        @lv_strongify(self)
        LVLog(@"onError -- %@ -- %i", event.data, event.readyState);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.view makeToast:NSLocalizedString(@"生成图片失败了..", nil)];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popToRootViewControllerAnimated:YES];
            });
        });
    }];
    
    [self.eventSource onOpen:^(Event *event) {
        LVLog(@"onOpen -- %@ -- %i", event.data, event.readyState);
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

- (MGProductionProgress *)progressView {
    if (!_progressView) {
        _progressView = [[MGProductionProgress alloc] initWithFrame:CGRectZero];
    }
    return _progressView;
}

@end
