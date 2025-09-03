//
//  AppDelegate.m
//  Magina
//
//  Created by mac on 2025/8/12.
//

#import "AppDelegate.h"
#import "MGMainNavigationController.h"
#import "MGMainContainerController.h"
#import "LPNetwortReachability.h"

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
    
    // progressHud
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    // configSDImageCache
    [self configSDImageCache];
    // MonitorNetwork
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkStatusNoti:) name:LP_NETWORK_STATUS_NOTI object:nil];
    [LPNetwortReachability startMonitorNetwork];
    
    
    // requestUserLocalInfo
    [[MGGlobalManager shareInstance] requestUserLocalInfo];
        
    //requestFavoriteList
    [[MGGlobalManager shareInstance] requestFavoriteList];
    
    // requestSseConfig
    [[MGGlobalManager shareInstance] requestSseConfig];
    
    // loadFaceImageRecords
    if ([MGGlobalManager shareInstance].isLoggedIn) {
        [[MGGlobalManager shareInstance] faceImageRecords];
    }
    
    // downloadImageWorks
    [[MGImageWorksManager shareInstance] loadImageWorksCompletion:^(NSMutableArray<MGImageWorksModel *> * _Nonnull imageWorks) {
        [[MGImageWorksManager shareInstance] downloadImageWorks];
    }];
    
    return YES;
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    
    [[MGGlobalManager shareInstance] checkCurrentDate];
    [[MGGlobalManager shareInstance] requestDailyBonusPoints];
    [[MGGlobalManager shareInstance] checkPasteboardSharedLink];
    
    if (@available(iOS 14, *)) {
        [ATTrackingManager requestTrackingAuthorizationWithCompletionHandler:^(ATTrackingManagerAuthorizationStatus status) {
            
        }];
    } else {
        
    }
}

- (void)networkStatusNoti:(NSNotification *)notification {
    if ([notification.object intValue] != LPNetworkStatusNoReachable) {
        if (![MGGlobalManager shareInstance].isLoggedIn) {
            [MGLoginFactory uuidLoginCompletion:^(NSDictionary * _Nonnull result) {
                [[MGGlobalManager shareInstance] requestDailyBonusPoints];
                [[MGGlobalManager shareInstance] requestFavoriteList];
                [[MGGlobalManager shareInstance] faceImageRecords];
            }];
        }
    }
}

- (void)configSDImageCache {
    SDImageCacheConfig *cacheConfig = [SDImageCache sharedImageCache].config;
//    cacheConfig.shouldCacheImagesInMemory = NO;
    cacheConfig.maxMemoryCost = 400 * 1024 * 1024; // 限制内存缓存为 400MB
    cacheConfig.maxMemoryCount = 40; // 限制缓存图片数量为 40
}

@end
