//
//  UIImage+LP.h
//  LongPartner
//
//  Created by mac on 2021/12/8.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (LP)

+ (UIImage *)lp_imageWithColor:(UIColor *)color;

- (UIImage *)lp_scaleToSize:(CGSize)size withContentMode:(UIViewContentMode)contentMode backgroundColor:(UIColor *)backgroundColor;

- (CGRect)lp_convertRect:(CGRect)rect withContentMode:(UIViewContentMode)contentMode;

- (UIImage *)lp_scaleToSize:(CGSize)size;

/** 生成二维码图片 */
+ (instancetype)lp_imageWithQRCode:(NSString *)qrcode size:(CGSize)size;

/** 压缩图片 */
- (UIImage *)lp_compressedImageToMaxFileSize:(NSInteger)maxFileSize;

/** 压缩图片 */
- (NSData *)lp_compressedDataToMaxFileSize:(NSInteger)maxFileSize;

/** 通过图片Data数据第一个字节 来获取图片扩展名 */
+ (NSString *)lp_contentTypeForImageData:(NSData *)data;

@end

NS_ASSUME_NONNULL_END
