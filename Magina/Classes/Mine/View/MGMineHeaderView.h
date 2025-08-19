//
//  MGMineHeaderView.h
//  Magina
//
//  Created by mac on 2025/8/15.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MGMineHeaderView : UIView

@property (nonatomic, assign) CGFloat headerHeight;

@property (nonatomic, copy) void (^tapBgImageViewCallback)(UIGestureRecognizer *sender);

@end

NS_ASSUME_NONNULL_END
