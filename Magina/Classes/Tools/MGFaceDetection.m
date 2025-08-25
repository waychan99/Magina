//
//  MGFaceDetection.m
//  Magina
//
//  Created by mac on 2025/8/25.
//

#import "MGFaceDetection.h"

@interface MGFaceDetection () {
//    MLKFaceDetector *_faceDetector;
}
@property (nonatomic, copy) void (^resultBlcok)(NSMutableArray<UIImage *> *images);
@end

@implementation MGFaceDetection

static MGFaceDetection *_instance;

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

- (instancetype)init {
    if (self = [super init]) {
        // 配置人脸检测器
//        MLKFaceDetectorOptions *options = [[MLKFaceDetectorOptions alloc] init];
//        options.performanceMode = MLKFaceDetectorPerformanceModeAccurate; // 高精度模式
//        options.landmarkMode = MLKFaceDetectorLandmarkModeAll; // 检测所有特征点
//        options.classificationMode = MLKFaceDetectorClassificationModeAll; // 检测所有分类（微笑、睁眼等）
////        options.contourMode = MLKFaceDetectorContourModeAll; // 检测所有轮廓
////        options.minFaceSize = 0.1; // 最小人脸尺寸（相对于图像尺寸的比例）
//        
//        _faceDetector = [MLKFaceDetector faceDetectorWithOptions:options];
    }
    return self;
}

//- (void)detectFacesWithTargetImge:(UIImage *)targetImage resultBlock:(void (^)(NSMutableArray<UIImage *> * _Nonnull))resultBlock {
//    self.resultBlcok = resultBlock;
//    NSMutableArray *resultArrM = [NSMutableArray array];
//    if (!targetImage) {
//        !resultBlock ?: resultBlock(resultArrM);
//        return;
//    }
//    
//    MLKVisionImage *visionImage = [[MLKVisionImage alloc] initWithImage:targetImage];
//    LVLog(@"图片的方向 --- %zd", targetImage.imageOrientation);
//    visionImage.orientation = targetImage.imageOrientation;
//    
//    [_faceDetector processImage:visionImage completion:^(NSArray<MLKFace *> * _Nullable faces, NSError * _Nullable error) {
//        if (error) {
//            !resultBlock ?: resultBlock(resultArrM);
//            return;
//        }
//        [self processFaces:faces targetImage:targetImage resultArrM:resultArrM];
//    }];
//}
//
//- (void)processFaces:(NSArray<MLKFace *> *)faces targetImage:(UIImage *)targetImage resultArrM:(NSMutableArray *)resultArrM {
//    for (MLKFace *face in faces) {
//        CGRect boundingBox = face.frame;
//        CGRect faceRect = [self convertNormalizedRect:boundingBox toImageSize:targetImage.size];
//        UIImage *croppedFace = [self cropImage:targetImage toRect:faceRect];
//        if (croppedFace) {
//            [resultArrM addObject:croppedFace];
//        }
//    }
//    !self.resultBlcok ?: self.resultBlcok(resultArrM);
//}

// 将归一化坐标转换为图像坐标
- (CGRect)convertNormalizedRect:(CGRect)normalizedRect toImageSize:(CGSize)imageSize {
    CGRect rect = CGRectMake(normalizedRect.origin.x * imageSize.width,
                            (1 - normalizedRect.origin.y - normalizedRect.size.height) * imageSize.height,
                            normalizedRect.size.width * imageSize.width,
                            normalizedRect.size.height * imageSize.height);
    return rect;
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

@end
