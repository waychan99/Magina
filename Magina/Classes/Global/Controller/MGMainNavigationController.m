//
//  MGMainNavigationController.m
//  Magina
//
//  Created by mac on 2025/8/12.
//

#import "MGMainNavigationController.h"

@interface MGMainNavigationController ()

@end

@implementation MGMainNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
   
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.viewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:animated];
}

#pragma mark - interfaceMethod
- (void)assignPopToControllerClass:(NSString *)controllerClass {
    if (controllerClass.length > 0 && self.viewControllers.count > 1) {
        NSMutableArray <UIViewController *>* tmp = self.viewControllers.mutableCopy;
        UIViewController * targetVC = nil;
        for (NSInteger i = 0 ; i < tmp.count; i++) {
            UIViewController * vc = tmp[i];
            if ([vc isKindOfClass:NSClassFromString(controllerClass)]) {
                targetVC = vc;
                break;
            }
        }
        if (targetVC) {
            NSInteger index = [tmp indexOfObject:targetVC];
            NSRange range = NSMakeRange(index + 1, tmp.count - 1 - (index + 1));
            [tmp removeObjectsInRange:range];
            self.viewControllers = [tmp copy];
        }
    }
}

@end
