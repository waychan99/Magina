//
//  MGMineHeaderView.m
//  Magina
//
//  Created by mac on 2025/8/15.
//

#import "MGMineHeaderView.h"

@interface MGMineHeaderView ()
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;

@end

@implementation MGMineHeaderView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.0];
    
    self.bgImageView.userInteractionEnabled = YES;
    [self.bgImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBgImageView:)]];
}

- (void)tapBgImageView:(UIGestureRecognizer *)sender {
    !self.tapBgImageViewCallback ?: self.tapBgImageViewCallback(sender);
}

- (CGFloat)headerHeight {
    if (_headerHeight == 0) {
        _headerHeight = ((UI_SCREEN_W - 24) * 180) / 345;
    }
    return _headerHeight;
}

@end
