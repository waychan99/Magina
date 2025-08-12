//
//  LVCommonTool.m
//  LongTV
//
//  Created by mac on 2023/1/9.
//

#import "LVCommonTool.h"
//#import "LTVGPUImageLookupFilter.h"
#import <AVFoundation/AVAsset.h>
#import <AVFoundation/AVAssetImageGenerator.h>
#import <AVFoundation/AVTime.h>

@implementation LVCommonTool

//JSON字符串转化为字典
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString
{
    if (jsonString == nil) {
        return nil;
    }
    if ([jsonString isKindOfClass:[NSDictionary class]]) {
        return (NSDictionary *)jsonString;
    }
    if (![jsonString isKindOfClass:[NSString class]]) {
        //非字典-非字符串
        NSLog(@"it is not string.!!");
        return nil;
    }
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err)
    {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

//字典转Json字符串
+(NSString *)convertToJsonData:(NSDictionary *)dict
{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString;
    if (!jsonData) {
        NSLog(@"%@",error);
    }else{
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];
    NSRange range = {0,jsonString.length};
    //去掉字符串中的空格
    [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];
    NSRange range2 = {0,mutStr.length};
    //去掉字符串中的换行符
    [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];
    return mutStr;
}

//获取顶部安全区域高度
+ (CGFloat)getSafeAreaInsetsTop { //iPhone 14 Pro(Max) 顶部安全区域高度为59, 状态栏高度为54
    CGFloat height = 0;
    if (@available(iOS 11.0, *)) {
        height = [UIApplication sharedApplication].delegate.window.safeAreaInsets.top;
    }
    if (height <= 0) {
        height = [UIApplication sharedApplication].statusBarFrame.size.height;
    }
    if (height < 20) {//好像存在小于20的情况
        NSLog(@"StatusBarHeight:%@",@(height));
        height = 20;
    }
    return height;
}

// 非字符串、null、nil或者@""都返回yes
+ (BOOL)isNullStr:(NSString *)string
{
    if (!string) {
        return YES;
    }
    if (![string isKindOfClass:[NSString class]]) {
        NSLog(@"string- no string class.!!");
        return YES;
    }
    if ([string isEqualToString:@""])
    {
        return YES;
    }
    if ([string isEqualToString:@"<null>"])
    {
        return YES;
    }
    
    return NO;
}

// 非字符串、null、nil或者@""都返回yes
+(BOOL)isEmptyStr:(NSString *)str{
    if (![str isKindOfClass:[NSString class]]) {
        NSLog(@"string- no string class.!!");
        return YES;
    }
    if ([str isEqualToString:@"<null>"]) {
        return  YES;
    }
    if (str == nil){
        return  YES;
    }
    if (str.length == 0){
        return YES;;
    }
    return  false;
}

////获取当前时间戳
+ (NSString *)currentTimeInterval
{
    NSDate* date = [NSDate dateWithTimeIntervalSinceNow:0];//获取当前时间0秒后的时间
    NSTimeInterval time=[date timeIntervalSince1970]*1000;// *1000 是精确到毫秒，不乘就是精确到秒
    //NSTimeInterval time=[date timeIntervalSince1970];// *1000 是精确到毫秒，不乘就是精确到秒
    NSString *timeString = [NSString stringWithFormat:@"%.0f", time];
    return timeString;
}

// 获取视频第一帧
+ (UIImage*)getVideoPreViewImage:(NSURL *)path
{
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:path options:nil];
    AVAssetImageGenerator *assetGen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    
    assetGen.appliesPreferredTrackTransform = YES;
    CMTime time = CMTimeMakeWithSeconds(0.0, 600);
    NSError *error = nil;
    CMTime actualTime;
    CGImageRef image = [assetGen copyCGImageAtTime:time actualTime:&actualTime error:&error];
    UIImage *videoImage = [[UIImage alloc] initWithCGImage:image];
    CGImageRelease(image);
    return videoImage;
}

+ (UIImage * _Nonnull)thumbnailFromAsset:(AVAsset * _Nonnull)asset maximumSize:(CGSize)size centerCrop:(BOOL)needCrop {
    AVAssetImageGenerator *imageGenerator = [AVAssetImageGenerator assetImageGeneratorWithAsset:asset];
    [imageGenerator setAppliesPreferredTrackTransform: YES];
    [imageGenerator setMaximumSize:size];
    
    CMTime time;
    CGImageRef result = [imageGenerator copyCGImageAtTime:kCMTimeZero actualTime:&time error:nil];
    CGSize sizeOfThumbnail = CGSizeMake(CGImageGetWidth(result), CGImageGetHeight(result));
    
    UIImage *image;
    if (needCrop) {
        CGRect cropRect;
        if (sizeOfThumbnail.width > sizeOfThumbnail.height) {
            cropRect = CGRectMake((sizeOfThumbnail.width - sizeOfThumbnail.height) * 0.5, 0, sizeOfThumbnail.height, sizeOfThumbnail.height);
        }
        else {
            cropRect = CGRectMake(0, (sizeOfThumbnail.height - sizeOfThumbnail.width) * 0.5, sizeOfThumbnail.width, sizeOfThumbnail.width);
        }
        image = [[UIImage alloc] initWithCGImage:CGImageCreateWithImageInRect(result, cropRect)];
    }
    else {
        image = [[UIImage alloc] initWithCGImage:result];
    }
    return image;
}

//+ (UIImage*)applyFilterToImageWithInputImage:(UIImage *)inputImage LookupImage:(UIImage *)lookupImage {
//    GPUImageOutput<GPUImageInput> *filter = [[LTVGPUImageLookupFilter alloc] initWithLookupImage:lookupImage];
//    return [filter imageByFilteringImage:inputImage];
//}

/// 获取视频尺寸
+ (void)getVideoSizeWithURL:(NSURL *)URL complete:(void(^)(CGSize videoSize))complete {
    
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:URL options:nil];
    
    // 获取
    // loadValuesAsynchronouslyForKeys是官方提供异步加载track的方法，防止线程阻塞
    // 加载track是耗时操作
    [asset loadValuesAsynchronouslyForKeys:@[@"tracks"] completionHandler:^{
        
        // 一般视频都有至少两个track(轨道)，根据track.mediaType判断track类型
        // AVMediaTypeVideo表示视频轨道，AVMediaTypeAudio代表音频轨道，其他类型可以查看文档。
        // 根据track的naturalSize属性即可获得视频尺寸
        NSArray *array = asset.tracks;
        CGSize videoSize = CGSizeZero;
        
        for (AVAssetTrack *track in array) {
            
            if ([track.mediaType isEqualToString:AVMediaTypeVideo]) {
                
                // 注意修正naturalSize的宽高
                videoSize = CGSizeApplyAffineTransform(track.naturalSize, track.preferredTransform);//CGSizeMake(track.naturalSize.height, track.naturalSize.width);
                break;
            }
        }
        
        if (asset.playable) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                !complete ? : complete(videoSize);
            });
        }
    }];
}

/**
 *  解析URL参数
 *
 *  @param param 想要获取参数的名字
 *  @param url   url地址
 *
 *  @return 对应参数
 */
+(NSString *)fetchUrlParam:(NSString *)param url:(NSString *)url {
    NSError *error;
    NSString *regTags=[[NSString alloc] initWithFormat:@"(^|&|\\?)+%@=+([^&]*)(&|$)",param];
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regTags
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
        // 执行匹配的过程
    NSArray *matches = [regex matchesInString:url
                                      options:0
                                        range:NSMakeRange(0, [url length])];
    for (NSTextCheckingResult *match in matches) {
        return [url substringWithRange:[match rangeAtIndex:2]];
    }
    return nil;
}

+(UIImage *)createImageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

+ (void)compressVideoWithVideoURL:(NSURL *)videoURL
                        savedName:(NSString *)savedName
                       completion:(void (^)(NSString *savedPath))completion {
    // Accessing video by URL
    AVURLAsset *videoAsset = [[AVURLAsset alloc] initWithURL:videoURL options:nil];
    
    // Find compatible presets by video asset.
    NSArray *presets = [AVAssetExportSession exportPresetsCompatibleWithAsset:videoAsset];
    
    // Begin to compress video
    // Now we just compress to low resolution if it supports
    // If you need to upload to the server, but server does't support to upload by streaming,
    // You can compress the resolution to lower. Or you can support more higher resolution.
    if ([presets containsObject:AVAssetExportPreset640x480]) {
        AVAssetExportSession *session = [[AVAssetExportSession alloc] initWithAsset:videoAsset  presetName:AVAssetExportPreset640x480];
        
        NSFileManager *mgr = [NSFileManager defaultManager];
        NSString *doc = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
        NSString *folder = [doc stringByAppendingPathComponent:@"longTV_compressedVideo_savedPath"];
        BOOL isDir = NO;
        BOOL isExist = [mgr fileExistsAtPath:folder isDirectory:&isDir];
        if (!isExist || (isExist && !isDir)) {
            NSError *error = nil;
            [mgr createDirectoryAtPath:folder
           withIntermediateDirectories:YES
                            attributes:nil
                                 error:&error];
            if (error == nil) {
                NSLog(@"目录创建成功");
            } else {
                NSLog(@"目录创建失败");
            }
        }
        
        /// 先把目录下的文件清空
        NSArray *subPaths = [mgr contentsOfDirectoryAtPath:folder error:nil];
        for (NSString *subPath in subPaths) {
            NSString *filePath = [folder stringByAppendingPathComponent:subPath];
            [mgr removeItemAtPath:filePath error:nil];
        }
        
        NSString *outPutPath = [folder stringByAppendingPathComponent:savedName];
        session.outputURL = [NSURL fileURLWithPath:outPutPath];
        
        // Optimize for network use.
        session.shouldOptimizeForNetworkUse = true;
        
        NSArray *supportedTypeArray = session.supportedFileTypes;
        if ([supportedTypeArray containsObject:AVFileTypeMPEG4]) {
            session.outputFileType = AVFileTypeMPEG4;
        } else if (supportedTypeArray.count == 0) {
            NSLog(@"No supported file types");
            return;
        } else {
            session.outputFileType = [supportedTypeArray objectAtIndex:0];
        }
        
        // Begin to export video to the output path asynchronously.
        [session exportAsynchronouslyWithCompletionHandler:^{
            if ([session status] == AVAssetExportSessionStatusCompleted) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (completion) {
                        completion([session.outputURL path]);
                    }
                });
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (completion) {
                        completion(nil);
                    }
                });
            }
        }];
    }
}

@end
