//
//  LVAlertView.m
//  Enjoy
//
//  Created by mac on 2025/4/25.
//

#import "LVAlertView.h"
#import "UIView+Layout.h"
#import "LVTimer.h"

@interface LVAlertView ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet UIButton *confirmButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIView *verLineView;
@property (nonatomic, copy) void(^confirmBlock)(int index);

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *confirmWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleBottomConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *messageHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *messageBottomConstraint;
@end

@implementation LVAlertView

+ (instancetype)showAlertViewWithTitle:(NSString *)title buttonTitle:(NSString *)buttonTitle confirmBlock:(void(^)(int index))block {
    return [self showAlertViewWithTitle:title message:@"" buttonTitle:buttonTitle confirmBlock:block];
}

+ (instancetype)showAlertViewWithTitle:(NSString *)title message:(NSString *)message buttonTitle:(NSString *)buttonTitle confirmBlock:(void(^)(int index))block {
    return [self showAlertViewWithTitle:title message:message buttonTitles:@[NSLocalizedString(@"cancel", nil), buttonTitle] confirmBlock:block];
}

+ (instancetype)showAlertViewWithTitle:(NSString *)title message:(NSString *)message buttonTitles:(NSArray *)buttonTitles confirmBlock:(void(^)(int index))block {
    LVAlertView *tipView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:self options:nil] lastObject];
    [tipView initSetWithTitle:title message:message buttonTitles:buttonTitles confirmBlock:block];
    [tipView lv_showWithAnimateType:LVShowViewAnimateTypeAlpha completion:nil];
    return tipView;
}

+ (instancetype)alertViewWithTitle:(NSString *)title message:(NSString *)message buttonTitles:(NSArray *)buttonTitles confirmBlock:(void(^)(int index))block {
    LVAlertView *tipView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:self options:nil] lastObject];
    [tipView initSetWithTitle:title message:message buttonTitles:buttonTitles confirmBlock:block];
    return tipView;
}

- (void)initSetWithTitle:(NSString *)title message:(NSString *)message buttonTitles:(NSArray *)buttonTitles confirmBlock:(void(^)(int index))block {
    CGFloat leftX = 50 * UI_SCREEN_W / 375;
    self.lv_width = UI_SCREEN_W - leftX * 2;
    self.lv_x = leftX;
    self.titleLabel.text = title;
    self.messageLabel.text = message;
    if (title.length > 0) {
        self.titleHeightConstraint.constant = [self.titleLabel textRectForBounds:CGRectMake(0, 0, self.lv_width - 25 * 2, 999) limitedToNumberOfLines:0].size.height + 5;
    }else{
        self.titleHeightConstraint.constant = 0;
    }
    if (message.length > 0) {
        self.messageHeightConstraint.constant = [self.messageLabel textRectForBounds:CGRectMake(0, 0, self.lv_width - 25 * 2, 999) limitedToNumberOfLines:0].size.height + 5;
    }else{
        self.messageHeightConstraint.constant = 0;
    }
    self.lv_height = self.titleTopConstraint.constant + self.titleHeightConstraint.constant + self.titleBottomConstraint.constant + self.messageHeightConstraint.constant + self.messageBottomConstraint.constant + 45.5;
    self.lv_y = (UI_SCREEN_H - self.lv_height) * 0.5;
    if (buttonTitles.count == 2) {
        [self.confirmButton setTitle:buttonTitles[1] forState:UIControlStateNormal];
        [self.cancelButton setTitle:buttonTitles[0] forState:UIControlStateNormal];
        self.confirmWidthConstraint.constant = self.lv_width * 0.5;
    } else if (buttonTitles.count == 1) {
        [self.confirmButton setTitle:buttonTitles[0] forState:UIControlStateNormal];
        self.confirmWidthConstraint.constant = self.lv_width;
        self.verLineView.hidden = YES;
    }
    self.confirmBlock = block;
}

#pragma mark - public method
- (void)dismissWithCountdown:(int)countdown {
    if (countdown <= 0) return;
    __block int i = countdown;
    __block NSString *confirmStr = self.confirmButton.titleLabel.text;
    __weak typeof(self) weakSelf = self;
    [LVTimer execTask:^{
        if (i >= 0) {
            [weakSelf.confirmButton setTitle:[NSString stringWithFormat:@"%@(%ds)", confirmStr,i--] forState:UIControlStateNormal];
        } else {
            [weakSelf dismiss];
            if (weakSelf.confirmBlock) {
                weakSelf.confirmBlock(0);
            }
        }
    } start:0 interval:1 repeats:YES async:NO];
}

- (void)setConfirmTitle:(NSString *)title {
    [self.confirmButton setTitle:title forState:UIControlStateNormal];
}

- (void)dismiss {
    [self lv_dismiss];
}

- (IBAction)confirmAction:(UIButton *)sender {
    if (self.confirmBlock) {
        self.confirmBlock(0);
    }
    [self dismiss];
}

- (IBAction)cancleAction:(UIButton *)sender {
    if (self.confirmBlock) {
        self.confirmBlock(1);
    }
    [self dismiss];
}

@end
