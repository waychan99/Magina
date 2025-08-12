//
//  NSLayoutConstraint+BSIBDesignable.m
//  LongPartner
//
//  Created by mac on 2021/11/25.
//

#import "NSLayoutConstraint+BSIBDesignable.h"

// 基准屏幕宽度
#define kRefereWidth 375.0
#define kRefereHeight 812.0

// 以屏幕宽度为固定比例关系，来计算对应的值。假设：基准屏幕宽度375，floatV=10；当前屏幕宽度为750时，那么返回的值为20
#define AdaptW(floatValue) (floatValue*[[UIScreen mainScreen] bounds].size.width/kRefereWidth)
#define AdaptH(floatValue) (floatValue*[[UIScreen mainScreen] bounds].size.height/kRefereHeight)

@implementation NSLayoutConstraint (BSIBDesignable)

//定义常量 必须是C语言字符串
static char *AdapterScreenKey = "AdapterScreenKey";
static char *AdapterVerticalConstraintKey = "AdapterVerticalConstraintKey";

- (BOOL)adapterScreen {
    NSNumber *number = objc_getAssociatedObject(self, AdapterScreenKey);
    return number.boolValue;
}

- (void)setAdapterScreen:(BOOL)adapterScreen {
    NSNumber *number = @(adapterScreen);
    objc_setAssociatedObject(self, AdapterScreenKey, number, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    if (adapterScreen){
        self.constant = AdaptW(self.constant);
    }
}

- (BOOL)adapterVerticalConstraint {
    NSNumber *number = objc_getAssociatedObject(self, AdapterVerticalConstraintKey);
    return number.boolValue;
}

- (void)setAdapterVerticalConstraint:(BOOL)adapterVerticalConstraint {
    NSNumber *number = @(adapterVerticalConstraint);
    objc_setAssociatedObject(self, AdapterVerticalConstraintKey, number, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    if (adapterVerticalConstraint){
        self.constant = AdaptH(self.constant);
    }
}

@end
