//
//  MGInviteFriendsController.m
//  Magina
//
//  Created by mac on 2025/8/19.
//

#import "MGInviteFriendsController.h"
#import "SPButton.h"

@interface MGInviteFriendsController ()
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLab;
@property (weak, nonatomic) IBOutlet UIView *pointsBgView;
@property (weak, nonatomic) IBOutlet UIView *invitationsBgView;
@property (weak, nonatomic) IBOutlet UILabel *pointsContentLab;
@property (weak, nonatomic) IBOutlet UILabel *pointsTitleLab;
@property (weak, nonatomic) IBOutlet UILabel *invitationsContentLab;
@property (weak, nonatomic) IBOutlet UILabel *invitationsTitleLab;
@property (weak, nonatomic) IBOutlet SPButton *cop_yBtn;
@property (nonatomic, copy) NSString *referralLink;
@end

@implementation MGInviteFriendsController

#pragma mark - lifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self setupUIComponents];
    [self requestInviteDetails];
}

#pragma mark - override
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    [self.pointsBgView lp_setImageWithRadius:LPRadiusMake(10, 30, 10, 10) image:nil borderColor:nil borderWidth:0 backgroundColor:[UIColor colorWithWhite:0.4 alpha:0.3] contentMode:0 forState:0 completion:nil];
    [self.invitationsBgView lp_setImageWithRadius:LPRadiusMake(10, 30, 10, 10) image:nil borderColor:nil borderWidth:0 backgroundColor:[UIColor colorWithWhite:0.4 alpha:0.3] contentMode:0 forState:0 completion:nil];
}

#pragma mark - setupUIComponents
- (void)setupUIComponents {
    [self.cop_yBtn setTitle:NSLocalizedString(@"Copy link", nil) forState:UIControlStateNormal];
    [self.cop_yBtn setImage:[UIImage imageNamed:@"MG_mine_copy_link_icon"] forState:UIControlStateNormal];
    [self.cop_yBtn setImage:[UIImage imageNamed:@"MG_mine_copy_link_icon"] forState:UIControlStateHighlighted];
}

#pragma mark - reqeust
- (void)requestInviteDetails {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:[MGGlobalManager shareInstance].accountInfo.user_id forKey:@"user_id"];
    [LVHttpRequest get:@"/api/v1/inviteDetail" param:params header:@{} baseUrlType:CDHttpBaseUrlTypeMagina_ljw isNeedPublickParam:YES isNeedPublickHeader:YES isNeedEncryptHeader:YES isNeedEncryptParam:YES isNeedDecryptResponse:YES encryptType:CDHttpBaseUrlTypeMagina_ljw timeout:20.0 modelClass:nil completion:^(NSInteger status, NSString * _Nonnull message, id  _Nullable result, NSError * _Nullable error, id  _Nullable responseObject) {
        if (status != 1 || error) {
            return;
        }
        self.pointsContentLab.text = [NSString stringWithFormat:@"%zd", [result[@"invite_num"] integerValue]];
        self.invitationsContentLab.text = [NSString stringWithFormat:@"%zd", [result[@"invite_count"] integerValue]];
    }];
}

#pragma mark - eventClick
- (IBAction)clickCop_yBtn:(SPButton *)sender {
    [[UIPasteboard generalPasteboard] setString:self.referralLink];
    [self.view makeToast:NSLocalizedString(@"text_has_copy", nil)];
    LVLog(@"fdasdf -- %@", self.referralLink);
}

#pragma mark - getter
- (NSString *)referralLink {
    if (!_referralLink) {
        _referralLink = [NSString stringWithFormat:@"https://user.magina.art/share/?invite_code=%@", [MGGlobalManager shareInstance].accountInfo.invite_code];
    }
    return _referralLink;
}

@end
