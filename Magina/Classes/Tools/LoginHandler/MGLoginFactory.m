//
//  MGLoginFactory.m
//  Magina
//
//  Created by mac on 2025/8/12.
//

#import "MGLoginFactory.h"
#import "MGAppleLogin.h"
#import "XYUUID.h"

static NSString *const kAppleLoginKey  = @"apple";
static NSString *const kUUIDLoginKey   = @"equipment";

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

+ (void)appleLoginCompletion:(void (^ __nullable)(NSDictionary *result))completion {
    [[MGAppleLogin shareInstance] mg_loginWithCompleteHandler:^(BOOL successed, NSString * _Nullable user, NSString * _Nullable familyName, NSString * _Nullable givenName, NSString * _Nullable email, NSString * _Nullable password, NSData * _Nullable identityToken, NSData * _Nullable authorizationCode, NSError * _Nullable error, NSString * _Nonnull msg) {
        if (!error) {
            [[self class] loginRequestWithCode:user fromType:kAppleLoginKey email:email userName:[NSString stringWithFormat:@"%@ %@", givenName, familyName] userAvatar:nil completion:completion];
        }
    }];
}

+ (void)uuidLoginCompletion:(void (^ __nullable)(NSDictionary *result))completion {
    [[self class] loginRequestWithCode:[XYUUID uuidForKeychain] fromType:kUUIDLoginKey email:nil userName:nil userAvatar:nil completion:completion];
}

+ (void)loginRequestWithCode:(NSString *)code fromType:(NSString *)fromType email:(NSString *)email userName:(NSString *)userName userAvatar:(NSString *)userAvatar completion:(void (^ __nullable)(NSDictionary *result))completion {
    [SVProgressHUD show];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:code forKey:@"from_code"];
    [params setValue:fromType forKey:@"from_type"];
    [params setValue:email forKey:@"third_email"];
    [params setValue:userName forKey:@"third_user_name"];
    [params setValue:userAvatar forKey:@"third_user_avatar"];
    [LVHttpRequest get:@"/magina-api/api/v1/login/index.php" param:params header:@{} baseUrlType:CDHttpBaseUrlTypeMagina isNeedPublickParam:YES isNeedPublickHeader:YES isNeedEncryptHeader:YES isNeedEncryptParam:YES isNeedDecryptResponse:YES encryptType:CDHttpBaseUrlTypeMagina timeout:20.0 modelClass:nil completion:^(NSInteger status, NSString * _Nonnull message, id  _Nullable result, NSError * _Nullable error, id  _Nullable responseObject) {
        [SVProgressHUD dismiss];
        if (status != 1 || error) {
            [[UIApplication sharedApplication].keyWindow makeToast:NSLocalizedString(@"global_request_error", nil)];
            return;
        }
        [[self class] saveAccountInfo:result];
        [MGGlobalManager shareInstance].accountInfo = [MGAccountInfo mj_objectWithKeyValues:result];
        [[NSNotificationCenter defaultCenter] postNotificationName:MG_LOGIN_SUCCESSED_NOTI object:nil];
        !completion ?: completion(result);
    }];
}

+ (void)logoutRequest {
    [SVProgressHUD show];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:[MGGlobalManager shareInstance].accountInfo.access_token forKey:@"access_token"];
    [LVHttpRequest get:@"/magina-api/api/v1/logout/index.php" param:params header:@{} baseUrlType:CDHttpBaseUrlTypeMagina isNeedPublickParam:YES isNeedPublickHeader:YES isNeedEncryptHeader:YES isNeedEncryptParam:YES isNeedDecryptResponse:YES encryptType:CDHttpBaseUrlTypeMagina timeout:20.0 modelClass:nil completion:^(NSInteger status, NSString * _Nonnull message, id  _Nullable result, NSError * _Nullable error, id  _Nullable responseObject) {
        [SVProgressHUD dismiss];
        if (status != 1 || error) {
            [[UIApplication sharedApplication].keyWindow makeToast:NSLocalizedString(@"global_request_error", nil)];
            return;
        }
        // 缓存账号信息置空
        [MGGlobalManager shareInstance].accountInfo = nil;
        // 删除本地账号信息
        [MGLoginFactory removeAccountInfo];
//        [[UIApplication sharedApplication].keyWindow makeToast:NSLocalizedString(@"logout_successfully", nil) duration:1.0 position:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:MG_LOGOUT_SUCCESSED_NOTI object:nil];
    }];
}

@end
