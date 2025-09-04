//
//  MGDeleteImageWorkSheet.m
//  Magina
//
//  Created by mac on 2025/9/3.
//

#import "MGDeleteImageWorkSheet.h"

@interface MGDeleteImageWorkSheet ()
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (nonatomic, copy) void (^resultBlcok)(NSInteger actionType);
@end

@implementation MGDeleteImageWorkSheet

+ (instancetype)showWithResultBlock:(void (^)(NSInteger))resultBlock completion:(void (^)(BOOL))completion {
    MGDeleteImageWorkSheet *deleteSheet = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([MGDeleteImageWorkSheet class]) owner:self options:nil] firstObject];
    deleteSheet.resultBlcok = resultBlock;
    [deleteSheet lv_showWithAnimateType:LVShowViewAnimateTypeFromBottom dismissTapEnable:YES completion:completion];
    
    return deleteSheet;
}

- (void)awakeFromNib {
    [super awakeFromNib];

    self.backgroundColor = [UIColor colorWithWhite:.0 alpha:.0];
    self.deleteBtn.backgroundColor = [UIColor colorWithWhite:.0 alpha:.0];
    [self.deleteBtn setTitle:NSLocalizedString(@"delete_photo", nil) forState:UIControlStateNormal];
    [self.deleteBtn addTarget:self action:@selector(clickDeleteBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.cancelBtn setTitle:NSLocalizedString(@"cancel", nil) forState:UIControlStateNormal];
    [self.cancelBtn addTarget:self action:@selector(clickCancelBtn:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.frame = CGRectMake(0, UI_SCREEN_H - 158, UI_SCREEN_W, 158);
    [self lp_setImageWithRadius:LPRadiusMake(15, 15, 0, 0) image:nil borderColor:nil borderWidth:0 backgroundColor:[UIColor whiteColor] contentMode:0 forState:0 completion:nil];
}

- (void)clickDeleteBtn:(UIButton *)sender {
    [self lv_dismiss];
    !self.resultBlcok ?: self.resultBlcok(1);
}

- (void)clickCancelBtn:(UIButton *)sender {
    [self lv_dismiss];
    !self.resultBlcok ?: self.resultBlcok(0);
}

@end
