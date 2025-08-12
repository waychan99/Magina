//
//  UIhelpTools.m
//  Appollen
//
//  Created by mac on 2022/7/28.
//

#import "UIhelpTools.h"

@implementation UIhelpTools

+ (CGFloat)getStatusBarHight {
    float statusBarHeight = 0;
    if (@available(iOS 13.0, *)) {
//        UIStatusBarManager *statusBarManager = [UIApplication sharedApplication].windows.firstObject.windowScene.statusBarManager;
        UIStatusBarManager *statusBarManager = ((UIWindowScene *)([UIApplication sharedApplication].connectedScenes.allObjects[0])).statusBarManager;
        statusBarHeight = statusBarManager.statusBarFrame.size.height;
    } else {
        statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
    }
    return statusBarHeight;
}

@end
