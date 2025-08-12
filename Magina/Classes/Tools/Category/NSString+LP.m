//
//  NSString+LP.m
//  LongPartner
//
//  Created by mac on 2021/12/10.
//

#import "NSString+LP.h"
#import <CommonCrypto/CommonHMAC.h>

@implementation NSString (LP)

/**
 documentPath下文件路径
 */
+ (NSString *)lp_documentFilePathWithFileName:(NSString *)fileName{
    NSString *documentPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *filePath = [documentPath stringByAppendingPathComponent:fileName];
    return filePath;
}

/**
 Library/Caches下文件路径
 */
+ (NSString *)lp_cachesFilePathWithFileName:(NSString *)fileName {
    NSString *cachesPath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject;
    NSString *filePath = [cachesPath stringByAppendingPathComponent:fileName];
    return filePath;
}


/**
 *  符合规范的密码要求：8~16位，至少包含数字、字母、符号任意两种
 */
- (BOOL)lp_isQualifiedPasswordFormat {
    BOOL result = NO;
    if (self.length >= 8) {
        NSString *regex = @"^(?=.*[a-zA-Z0-9].*)(?=.*[a-zA-Z\\W].*)(?=.*[0-9\\W].*).{8,16}$";
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
        result = [predicate evaluateWithObject:self];
    }
    return result;
}

/**
 *  判断是否为邮箱格式
 */
- (BOOL)lp_isAvailableEmail {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:self];
}

/**
 *  判断是否为邮箱格式（判断是否带有‘@’ 跟 ‘.’）
 */
- (BOOL)apl_isAvailableEmail {
    return ([self containsString:@"@"] && [self containsString:@"."]);
}

- (BOOL)isUrl
{
    if(self == nil)
        return NO;
    
    //by liguangluo 添加对www的判断
    NSString *urlStr = nil;
    if (self.length>4 && [[self substringToIndex:4] isEqualToString:@"www."]) {
        urlStr = [NSString stringWithFormat:@"http://%@",self];
    }else{
        urlStr = self;
    }
    //end
    NSString *regex =@"[a-zA-z]+://[^\\s]*";
    NSPredicate *urlTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    BOOL isRight = [urlTest evaluateWithObject:urlStr];
    return isRight;
}


/**
 *  32位小写
 */
- (NSString *)MD5ForLower32Bate {
    //要进行UTF8的转码
    const char* input = [self UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(input, (CC_LONG)strlen(input), result);
    
    NSMutableString *digest = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for (NSInteger i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [digest appendFormat:@"%02x", result[i]];
    }
    return digest;
}

/**
 *  32位大写
 */
- (NSString *)MD5ForUpper32Bate {
    //要进行UTF8的转码
    const char* input = [self UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(input, (CC_LONG)strlen(input), result);
    
    NSMutableString *digest = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for (NSInteger i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [digest appendFormat:@"%02X", result[i]];
    }
    return digest;
}

/**
 *  16为大写
 */
- (NSString *)MD5ForUpper16Bate {
    NSString *md5Str = [self MD5ForUpper32Bate];
    NSString  *string;
    for (int i=0; i<24; i++) {
        string=[md5Str substringWithRange:NSMakeRange(8, 16)];
    }
    return string;
}

/**
 *  16位小写
 */
- (NSString *)MD5ForLower16Bate {
    NSString *md5Str = [self MD5ForLower32Bate];
    NSString  *string;
    for (int i=0; i<24; i++) {
        string=[md5Str substringWithRange:NSMakeRange(8, 16)];
    }
    return string;
}

+ (NSString *)md5OfFileAtPath:(NSString *)filePath {
    NSFileHandle *fileHandle = [NSFileHandle fileHandleForReadingAtPath:filePath];
    if (!fileHandle) return nil;
    
    CC_MD5_CTX md5Context;
    CC_MD5_Init(&md5Context);
    
    while (YES) {
        @autoreleasepool {
            NSData *chunk = [fileHandle readDataOfLength:8192]; // 8KB per chunk
            if (chunk.length == 0) break;
            CC_MD5_Update(&md5Context, chunk.bytes, (CC_LONG)chunk.length);
        }
    }
    
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5_Final(digest, &md5Context);
    [fileHandle closeFile];
    
    NSMutableString *md5String = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [md5String appendFormat:@"%02x", digest[i]]; // 转换为小写十六进制
    }
    return md5String;
}

+ (BOOL)isEmptyString:(NSString *)string {
    if (string == nil || string == NULL) {
        return YES;
    }
    
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] == 0) {
        return YES;
    }
    return NO;
}

+ (BOOL)isNullString:(NSString *)string
{
    if (string && [string isKindOfClass:[NSString class]] && [string isEqualToString:@""]) {
        return YES;
    }
    BOOL isnull = [self isEmptyString:string];
    return isnull;
}

@end
