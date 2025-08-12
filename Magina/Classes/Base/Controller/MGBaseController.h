//
//  MGBaseController.h
//  Magina
//
//  Created by mac on 2025/8/12.
//

#import <UIKit/UIKit.h>
#import <WRCustomNavigationBar.h>

NS_ASSUME_NONNULL_BEGIN

@interface MGBaseController : UIViewController

@property (nonatomic, strong) WRCustomNavigationBar *customNavBar;

@property (nonatomic, strong) UILabel *wrNaviBar_titleLabel;

@property (nonatomic, strong) UIButton *wrNaviBar_leftButton;

@property (nonatomic, strong) UIButton *wrNaviBar_rightButton;

@end

NS_ASSUME_NONNULL_END
