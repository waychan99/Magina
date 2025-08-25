//
//  MGFaceRecognition.h
//  Magina
//
//  Created by 陈志伟 on 2025/8/24.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MGFaceRecognition : NSObject

+ (instancetype)shareInstance;

- (void)detectFacesWithTargetImge:(UIImage *)targetImage resultBlock:(void (^ __nullable)(NSMutableArray<UIImage *> *images))resultBlock;

@end

NS_ASSUME_NONNULL_END
