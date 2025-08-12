//
//  MGBaseController.m
//  Magina
//
//  Created by mac on 2025/8/12.
//

#import "MGBaseController.h"

@interface MGBaseController ()

@end

@implementation MGBaseController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.hidden = YES;
    
    self.view.backgroundColor = [UIColor blackColor];
    
    [self setupNavBar];
}

- (void)setupNavBar {
    [self.view addSubview:self.customNavBar];
    
    if (self.navigationController.childViewControllers.count != 1) {
        [self.customNavBar wr_setLeftButtonWithImage:[UIImage imageNamed:@"MG_navigation_back_icon"]];
    }
    
    self.wrNaviBar_titleLabel.textColor = [UIColor whiteColor];
    self.wrNaviBar_leftButton.lv_x = 10;
}

- (WRCustomNavigationBar *)customNavBar {
    if (!_customNavBar) {
        _customNavBar = [WRCustomNavigationBar CustomNavigationBar];
        [_customNavBar wr_setBackgroundAlpha:0];
        [_customNavBar wr_setBottomLineHidden:YES];
    }
    return _customNavBar;
}

- (UILabel *)wrNaviBar_titleLabel {
    if (!_wrNaviBar_titleLabel) {
        Ivar ivar = class_getInstanceVariable([WRCustomNavigationBar class], "_titleLable");
        _wrNaviBar_titleLabel = object_getIvar(self.customNavBar, ivar);
    }
    return _wrNaviBar_titleLabel;
}

- (UIButton *)wrNaviBar_leftButton {
    if (!_wrNaviBar_leftButton) {
        Ivar ivar = class_getInstanceVariable([WRCustomNavigationBar class], "_leftButton");
        _wrNaviBar_leftButton = object_getIvar(self.customNavBar, ivar);
    }
    return _wrNaviBar_leftButton;
}

- (UIButton *)wrNaviBar_rightButton {
    if (!_wrNaviBar_rightButton) {
        Ivar ivar = class_getInstanceVariable([WRCustomNavigationBar class], "_rightButton");
        _wrNaviBar_rightButton = object_getIvar(self.customNavBar, ivar);
    }
    return _wrNaviBar_rightButton;
}

@end
