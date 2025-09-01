//
//  MGDelAccountController.m
//  Magina
//
//  Created by mac on 2025/9/1.
//

#import "MGDelAccountController.h"
#import "MGPrivacyPolicyController.h"
#import "UIView+GradientColors.h"

@interface MGDelAccountController ()<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *contentLab;
@property (weak, nonatomic) IBOutlet UITextView *agreementTextView;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;
@property (weak, nonatomic) IBOutlet UIButton *agreementBtn;
@property (nonatomic, strong) CAGradientLayer *bg_gradientLayer;
@end

@implementation MGDelAccountController

#pragma mark - lifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUIComponents];
}

#pragma mark - override
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    self.bg_gradientLayer.frame = self.view.bounds;
    [self.view.layer insertSublayer:self.bg_gradientLayer atIndex:0];
    
    self.agreementTextView.backgroundColor = [UIColor colorWithWhite:.0 alpha:.0];
}

#pragma mark - setupUIComponents
- (void)setupUIComponents  {
//    [self.wrNaviBar_leftButton setImage:[UIImage imageNamed:@"nav_icon_return"] forState:UIControlStateNormal];
    self.view.backgroundColor = [UIColor whiteColor];
    self.titleLab.text = NSLocalizedString(@"LP_delAcc_deletionTitle", nil);
    self.contentLab.text = NSLocalizedString(@"LP_delAcc_deletionDescription", nil);
    
    NSMutableAttributedString *hintString = [[NSMutableAttributedString alloc]initWithString:NSLocalizedString(@"LP_delAcc_deletionNotice", nil)];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:6];
    [paragraphStyle setAlignment:NSTextAlignmentLeft];
    NSDictionary *hintStringAttributes = @{NSForegroundColorAttributeName : HEX_COLOR(0x808489),
                                                    NSFontAttributeName : [UIFont systemFontOfSize:12.0 weight:UIFontWeightMedium],
                                          NSParagraphStyleAttributeName : paragraphStyle};
    [hintString addAttributes:hintStringAttributes range:NSMakeRange(0, hintString.length)];
    
    NSRange range = [[hintString string] rangeOfString:NSLocalizedString(@"LP_delAcc_deletionNotice", nil)];
    NSString *valueString = [[NSString stringWithFormat:@"action://%@", NSLocalizedString(@"LP_delAcc_deletionNotice", nil)] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    [hintString addAttribute:NSLinkAttributeName value:valueString range:range];
    self.agreementTextView.attributedText = hintString;
    NSDictionary *linkAttributes = @{NSForegroundColorAttributeName : HEX_COLOR(0xFA6B1B),
                                 NSFontAttributeName : [UIFont systemFontOfSize:12.0 weight:UIFontWeightMedium],
                                 NSUnderlineStyleAttributeName : @(NSUnderlineStyleSingle)};
    self.agreementTextView.linkTextAttributes = linkAttributes;
    
    [self.nextBtn setTitle:NSLocalizedString(@"confirm", nil) forState:UIControlStateNormal];
}

#pragma mark - eventClick
- (IBAction)clickAgreementBtn:(UIButton *)sender {
    sender.selected = !sender.isSelected;
}

- (IBAction)clickNextBtn:(UIButton *)sender {
    if (!self.agreementBtn.isSelected) {
        [self.view makeToast:NSLocalizedString(@"LP_delAcc_deletionAgreementTips", nil)];
        return;
    }
    [LVAlertView showAlertViewWithTitle:NSLocalizedString(@"LP_delAcc_confirmDeletion", nil) buttonTitle:NSLocalizedString(@"confirm", nil) confirmBlock:^(int index) {
        if (index == 0) {
            [self deleteAccountRequest];
        }
    }];
}

#pragma mark - request
- (void)deleteAccountRequest {

//        [self.view makeToast:NSLocalizedString(@"LP_delAcc_successfullyDeletedContent", nil) duration:2.75 position:CSToastPositionCenter];
//        [[NSNotificationCenter defaultCenter] postNotificationName:EJ_LOGOUT_SUCCESSED_NOTI object:nil];
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [self.navigationController popToRootViewControllerAnimated:YES];
//        });
}


#pragma mark - UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange interaction:(UITextItemInteraction)interaction {
    if ([[URL scheme] isEqualToString:@"action"]) {
        NSString *titleString = [NSString stringWithFormat:@"%@", URL.host];
        [self clickLinkTitle:titleString];
        return NO;
    }
    return YES;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    return NO;
}

#pragma mark - assistMethod
- (void)clickLinkTitle:(NSString *)title {
    MGPrivacyPolicyController *vc = [[MGPrivacyPolicyController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - getter
- (CAGradientLayer *)bg_gradientLayer {
    if (!_bg_gradientLayer) {
        _bg_gradientLayer = [self.view setGradientColors:@[(__bridge id)HEX_COLOR(0xFFFFFF).CGColor,(__bridge id)HEX_COLOR(0x220A51).CGColor] andGradientPosition:PositonVertical frame:CGRectZero];
    }
    return _bg_gradientLayer;
}

@end
