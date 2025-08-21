//
//  MGShotFocusView.m
//  Magina
//
//  Created by mac on 2025/8/21.
//

#import "MGShotFocusView.h"

@interface MGShotFocusView ()

@property (nonatomic, strong) UIBezierPath *borderPath;

@end

@implementation MGShotFocusView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.borderPath = [UIBezierPath bezierPath];
        self.userInteractionEnabled = YES;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (instancetype)init{
    if (self = [super init]) {
        self.borderPath = [UIBezierPath bezierPath];
        self.userInteractionEnabled = YES;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    self.borderPath = [UIBezierPath bezierPathWithRect:self.bounds];
    self.borderPath.lineCapStyle = kCGLineCapButt;//线条拐角
    self.borderPath.lineWidth = 2.0;
    UIColor *color = [UIColor whiteColor];
    [color set];// 设置边框线条颜色
    
    //起点
    [self.borderPath moveToPoint:CGPointMake(rect.size.width/2.0, 0)];
    //连线 上
    [self.borderPath addLineToPoint:CGPointMake(rect.size.width/2.0, 0+8)];
    [self.borderPath moveToPoint:CGPointMake(0, rect.size.width/2.0)];
    //连线 左
    [self.borderPath addLineToPoint:CGPointMake(0+8, rect.size.width/2.0)];
    [self.borderPath moveToPoint:CGPointMake(rect.size.width/2.0, rect.size.height)];
    //连线 下
    [self.borderPath addLineToPoint:CGPointMake(rect.size.width/2.0, rect.size.height - 8)];
    [self.borderPath moveToPoint:CGPointMake(rect.size.width, rect.size.height/2.0)];
    //连线 右
    [self.borderPath addLineToPoint:CGPointMake(rect.size.width - 8, rect.size.height/2.0)];
    
    [self.borderPath stroke];
}

@end
