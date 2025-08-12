//
//  LVCommonTool.h
//  LongTV
//
//  Created by mac on 2023/1/9.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LVCommonTool : NSObject

//JSON字符串转化为字典
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;
//字典转Json字符串
+ (NSString *)convertToJsonData:(NSDictionary *)dict;

// 非字符串、null、nil或者@""都返回yes
+ (BOOL)isNullStr:(NSString *)string;

// 非字符串、null、nil或者@""都返回yes
+(BOOL)isEmptyStr:(NSString *)str;

//获取顶部安全区域高度
+ (CGFloat)getSafeAreaInsetsTop;

////获取当前时间戳
+ (NSString *)currentTimeInterval;

/// 获取视频第一帧
+ (UIImage*)getVideoPreViewImage:(NSURL *)path;

+ (UIImage * _Nonnull)thumbnailFromAsset:(AVAsset * _Nonnull)asset maximumSize:(CGSize)size centerCrop:(BOOL)needCrop;

//+ (UIImage*)applyFilterToImageWithInputImage:(UIImage *)inputImage LookupImage:(UIImage *)lookupImage;

+(NSString *)fetchUrlParam:(NSString *)param url:(NSString *)url;

+(UIImage *)createImageWithColor:(UIColor *)color;

/// 压缩视频
+ (void)compressVideoWithVideoURL:(NSURL *)videoURL savedName:(NSString *)savedName completion:(void (^)(NSString *savedPath))completion;

/// 获取视频尺寸
+ (void)getVideoSizeWithURL:(NSURL *)URL complete:(void(^)(CGSize videoSize))complete;

@end

NS_ASSUME_NONNULL_END
