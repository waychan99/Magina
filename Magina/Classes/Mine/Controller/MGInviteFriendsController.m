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
@end

@implementation MGInviteFriendsController

#pragma mark - lifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self setupUIComponents];
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
}

#pragma mark - eventClick
- (IBAction)clickCop_yBtn:(SPButton *)sender {
    
}

@end
