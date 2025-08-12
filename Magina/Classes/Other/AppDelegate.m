//
//  AppDelegate.m
//  Magina
//
//  Created by mac on 2025/8/12.
//

#import "AppDelegate.h"
#import "MGMainNavigationController.h"
#import "MGHomeController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    MGHomeController *homeVC = [[MGHomeController alloc] init];
    MGMainNavigationController *navi = [[MGMainNavigationController alloc] initWithRootViewController:homeVC];
    
    self.window.rootViewController = navi;
    [self.window makeKeyAndVisible];
    return YES;
}

@end
