//
//  MGGetPointsFreeAlertView.m
//  Magina
//
//  Created by mac on 2025/8/15.
//

#import "MGGetPointsFreeAlertView.h"

@interface MGGetPointsFreeAlertView ()
@property (nonatomic, copy) void (^resultBlcok)(NSInteger actionType);
@end

@implementation MGGetPointsFreeAlertView

+ (instancetype)showWithResultBlock:(void (^)(NSInteger))resultBlock completion:(void (^)(BOOL))completion {
    MGGetPointsFreeAlertView *freeAlertView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([MGGetPointsFreeAlertView class]) owner:self options:nil] firstObject];
    freeAlertView.resultBlcok = resultBlock;
    [freeAlertView lv_showWithAnimateType:LVShowViewAnimateTypeAlpha dismissTapEnable:YES completion:completion];
    
    return freeAlertView;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.0];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.frame = CGRectMake((UI_SCREEN_W - 261) / 2, (UI_SCREEN_H - 351) / 2, 261, 351);
}

- (IBAction)clickComfirnBtn:(UIButton *)sender {
    [self lv_dismiss];
    !self.resultBlcok ?: self.resultBlcok(1);
}

- (IBAction)clickDismissBtn:(UIButton *)sender {
    [self lv_dismiss];
}

@end
