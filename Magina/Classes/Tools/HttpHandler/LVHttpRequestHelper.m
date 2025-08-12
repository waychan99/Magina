//
//  LVHttpRequestHelper.m
//  Enjoy
//
//  Created by mac on 2025/4/25.
//

#import "LVHttpRequestHelper.h"
#import <CocoaSecurity/CocoaSecurity.h>

static NSString *const aes_key_desktop = @"long.tv_k2na39ul";
static NSString *const aes_iv_desktop  = @"long.tv_aes_iviv";

static NSString *const aes_key_DesktopUrl = @"re_er_q46_df_dfg";
static NSString *const aes_iv_DesktopUrl  = @"kk5_mm6_zz8_ee27";

static NSString *const aes_key_LongTV = @"reter4446fdfgdfg";
static NSString *const aes_iv_LongTV  = @"kkk_mmm_zzz_eee7";

static NSString *const aes_key_ads = @"ad.tv_k2na39ulcf";
static NSString *const aes_iv_ads  = @"ad.tv_ertsk_iviv";

static NSString *const k_keyData = @"k_keyData";
static NSString *const k_ivData  = @"k_ivData";

static NSString *const aes_key_newLongTV = @"re56_g46_g8fd_fg";
static NSString *const aes_iv_newLongTV  = @"k5k_m6m_z9z_e2e7";

static NSString *const aes_key_enjoy_qwy = @"enjoyg46_g8fd_fg";
static NSString *const aes_iv_enjoy_qwy  = @"enjoy6m_z9z_e2e7";

static NSString *const aes_key_enjoy_lxc_mall = @"aa333_df99_k3m4t";
static NSString *const aes_iv_enjoy_lxc_mall  = @"aa333_uu88_t3m8t";

static NSString *const aes_key_enjoy_lxc_video = @"enjoy_k2na_ul8cf";
static NSString *const aes_iv_enjoy_lxc_video  = @"enjoy_k2na_u8_iv";

static NSString *const aes_key_enjoy_lxc_shared = @"enjoy_a22a_ua8a3";
static NSString *const aes_iv_enjoy_lxc_shared  = @"enjoy_c5c5_u5c5v";

@implementation LVHttpRequestHelper

+ (NSString *)getRequestPathWithPath:(NSString *)path baseUrlType:(CDHttpBaseUrlType)baseUrlType {
    NSString *requestPath = path;
    switch (baseUrlType) {
        case CDHttpBaseUrlTypeCloundDesktop: //云桌面服务器
            requestPath  = [NSString stringWithFormat:@"%@%@",kHttpTotalService,path];
            break;
        case CDHttpBaseUrlTypeLongTVTotal: //longTV主服务器
            requestPath  = [NSString stringWithFormat:@"%@%@",kHttpTotalService,path];
            break;
        case CDHttpBaseUrlTypeLongTVSub: //子服务器
            //            requestPath  = [NSString stringWithFormat:@"%@%@",kDynamicSubService,path];
            break;
        case CDHttpBaseUrlTypeFullLink: //完整链接
            requestPath  = path;
            break;
        case CDHttpBaseUrlTypeLongTVMall: //商城的接口
            requestPath  = [NSString stringWithFormat:@"%@%@",kMallService,path];
            break;
        case  CDHttpBaseUrlTypeAppUpdate:
            requestPath  = [NSString stringWithFormat:@"%@%@",kAppUpdateService,path];
            break;
        case  CDHttpBaseUrlTypeBigMembership: //大会员
            requestPath  = [NSString stringWithFormat:@"%@%@",kBigMembershipService,path];
            break;
        case CDHttpBaseUrlTypeLongPartner:
            requestPath  = [NSString stringWithFormat:@"%@%@",kLongPartnerService,path];
            break;
        case CDHttpBaseUrlTypeNewAddedLongTV:
            requestPath  = [NSString stringWithFormat:@"%@%@",kNewAddedLongTVService,path];
            break;
        case CDHttpBaseUrlTypeCommonDomain:
            requestPath  = [NSString stringWithFormat:@"%@%@",kCommonDomainService,path];
            break;
        default:
            break;
    }
    return requestPath;
}

+ (NSMutableDictionary *)getPublicParam {
    NSMutableDictionary *publicParam = [NSMutableDictionary dictionary];
    [publicParam setValue:[self getCurrentLanguage] forKey:@"lang"];
    [publicParam setValue:[NSString stringWithFormat:@"%.0f", [[NSDate date] timeIntervalSince1970] * 1000] forKey:@"time"];
    [publicParam setValue:[MGGlobalManager shareInstance].macAddr forKey:@"mac"];
    [publicParam setValue:[MGGlobalManager shareInstance].macAddr forKey:@"log-phone-id"];
    [publicParam setValue:[MGGlobalManager shareInstance].deviceType forKey:@"log-phone-model"];
    [publicParam setValue:[MGGlobalManager shareInstance].appVersion forKey:@"log-system-version"];
    [publicParam setValue:[MGGlobalManager shareInstance].appVersion forKey:@"version"];
    [publicParam setValue:[MGGlobalManager shareInstance].deviceType forKey:@"device_type"];
    [publicParam setValue:@"ios" forKey:@"log-system-type"];
    if ([MGGlobalManager shareInstance].userLocalInfoParams) {
        publicParam = [LVHttpRequestHelper dict:publicParam byAppendingDict:[MGGlobalManager shareInstance].userLocalInfoParams];
    }
    return publicParam;
}

+ (NSMutableDictionary *)getPublicHeaderParam {
    NSMutableDictionary *publicHeader = [NSMutableDictionary dictionary];
    [publicHeader setValue:[NSString stringWithFormat:@"%.0f", [[NSDate date] timeIntervalSince1970] * 1000] forKey:@"time"];
    [publicHeader setValue:[self getCurrentLanguage] forKey:@"lang"];
    [publicHeader setValue:[MGGlobalManager shareInstance].appVersion forKey:@"version"];
    [publicHeader setValue:[MGGlobalManager shareInstance].macAddr forKey:@"mac"];
    [publicHeader setValue:@"0" forKey:@"cid"];
    [publicHeader setValue:@"ios" forKey:@"type"];
    [publicHeader setValue:@"1" forKey:@"isphone"];
    [publicHeader setValue:[MGGlobalManager shareInstance].appVersion forKey:@"logsystemversion"];
    [publicHeader setValue:[MGGlobalManager shareInstance].deviceType forKey:@"logphonemodel"];
    [publicHeader setValue:[MGGlobalManager shareInstance].macAddr forKey:@"logphoneid"];
    [publicHeader setValue:[MGGlobalManager shareInstance].deviceType forKey:@"device_type"];
    [publicHeader setValue:@"ios" forKey:@"log-system-type"];
    return publicHeader;
}

+ (NSMutableDictionary *)paramEncryption:(NSDictionary *)param keyType:(CDHttpBaseUrlType)type {
    NSString *rsvTest = [self encryptionDict:param keyType:type];
    NSMutableDictionary *resultDict = [[NSMutableDictionary alloc] init];
    [resultDict setValue:rsvTest forKey:@"rsv_t"];
    return resultDict;
}

+ (NSString *)encryptionDict:(NSDictionary *)dict keyType:(CDHttpBaseUrlType)type {
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionaryWithDictionary:dict];
    NSString *signStr = [self formatterParam:paramDict];
    NSString *rsvTest = [self encryptionString:signStr keyType:type];
    if (rsvTest == nil) {
        LVLog(@"%s encryp dict failture.!!", __func__);
    }
    return rsvTest;
}

+ (NSMutableDictionary *)headerEncryption:(NSDictionary *)header keyType:(CDHttpBaseUrlType)type {
    NSMutableDictionary *resultDict = [[NSMutableDictionary alloc] init];
    NSString *rText = [self encryptionDict:header keyType:type];
    [resultDict setValue:rText forKey:@"sign"];
    return resultDict;
}

+ (NSString *)encryptionString:(NSString *)needEncryptionStr keyType:(CDHttpBaseUrlType)type {
    if ([LVHttpRequestHelper isNullStr:needEncryptionStr]) {
        LVLog(@"%s need encrypt str is null.!!", __func__);
        return nil;
    }
    NSDictionary *dataDict = [self getAesEncryptKeyIvWithkeyType:type];
    NSData *keyData = dataDict[k_keyData];
    NSData *ivData  = dataDict[k_ivData];
    CocoaSecurityResult *aesStr = [CocoaSecurity aesEncrypt:needEncryptionStr key:keyData iv:ivData];
    NSString *rsvText = [aesStr.base64 stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    if (rsvText == nil) {
        LVLog(@"%s encryp dict failture2.!!", __func__);
    }
    return rsvText;
}

+ (NSString *)aesDecryString:(NSString *)needDecryStr keyType:(CDHttpBaseUrlType)type {
    if ([LVHttpRequestHelper isNullStr:needDecryStr]) {
        LVLog(@"%s need encrypt str is null.!!", __func__);
        return nil;
    }
    NSDictionary *dataDict = [self getAesEncryptKeyIvWithkeyType:type];
    NSData *keyData = dataDict[k_keyData];
    NSData *ivData  = dataDict[k_ivData];
    CocoaSecurityResult *aesStr = [CocoaSecurity aesDecryptWithBase64:needDecryStr key:keyData iv:ivData];
    NSString *rsvText = [aesStr.base64 stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    if (rsvText == nil) {
        LVLog(@"%s encryp dict failture2.!!", __func__);
    }
    return rsvText;
}

+ (NSString *)formatterParam:(NSDictionary *)param {
    if (param.count == 0) {
        return nil;
    }
    NSArray *allKeyArray = [param allKeys];
    NSArray *afterSortKeyArray = [allKeyArray sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        NSComparisonResult resuest = [obj1 compare:obj2];
        return resuest;
    }];
    NSMutableArray *valueArray = [NSMutableArray array];
    for (NSString *sortsing in afterSortKeyArray) {
        NSString *valueString = [param objectForKey:sortsing];
        [valueArray addObject:valueString];
    }
    NSMutableString *signString = [NSMutableString string];
    for(int i = 0; i < afterSortKeyArray.count; i++) {
        if (valueArray.count > i) {
            NSString*keyValue = [NSString stringWithFormat:@"&%@=%@",afterSortKeyArray[i],valueArray[i]];
            [signString appendString:keyValue];
        }
    }
    NSString * newSignString = signString;
    if (signString.length > 1) {
        newSignString = [signString substringWithRange:NSMakeRange(1, signString.length - 1)];//去掉首字母 &
    }
    return newSignString;
}

+ (NSDictionary *)aesDecryHttpResponseStringBy:(NSString *)encryString keyType:(CDHttpBaseUrlType)type {
    if (encryString == nil) {
        LVLog(@"AES- encryString is nil.!");
        return nil;
    }
    NSDictionary *dataDict = [self getAesEncryptKeyIvWithkeyType:type];
    NSData *keyData = dataDict[k_keyData];
    NSData *ivData  = dataDict[k_ivData];
    CocoaSecurityResult *aesStr = [CocoaSecurity aesDecryptWithBase64:encryString key:keyData iv:ivData];
    if (aesStr.data == nil) {
        //解密失败
        LVLog(@"AES- aesStr.data is nil.!");
        return nil;
    }
    
    NSError *error;
    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:aesStr.data options:NSJSONReadingMutableLeaves error:&error];
    if (jsonDict == nil) {
        NSString *jsonStr = [[NSString alloc]initWithData:aesStr.data encoding:NSUTF8StringEncoding];
        LVLog(@"AES- json convet failture.! %@",jsonStr);
        return  nil;
    }
    
    return jsonDict;
}

+ (NSString *)getCurrentLanguage {
    //印度尼西亚：in-ID 马来语：ms-MY 日语：ja-JP 韩语：ko-KR 越南语：vi-VN 德语：de-DE 法语：fr-FR
    NSArray *langArray = [[NSUserDefaults standardUserDefaults] valueForKey:@"AppleLanguages"];
    NSString *defaultLanguage = langArray.firstObject;
    if ([defaultLanguage hasPrefix:@"zh-Hans"]) {//简体中文
        return @"zh-CN";
    } else if ([defaultLanguage hasPrefix:@"zh-Han"]) {//繁体中文
        return @"zh-TW";
    } else if ([defaultLanguage hasPrefix:@"ms"]) {//马来语
        return @"ms-MY";
    } else if ([defaultLanguage hasPrefix:@"ko"]) {//韩语
        return @"ko-KR";
    } else {//否则通用英语
        return @"en-US";
    }
}

+ (NSMutableDictionary *)dict:(NSDictionary *)dict byAppendingDict:(NSDictionary *)aDict {
    NSMutableDictionary *tempDict = [NSMutableDictionary dictionaryWithDictionary:dict];
    [aDict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [tempDict setObject:obj forKey:key];
    }];
    return tempDict;
}

+ (BOOL)isNullStr:(NSString *)string {
    if (!string) {
        return YES;
    }
    if (![string isKindOfClass:[NSString class]]) {
        LVLog(@"string- no string class.!!");
        return YES;
    }
    if ([string isEqualToString:@""]) {
        return YES;
    }
    if ([string isEqualToString:@"<null>"]) {
        return YES;
    }
    return NO;
}

+ (NSDictionary *)getAesEncryptKeyIvWithkeyType:(CDHttpBaseUrlType)type {
    NSData *keyData = nil;
    NSData *ivData  = nil;
    if (type == CDHttpBaseUrlTypeCloundDesktop) {
        keyData = [aes_key_DesktopUrl dataUsingEncoding:NSUTF8StringEncoding];
        ivData  = [aes_iv_DesktopUrl dataUsingEncoding:NSUTF8StringEncoding];
    } else if (type == CDHttpBaseUrlTypeLongTVTotal ||
               type == CDHttpBaseUrlTypeLongTVSub ||
               type == CDHttpBaseUrlTypeCommonDomain ||
               type == CDHttpBaseUrlTypeBigMembership ||
               type == CDHttpBaseUrlTypeLongTVMall) {
        keyData = [aes_key_LongTV dataUsingEncoding:NSUTF8StringEncoding];
        ivData  = [aes_iv_LongTV dataUsingEncoding:NSUTF8StringEncoding];
    } else if (type == CDHttpBaseUrlTypeAppUpdate) {
        keyData = [@"8D5852ABBFB2E939" dataUsingEncoding:NSUTF8StringEncoding];
        ivData  = [@"C27A04797A8BADBA" dataUsingEncoding:NSUTF8StringEncoding];
    } else if (type == CDHttpBaseUrlTypeAds) {
        keyData = [aes_key_ads dataUsingEncoding:NSUTF8StringEncoding];
        ivData  = [aes_iv_ads dataUsingEncoding:NSUTF8StringEncoding];
    }  else if (type == CDHttpBaseUrlTypeNewAddedLongTV) {
        keyData = [aes_key_newLongTV dataUsingEncoding:NSUTF8StringEncoding];
        ivData = [aes_iv_newLongTV dataUsingEncoding:NSUTF8StringEncoding];
    } else if (type == CDHttpBaseUrlTypeEnjoy_qwy) {
        keyData = [aes_key_enjoy_qwy dataUsingEncoding:NSUTF8StringEncoding];
        ivData = [aes_iv_enjoy_qwy dataUsingEncoding:NSUTF8StringEncoding];
    } else if (type == CDHttpBaseUrlTypeEnjoy_lxc_mall) {
        keyData = [aes_key_enjoy_lxc_mall dataUsingEncoding:NSUTF8StringEncoding];
        ivData = [aes_iv_enjoy_lxc_mall dataUsingEncoding:NSUTF8StringEncoding];
    } else if (type == CDHttpBaseUrlTypeEnjoy_lxc_video) {
        keyData = [aes_key_enjoy_lxc_video dataUsingEncoding:NSUTF8StringEncoding];
        ivData = [aes_iv_enjoy_lxc_video dataUsingEncoding:NSUTF8StringEncoding];
    } else if (type == CDHttpBaseUrlTypeEnjoy_lxc_shared) {
        keyData = [aes_key_enjoy_lxc_shared dataUsingEncoding:NSUTF8StringEncoding];
        ivData = [aes_iv_enjoy_lxc_shared dataUsingEncoding:NSUTF8StringEncoding];
    } else {
        keyData = [aes_key_desktop dataUsingEncoding:NSUTF8StringEncoding];
        ivData  = [aes_iv_desktop dataUsingEncoding:NSUTF8StringEncoding];
    }
    return [[NSDictionary alloc] initWithObjectsAndKeys:keyData, k_keyData, ivData, k_ivData, nil];
}

+ (NSString *)URLEncodedString:(NSString *)str {
   // CharactersToBeEscaped = @":/?&=;+!@#$()~',*";
   // CharactersToLeaveUnescaped = @"[].";
   NSString *unencodedString = str;
   NSString *encodedString = (NSString *)
   CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                             (CFStringRef)unencodedString,
                                                             NULL,
                                                             (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                             kCFStringEncodingUTF8));
   return encodedString;
}

+ (NSString *)URLDecodedString:(NSString *)str {
   NSString *result = [str stringByReplacingOccurrencesOfString:@"+" withString:@" "];
   return [result stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

@end
