//
//  NSString+LP.h
//  LongPartner
//
//  Created by mac on 2021/12/10.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (LP)


#pragma mark - file Manager
/**
 documentPath下文件路径
 */
+ (NSString *)lp_documentFilePathWithFileName:(NSString *)fileName;

/**
 Library/Caches下文件路径
 */
+ (NSString *)lp_cachesFilePathWithFileName:(NSString *)fileName;

//--------------------------------------------------------------------------------------





#pragma mark - Regex
/**
 *  符合规范的密码要求：8~16位，至少包含数字、字母、符号任意两种
 */
- (BOOL)lp_isQualifiedPasswordFormat;

/**
 *  判断是否为邮箱格式
 */
- (BOOL)lp_isAvailableEmail;
//--------------------------------------------------------------------------------------

/**
 *  判断是否为邮箱格式（判断是否带有‘@’ 跟 ‘.’）
 */
- (BOOL)apl_isAvailableEmail;

- (BOOL)isUrl;


#pragma mark - MD5
/**
 *  32位小写
 */
- (NSString *)MD5ForLower32Bate;
/**
 *  32位大写
 */
- (NSString *)MD5ForUpper32Bate;
/**
 *  16为大写
 */
- (NSString *)MD5ForUpper16Bate;
/**
 *  16位小写
 */
- (NSString *)MD5ForLower16Bate;
/**
 * 文件md5值
 */
+ (NSString *)md5OfFileAtPath:(NSString *)filePath;
//--------------------------------------------------------------------------------------


#pragma mark - other

+ (BOOL)isEmptyString:(NSString *)string;

+ (BOOL)isNullString:(NSString *)string;

@end

NS_ASSUME_NONNULL_END
