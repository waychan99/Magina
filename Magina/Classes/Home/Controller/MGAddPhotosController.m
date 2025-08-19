//
//  MGAddPhotosController.m
//  Magina
//
//  Created by mac on 2025/8/19.
//

#import "MGAddPhotosController.h"
#import <HWPanModal/HWPanModal.h>

@interface MGAddPhotosController ()<HWPanModalPresentable>

@end

@implementation MGAddPhotosController

#pragma mark - lifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUIComponents];
}

#pragma mark - setupUIComponents
- (void)setupUIComponents {
    self.customNavBar.hidden = YES;
    self.view.backgroundColor = HEX_COLOR(0x1E1F24);
}

#pragma mark - eventClick
- (IBAction)clickDismissBtn:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:^{}];
}

#pragma mark - HWPanModalPresentable
- (BOOL)shouldRespondToPanModalGestureRecognizer:(nonnull UIPanGestureRecognizer *)panGestureRecognizer {
    return NO;
}

- (BOOL)showDragIndicator {
    return NO;
}

- (BOOL)allowsTapBackgroundToDismiss {
    return YES;
}

- (PanModalHeight)longFormHeight {
    return PanModalHeightMake(PanModalHeightTypeMaxTopInset, 60);
}

- (CGFloat)cornerRadius {
    return 20.0f;
}

@end
