//
//  MGMineHeaderView.m
//  Magina
//
//  Created by mac on 2025/8/15.
//

#import "MGMineHeaderView.h"

@interface MGMineHeaderView ()

@end

@implementation MGMineHeaderView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.0];
}

- (CGFloat)headerHeight {
    if (_headerHeight == 0) {
        _headerHeight = ((UI_SCREEN_W - 24) * 180) / 345;
    }
    return _headerHeight;
}

@end
