//
//  AppDelegate.m
//  Magina
//
//  Created by mac on 2025/8/12.
//

#import "AppDelegate.h"
#import "MGMainNavigationController.h"
#import "MGMainContainerController.h"

#import <AppTrackingTransparency/AppTrackingTransparency.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    MGMainContainerController *containerVC = [[MGMainContainerController alloc] init];
    MGMainNavigationController *navi = [[MGMainNavigationController alloc] initWithRootViewController:containerVC];
    self.window.rootViewController = navi;
    [self.window makeKeyAndVisible];
    
//    [[MGGlobalManager shareInstance] checkCurrentDate];
//    [[MGGlobalManager shareInstance] refreshLocalPoints];
    
    return YES;
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [[MGGlobalManager shareInstance] checkCurrentDate];
    [[MGGlobalManager shareInstance] refreshLocalPoints];
    
    [[MGGlobalManager shareInstance] requestDailyBonusPoints];
    
    if (@available(iOS 14, *)) {
        [ATTrackingManager requestTrackingAuthorizationWithCompletionHandler:^(ATTrackingManagerAuthorizationStatus status) {
            
        }];
    } else {
        
    }
}

@end
