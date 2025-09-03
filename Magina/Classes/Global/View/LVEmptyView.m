//
//  LVEmptyView.m
//  Enjoy
//
//  Created by mac on 2023/1/15.
//

#import "LVEmptyView.h"

@implementation LVEmptyView

- (void)prepare {
    [super prepare];
    
    //如果想要DemoEmptyView的效果都不是自动显隐的，这里统一设置为NO，初始化时就不必再一一去写了
    self.autoShowEmptyView = NO;
    
    self.titleLabTextColor = [UIColor colorWithRed:181/255.0 green:181/255.0 blue:181/255.0 alpha:1.0];
    self.titleLabFont = [UIFont systemFontOfSize:16.0 weight:UIFontWeightBold];
    
    self.actionBtnFont = [UIFont systemFontOfSize:13.0 weight:UIFontWeightMedium];
    self.actionBtnHorizontalMargin = 10.0;
    self.actionBtnTitleColor = HEX_COLOR(0x8C919D);
    self.actionBtnBackGroundColor = [UIColor colorWithWhite:.0 alpha:.0];
    self.actionBtnWidth = UI_SCREEN_W - 10;
}

@end

