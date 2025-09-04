//
//  MGGetPointsView.m
//  Magina
//
//  Created by mac on 2025/8/15.
//

#import "MGGetPointsView.h"

@interface MGGetPointsView ()<UITextViewDelegate>
@property (nonatomic, copy) void (^resultBlcok)(NSInteger actionType);
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UIButton *inviteBtn;
@property (weak, nonatomic) IBOutlet UITextView *agreementTextView;
@end

@implementation MGGetPointsView

+ (instancetype)showWithResultBlock:(void (^)(NSInteger))resultBlock completion:(void (^)(BOOL))completion {
    MGGetPointsView *getPointsView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([MGGetPointsView class]) owner:self options:nil] firstObject];
    getPointsView.resultBlcok = resultBlock;
    [getPointsView lv_showWithAnimateType:LVShowViewAnimateTypeFromBottom dismissTapEnable:YES completion:completion];
    
    return getPointsView;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.0];
    
    self.titleLab.text = NSLocalizedString(@"invite_titles", nil);
    [self.inviteBtn setTitle:NSLocalizedString(@"invite_friend", nil) forState:UIControlStateNormal];
    
    self.agreementTextView.delegate = self;
    self.agreementTextView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.0];
    NSMutableAttributedString *hintString = [[NSMutableAttributedString alloc]initWithString:NSLocalizedString(@"aagreement_text", nil)];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 0;
    paragraphStyle.alignment = NSTextAlignmentLeft;
    NSDictionary *hintStringAttributes = @{NSForegroundColorAttributeName : [UIColor blackColor],
                                                    NSFontAttributeName : [UIFont systemFontOfSize:11.0 weight:UIFontWeightMedium],
                                           NSParagraphStyleAttributeName : paragraphStyle};
    [hintString addAttributes:hintStringAttributes range:NSMakeRange(0, hintString.length)];
    
    NSRange range = [[hintString string] rangeOfString:NSLocalizedString(@"service_agreemen", nil)];
    NSString *valueString = [[NSString stringWithFormat:@"action://%@", NSLocalizedString(@"service_agreemen", nil)] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    [hintString addAttribute:NSLinkAttributeName value:valueString range:range];
    self.agreementTextView.attributedText = hintString;
    NSDictionary *linkAttributes = @{NSForegroundColorAttributeName : [UIColor blackColor],
                                     NSFontAttributeName : [UIFont systemFontOfSize:11.0 weight:UIFontWeightMedium],
                            NSUnderlineStyleAttributeName : @(NSUnderlineStyleSingle)};
    self.agreementTextView.linkTextAttributes = linkAttributes;
}

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

- (void)clickLinkTitle:(NSString *)title {
    !self.resultBlcok ?: self.resultBlcok(4);
}

- (IBAction)clickDismissBtn:(UIButton *)sender {
    [self lv_dismiss];
    !self.resultBlcok ?: self.resultBlcok(3);
}

- (IBAction)clickFisrBtn:(UIButton *)sender {
    [self lv_dismiss];
    !self.resultBlcok ?: self.resultBlcok(1);
}

- (IBAction)clickSecondBtn:(UIButton *)sender {
    [self lv_dismiss];
    !self.resultBlcok ?: self.resultBlcok(2);
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.frame = CGRectMake(0, UI_SCREEN_H - 267 + 59, UI_SCREEN_W, 267 - 59);
}

@end
