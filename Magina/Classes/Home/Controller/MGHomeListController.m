//
//  MGHomeListController.m
//  Magina
//
//  Created by mac on 2025/8/12.
//

#import "MGHomeListController.h"

@interface MGHomeListController ()

@end

@implementation MGHomeListController

#pragma mark - lifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [self randomColor];
}

- (UIColor *)randomColor {
    CGFloat red = (CGFloat)arc4random_uniform(256) / 255.0;
    CGFloat green = (CGFloat)arc4random_uniform(256) / 255.0;
    CGFloat blue = (CGFloat)arc4random_uniform(256) / 255.0;
    return [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
}

#pragma mark - JXPagerViewListViewDelegate
- (UIView *)listView {
    return self.view;
}

@end
