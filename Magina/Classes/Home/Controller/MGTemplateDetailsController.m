//
//  MGTemplateDetailsController.m
//  Magina
//
//  Created by mac on 2025/8/19.
//

#import "MGTemplateDetailsController.h"
#import "MGAddPhotosController.h"
#import "SPButton.h"
#import <HWPanModal/HWPanModal.h>

@interface MGTemplateDetailsController ()
@property (nonatomic, strong) UILabel *pointsLab;
@property (nonatomic, strong) UIImageView *pointsImageView;
@property (weak, nonatomic) IBOutlet UICollectionView *templateCollectionView;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UIImageView *addPhotoImageView;
@property (weak, nonatomic) IBOutlet UICollectionView *avatarCollectionView;
@property (weak, nonatomic) IBOutlet UIButton *collectBtn;
@property (weak, nonatomic) IBOutlet SPButton *photographBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *templateCollectionViewTop;
@end

@implementation MGTemplateDetailsController

#pragma mark - lifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUIComponents];
}

#pragma mark - setupUIComponents
- (void)setupUIComponents {
    self.view.backgroundColor = [UIColor blackColor];

    [self.customNavBar addSubview:self.pointsLab];
    [self.customNavBar addSubview:self.pointsImageView];
    
    [self.photographBtn setTitle:NSLocalizedString(@"10  拍同款", nil) forState:UIControlStateNormal];
    [self.photographBtn setImage:[UIImage imageNamed:@"MG_home_topbar_points_icon"] forState:UIControlStateNormal];
    
    [self.addPhotoImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAddPhotoImageView:)]];
}

#pragma mark - override
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    CGFloat selfW = self.view.lv_width;
    CGFloat pointsLabX = selfW - 20 - self.pointsLab.lv_width;
    self.pointsLab.frame = CGRectMake(pointsLabX, 0, self.pointsLab.lv_width, 17);
    self.pointsLab.lv_centerY = self.wrNaviBar_leftButton.lv_centerY;
    CGFloat pointsImageViewX = self.pointsLab.lv_x - 5 - 18;
    self.pointsImageView.frame = CGRectMake(pointsImageViewX, 0, 18, 17);
    self.pointsImageView.lv_centerY = self.wrNaviBar_leftButton.lv_centerY;
}

- (void)updateViewConstraints {
    [super updateViewConstraints];
    
    self.templateCollectionViewTop.constant = self.customNavBar.lv_height;
}

#pragma mark - eventClick
- (void)tapAddPhotoImageView:(UIGestureRecognizer *)sender {
    MGAddPhotosController *vc = [[MGAddPhotosController alloc] init];
    [self.navigationController presentPanModal:vc completion:nil];
}

#pragma mark - getter
- (UILabel *)pointsLab {
    if (!_pointsLab) {
        _pointsLab = [[UILabel alloc] init];
        _pointsLab.textColor = [UIColor whiteColor];
        _pointsLab.font = [UIFont systemFontOfSize:14.0 weight:UIFontWeightMedium];
        _pointsLab.text = @"100";
        [_pointsLab sizeToFit];
    }
    return _pointsLab;
}

- (UIImageView *)pointsImageView {
    if (!_pointsImageView) {
        _pointsImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MG_home_topbar_points_icon"]];
    }
    return _pointsImageView;
}

@end
