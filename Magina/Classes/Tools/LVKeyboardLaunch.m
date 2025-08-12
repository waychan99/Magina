//
//  LVKeyboardLaunch.m
//  Enjoy
//
//  Created by mac on 2025/4/25.
//

#import "LVKeyboardLaunch.h"
#import <IQKeyboardManager.h>

@implementation LVKeyboardLaunch

+ (void)setupKeyboardOptions {
    IQKeyboardManager *manager = IQKeyboardManager.sharedManager;
    manager.enable = YES;
    manager.shouldResignOnTouchOutside = YES;
    manager.keyboardDistanceFromTextField = 20.0f;
    manager.toolbarDoneBarButtonItemText = NSLocalizedString(@"Complete", nil);
    NSArray *ignores = @[NSClassFromString(@"EJShortsCommentsController")];
    [[manager disabledToolbarClasses] addObjectsFromArray:ignores];
    [[manager disabledDistanceHandlingClasses] addObjectsFromArray:ignores];
}

@end
