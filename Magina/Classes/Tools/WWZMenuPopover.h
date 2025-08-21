//
//  WWZMenuPopover.h
//  SmartOrange
//
//  Created by Orange on 2018/12/13.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WWZMenuPopover;

@protocol WWZMenuPopoverDelegate <NSObject>

@optional

- (void)menuPopover:(WWZMenuPopover *)menuPopover didSelectedItemAtIndex:(NSUInteger)index;

@end


@interface WWZMenuPopover : UIView

@property (nonatomic, weak) id<WWZMenuPopoverDelegate> menuDelegate;


/**
 *  锚点, default is 右上角barItem
 */
@property (nonatomic, assign) CGPoint anchorPoint;

/**
 *  小三角在tableView上的frame, default is {{viewWidth-18-cornerRadius*2, 0}, {18, 10}}
 */
@property (nonatomic, assign) CGRect pointerFrame;

/**
 *  cell 高度， default is 45.0
 */
@property (nonatomic, assign) CGFloat cellHeight;

/**
 *  tableView圆角半径， default is 5.0
 */
@property (nonatomic, assign) CGFloat cornerRadius;

/**
 *  文本字体大小, default is 14
 */
@property (nonatomic, strong) UIFont *titleFont;
/**
 *  文本颜色, default is black
 */
@property (nonatomic, strong) UIColor *titleColor;
    
/**
 *  anchorColor， default is white
 */
@property (nonatomic, strong) UIColor *anchorColor;
    
/**
 *  背景色， default is white
 */
@property (nonatomic, strong) UIColor *backColor;

/**
 *  cell selected backgroundColor， default is (217, 217, 217,0)
 */
@property (nonatomic, strong) UIColor *selectedBackColor;

/**
 *  line color , default is (0, 0, 0, 0.2)
 */
@property (nonatomic, strong) UIColor *lineColor;


/**
 *  WWZMenuPopover
 *
 *  @param viewWidth   视图宽度
 *  @param titles      titles
 *  @param imageNames  imageNames
 *
 *  @return WWZMenuPopover
 */
+ (instancetype)wwz_menuPopoverWithViewWidth:(CGFloat)viewWidth
                                      titles:(NSArray *)titles
                                  imageNames:(NSArray *)imageNames;
/**
 *  WWZMenuPopover
 *
 *  @param viewWidth   视图宽度
 *  @param titles      titles
 *  @param imageNames  imageNames
 *
 *  @return WWZMenuPopover
 */
- (instancetype)initWithViewWidth:(CGFloat)viewWidth
                           titles:(NSArray *)titles
                       imageNames:(NSArray *)imageNames;

/**
 *  显示
 */
- (void)wwz_show;

/**
 *  隐藏
 */
- (void)wwz_hide;

@end
