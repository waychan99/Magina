//
//  MGFaceRecognition.m
//  Magina
//
//  Created by 陈志伟 on 2025/8/24.
//

#import "MGFaceRecognition.h"
#import <Vision/Vision.h>

@interface MGFaceRecognition ()
@property (nonatomic, copy) void (^resultBlcok)(NSMutableArray<UIImage *> *images);
@end

@implementation MGFaceRecognition

static MGFaceRecognition *_instance;

+ (id)allocWithZone:(struct _NSZone *)zone{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    return _instance;
}

+ (instancetype)shareInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}

- (id)copyWithZone:(NSZone *)zone {
    return _instance;
}

- (void)detectFacesWithTargetImge:(UIImage *)targetImage resultBlock:(void (^)(NSMutableArray<UIImage *> * _Nonnull))resultBlock {
    self.resultBlcok = resultBlock;
    NSMutableArray *resultArrM = [NSMutableArray array];
    if (!targetImage) {
        !resultBlock ?: resultBlock(resultArrM);
        return;
    }
    
    VNDetectFaceRectanglesRequest *faceDetectionRequest = [[VNDetectFaceRectanglesRequest alloc] initWithCompletionHandler:^(VNRequest *request, NSError *error) {
        if (error) {
            LVLog(@"人脸检测错误: %@", error.localizedDescription);
            !resultBlock ?: resultBlock(resultArrM);
            return;
        }
        NSArray *observations = request.results;
        if (observations.count == 0) {
            LVLog(@"未检测到人脸");
            !resultBlock ?: resultBlock(resultArrM);
            return;
        }
        [self processFaceObservations:observations targetImage:targetImage resultArrM:resultArrM];
    }];
    
    // 使用CGImage进行处理
    CGImageRef cgImage = targetImage.CGImage;
    // 创建处理请求
    VNImageRequestHandler *handler = [[VNImageRequestHandler alloc] initWithCGImage:cgImage options:@{}];
    // 执行请求
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSError *error;
        [handler performRequests:@[faceDetectionRequest] error:&error];
        if (error) {
            LVLog(@"执行请求错误: %@", error.localizedDescription);
            !resultBlock ?: resultBlock(resultArrM);
            return;
        }
    });
}

- (void)processFaceObservations:(NSArray *)observations targetImage:(UIImage *)targetImage resultArrM:(NSMutableArray *)resultArrM {
    for (VNFaceObservation *observation in observations) {
        // 获取归一化的人脸边界框
        CGRect boundingBox = observation.boundingBox;
        CGRect faceRect = [self convertNormalizedRect:boundingBox toImageSize:targetImage.size];
        CGRect doubleSizeRect = [self calculateDoubleSizeRectFromFaceRect:faceRect imageSize:targetImage.size];
        UIImage *croppedFace = [self cropImage:targetImage toRect:doubleSizeRect];
        if (croppedFace) {
            [resultArrM addObject:croppedFace];
        }
    }
    !self.resultBlcok ?: self.resultBlcok(resultArrM);
}

// 将归一化坐标转换为图像坐标
- (CGRect)convertNormalizedRect:(CGRect)normalizedRect toImageSize:(CGSize)imageSize {
    CGRect rect = CGRectMake(normalizedRect.origin.x * imageSize.width,
                            (1 - normalizedRect.origin.y - normalizedRect.size.height) * imageSize.height,
                            normalizedRect.size.width * imageSize.width,
                            normalizedRect.size.height * imageSize.height);
    return rect;
}

// 计算比人脸大一倍的矩形区域
- (CGRect)calculateDoubleSizeRectFromFaceRect:(CGRect)faceRect imageSize:(CGSize)imageSize {
    // 计算中心点
    CGPoint faceCenter = CGPointMake(CGRectGetMidX(faceRect), CGRectGetMidY(faceRect));
    
    // 计算新区域的宽度和高度（人脸宽高的两倍）
    CGFloat newWidth = faceRect.size.width * 2.0;
    CGFloat newHeight = faceRect.size.height * 2.0;
    
    // 创建新区域
    CGRect doubleSizeRect = CGRectMake(faceCenter.x - newWidth/2,
                                      faceCenter.y - newHeight/2,
                                      newWidth,
                                      newHeight);
    
    // 确保区域在图像范围内
    return [self adjustRect:doubleSizeRect toFitInSize:imageSize];
}

// 调整矩形确保在图像范围内
- (CGRect)adjustRect:(CGRect)rect toFitInSize:(CGSize)size {
    CGRect adjustedRect = rect;
    
    // 检查左边界
    if (adjustedRect.origin.x < 0) {
        adjustedRect.size.width += adjustedRect.origin.x; // 减少宽度
        adjustedRect.origin.x = 0;
    }
    
    // 检查上边界
    if (adjustedRect.origin.y < 0) {
        adjustedRect.size.height += adjustedRect.origin.y; // 减少高度
        adjustedRect.origin.y = 0;
    }
    
    // 检查右边界
    if (CGRectGetMaxX(adjustedRect) > size.width) {
        adjustedRect.size.width = size.width - adjustedRect.origin.x;
    }
    
    // 检查下边界
    if (CGRectGetMaxY(adjustedRect) > size.height) {
        adjustedRect.size.height = size.height - adjustedRect.origin.y;
    }
    
    // 确保尺寸有效
    adjustedRect.size.width = MAX(0, adjustedRect.size.width);
    adjustedRect.size.height = MAX(0, adjustedRect.size.height);
    
    return adjustedRect;
}

- (UIImage *)cropImage:(UIImage *)image toRect:(CGRect)rect {
    // 确保裁剪区域在图像范围内
    rect = CGRectMake(MAX(0, rect.origin.x),
                     MAX(0, rect.origin.y),
                     MIN(image.size.width - rect.origin.x, rect.size.width),
                     MIN(image.size.height - rect.origin.y, rect.size.height));
    
    CGImageRef imageRef = CGImageCreateWithImageInRect(image.CGImage, rect);
    UIImage *croppedImage = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    
    return croppedImage;
}

// 裁剪图像
//- (UIImage *)cropImage:(UIImage *)image toRect:(CGRect)rect {
//    // 确保裁剪区域在图像范围内
//    rect = CGRectMake(MAX(0, rect.origin.x),
//                     MAX(0, rect.origin.y),
//                     MIN(image.size.width - rect.origin.x, rect.size.width),
//                     MIN(image.size.height - rect.origin.y, rect.size.height));
//    
//    // 创建图像上下文
//    UIGraphicsBeginImageContextWithOptions(rect.size, NO, image.scale);
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    
//    // 绘制裁剪区域
//    CGRect drawRect = CGRectMake(-rect.origin.x, -rect.origin.y, image.size.width, image.size.height);
//    CGContextTranslateCTM(context, 0, rect.size.height);
//    CGContextScaleCTM(context, 1.0, -1.0);
//    CGContextDrawImage(context, drawRect, image.CGImage);
//    
//    // 获取裁剪后的图像
//    UIImage *croppedImage = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    
//    return croppedImage;
//}

@end
