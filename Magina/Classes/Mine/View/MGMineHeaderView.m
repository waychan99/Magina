//
//  MGMineHeaderView.m
//  Magina
//
//  Created by mac on 2025/8/15.
//

#import "MGMineHeaderView.h"

@interface MGMineHeaderView ()
@property (weak, nonatomic) IBOutlet UIImageView *headerIcon;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UIView *pointsBgView;
@property (weak, nonatomic) IBOutlet UILabel *pointsLab;
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@property (weak, nonatomic) IBOutlet UIView *bgContentView;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLab;
@property (weak, nonatomic) IBOutlet UILabel *contentLab1;
@property (weak, nonatomic) IBOutlet UILabel *contentLab2;
@property (weak, nonatomic) IBOutlet UILabel *contentLab3;
@property (weak, nonatomic) IBOutlet UILabel *contentLab4;
@end

@implementation MGMineHeaderView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.0];
    self.bgContentView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.0];
    self.pointsBgView.backgroundColor = [UIColor colorWithWhite:0.7 alpha:0.1];
    
    self.bgImageView.userInteractionEnabled = YES;
    [self.bgImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBgImageView:)]];
    
    self.headerIcon.userInteractionEnabled = YES;
    [self.headerIcon addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHeaderIcon:)]];
    
    @lv_weakify(self)
    [self.KVOController observe:[MGGlobalManager shareInstance] keyPath:@"currentPoints" options:NSKeyValueObservingOptionInitial block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSString *,id> * _Nonnull change) {
        @lv_strongify(self)
        self.pointsLab.text = [NSString stringWithFormat:@"%.0f", [MGGlobalManager shareInstance].currentPoints];
    }];
}

- (void)tapBgImageView:(UIGestureRecognizer *)sender {
    !self.tapBgImageViewCallback ?: self.tapBgImageViewCallback(sender);
}

- (void)tapHeaderIcon:(UIGestureRecognizer *)sender {
    !self.tapHeaderIconCallback ?: self.tapHeaderIconCallback(sender);
}

- (CGFloat)headerHeight {
    if (_headerHeight == 0) {
        _headerHeight = CGRectGetMaxY(self.bgContentView.frame);
    }
    return _headerHeight;
}

@end
