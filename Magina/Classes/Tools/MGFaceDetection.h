//
//  MGFaceDetection.h
//  Magina
//
//  Created by mac on 2025/8/25.
//

#import <Foundation/Foundation.h>
//#import <MLKitFaceDetection/MLKitFaceDetection.h>
//#import <MLKitVision/MLKitVision.h>

NS_ASSUME_NONNULL_BEGIN

@interface MGFaceDetection : NSObject

+ (instancetype)shareInstance;

//- (void)detectFacesInImage:(UIImage *)image completion:(void (^)(NSArray<MLKFace *> *faces, NSError *error))completion;
//
//- (void)detectFacesInPixelBuffer:(CVPixelBufferRef)pixelBuffer completion:(void (^)(NSArray<MLKFace *> *faces, NSError *error))completion;
//
//- (void)drawFaceAnnotations:(NSArray<MLKFace *> *)faces onImage:(UIImage *)image completion:(void (^)(UIImage *annotatedImage))completion;

//- (void)detectFacesWithTargetImge:(UIImage *)targetImage resultBlock:(void (^ __nullable)(NSMutableArray<UIImage *> *images))resultBlock;

@end

NS_ASSUME_NONNULL_END
