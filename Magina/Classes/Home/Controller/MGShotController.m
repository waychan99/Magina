//
//  MGShotController.m
//  Magina
//
//  Created by mac on 2025/8/21.
//

#import "MGShotController.h"
#import "MGPointsListController.h"
#import "SLAvCaptureTool.h"
#import "MGShotFocusView.h"
#import "SLDelayPerform.h"
#import "SLDelayPerform.h"

@interface MGShotController ()<SLAvCaptureToolDelegate>
@property (nonatomic, strong) SLAvCaptureTool *avCaptureTool;
@property (nonatomic, strong) UIImageView *captureView;
@property (nonatomic, strong) UIImageView *positionCalibration;
@property (nonatomic, strong) UIButton *switchCameraBtn;
@property (nonatomic, strong) UIButton *backBtn;
@property (nonatomic, strong) UIButton *shotBtn;
@property (nonatomic, strong) UILabel *tipsLabel;
@property (nonatomic, strong) MGShotFocusView *focusView;
@property (nonatomic, assign) CGFloat currentZoomFactor;
@end

@implementation MGShotController

#pragma mark - lifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUIComponents];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.avCaptureTool startRunning];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [_avCaptureTool stopRunning];
    [SLDelayPerform sl_cancelDelayPerform];
}

- (void)dealloc {
    _avCaptureTool.delegate = nil;
    _avCaptureTool = nil;
}

#pragma mark - override
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    CGFloat selfW = self.view.lv_width;
    CGFloat captureViewBottom = selfW * 1280 / 720;
    self.shotBtn.frame = CGRectMake((selfW - 77) / 2, captureViewBottom + 15, 77, 77);
    self.switchCameraBtn.frame = CGRectMake(CGRectGetMaxX(self.shotBtn.frame) + 60, 0, 25, 25);
    self.switchCameraBtn.lv_centerY = self.shotBtn.lv_centerY;
    self.positionCalibration.frame = CGRectMake(0, 0, selfW, captureViewBottom);
    self.backBtn.frame = CGRectMake(14, 46, 40, 40);
}

#pragma mark - setupUIComponents
- (void)setupUIComponents {
    self.view.backgroundColor = [UIColor blackColor];
    
    [self.view addSubview:self.captureView];
    [self.view addSubview:self.shotBtn];
    [self.view addSubview:self.switchCameraBtn];
    [self.view addSubview:self.positionCalibration];
    [self.view addSubview:self.backBtn];
    [self.view addSubview:self.tipsLabel];
    [self.tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).offset(58);
        make.right.mas_equalTo(self.view).offset(-58);
        make.bottom.mas_equalTo(self.shotBtn.mas_top).offset(-77);
        make.height.mas_greaterThanOrEqualTo(10);
    }];
}

#pragma mark - eventClick
- (void)tapFocusing:(UITapGestureRecognizer *)tap {
    if(!self.avCaptureTool.isRunning) {
        return;
    }
    CGPoint point = [tap locationInView:self.captureView];
    [self focusAtPoint:point];
}

- (void)focusAtPoint:(CGPoint)point {
    self.focusView.center = point;
    [self.focusView removeFromSuperview];
    [self.view addSubview:self.focusView];
    self.focusView.transform = CGAffineTransformMakeScale(1.3, 1.3);
    [UIView animateWithDuration:0.5 animations:^{
        self.focusView.transform = CGAffineTransformIdentity;
    }];
    [self.avCaptureTool focusAtPoint:point];
    _WEAK_SELF;
    [SLDelayPerform sl_startDelayPerform:^{
        [weakSelf.focusView removeFromSuperview];
    } afterDelay:1.0];
}

- (void)pinchFocalLength:(UIPinchGestureRecognizer *)pinch {
    if(pinch.state == UIGestureRecognizerStateBegan) {
        self.currentZoomFactor = self.avCaptureTool.videoZoomFactor;
    }
    if (pinch.state == UIGestureRecognizerStateChanged) {
        self.avCaptureTool.videoZoomFactor = self.currentZoomFactor * pinch.scale;
    }
}

- (void)clickShotBtn:(UIButton *)sender {
    [self.avCaptureTool outputPhoto];
}

- (void)clickSwitchCameraBtn:(UIButton *)sender {
    if (self.avCaptureTool.devicePosition == AVCaptureDevicePositionFront) {
        [self.avCaptureTool switchsCamera:AVCaptureDevicePositionBack];
    } else if(self.avCaptureTool.devicePosition == AVCaptureDevicePositionBack) {
        [self.avCaptureTool switchsCamera:AVCaptureDevicePositionFront];
    }
}

- (void)clickBackBtn:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - SLAvCaptureToolDelegate  图片、音视频输出代理
- (void)captureTool:(SLAvCaptureTool *)captureTool didOutputPhoto:(UIImage *)image error:(NSError *)error {
    [self.avCaptureTool stopRunning];
    if (image) {
        [self dismissViewControllerAnimated:YES completion:nil];
        !self.outputPhotoCallback ?: self.outputPhotoCallback(image);
    }
}

#pragma mark - getter
- (SLAvCaptureTool *)avCaptureTool {
    if (!_avCaptureTool) {
        _avCaptureTool = [[SLAvCaptureTool alloc] init];
        _avCaptureTool.preview = self.captureView;
        _avCaptureTool.delegate = self;
    }
    return _avCaptureTool;
}

- (UIImageView *)captureView {
    if (!_captureView) {
        CGFloat captureViewH = UI_SCREEN_W * 1280 / 720;
        _captureView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_W, captureViewH)];
        _captureView.contentMode = UIViewContentModeScaleAspectFit;
        _captureView.backgroundColor = [UIColor blackColor];
        _captureView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapFocusing:)];
        [_captureView addGestureRecognizer:tap];
        UIPinchGestureRecognizer  *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchFocalLength:)];
        [_captureView addGestureRecognizer:pinch];
    }
    return _captureView;
}

- (UIButton *)shotBtn {
    if (!_shotBtn) {
        _shotBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_shotBtn setImage:[UIImage imageNamed:@"MG_take_photo_icon"] forState:UIControlStateNormal];
        [_shotBtn addTarget:self action:@selector(clickShotBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _shotBtn;
}

- (UIButton *)switchCameraBtn {
    if (!_switchCameraBtn) {
        _switchCameraBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_switchCameraBtn setImage:[UIImage imageNamed:@"MG_camera_change_position_icon"] forState:UIControlStateNormal];
        [_switchCameraBtn addTarget:self action:@selector(clickSwitchCameraBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _switchCameraBtn;
}

- (UIImageView *)positionCalibration {
    if (!_positionCalibration) {
        _positionCalibration = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MG_take_photo_positionCalibration_bg"]];
        _positionCalibration.contentMode = UIViewContentModeScaleAspectFill;
        _positionCalibration.userInteractionEnabled = NO;
    }
    return _positionCalibration;
}

- (UILabel *)tipsLabel {
    if (!_tipsLabel) {
        _tipsLabel = [[UILabel alloc] init];
        _tipsLabel.textColor = [UIColor whiteColor];
        _tipsLabel.textAlignment = NSTextAlignmentCenter;
        _tipsLabel.font = [UIFont systemFontOfSize:13.0 weight:UIFontWeightMedium];
        _tipsLabel.text = NSLocalizedString(@"take_photo_tipp", nil);
        _tipsLabel.numberOfLines = 0;
    }
    return _tipsLabel;
}

- (UIButton *)backBtn {
    if (!_backBtn) {
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backBtn setImage:[UIImage imageNamed:@"MG_shot_dismiss_icon"] forState:UIControlStateNormal];
        [_backBtn addTarget:self action:@selector(clickBackBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backBtn;
}

- (MGShotFocusView *)focusView {
    if (!_focusView) {
        _focusView= [[MGShotFocusView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    }
    return _focusView;
}

@end
