//
//  MGLoginFactory.m
//  Magina
//
//  Created by mac on 2025/8/12.
//

#import "MGLoginFactory.h"

@implementation MGLoginFactory

+ (void)saveAccountInfo:(NSDictionary *)accountInfo {
    if (!accountInfo) return;
    NSData *accountInfoData = [NSJSONSerialization dataWithJSONObject:accountInfo options:NSJSONWritingPrettyPrinted error:nil];//转成NSData存储是因为字典中的value会出现nil的情况
    [[NSUserDefaults standardUserDefaults] setObject:accountInfoData forKey:MG_ACCOUNT_INFO_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)removeAccountInfo {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:MG_ACCOUNT_INFO_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSDictionary *)getAccountInfo {
    NSData *accountInfoData = [[NSUserDefaults standardUserDefaults] dataForKey:MG_ACCOUNT_INFO_KEY];
    if (accountInfoData) {
        return [NSJSONSerialization JSONObjectWithData:accountInfoData options:NSJSONReadingMutableLeaves error:nil];
    }
    return nil;
}

@end
