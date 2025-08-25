//
//  MGSelectFaceController.h
//  Magina
//
//  Created by 陈志伟 on 2025/8/23.
//

#import "MGBaseController.h"

NS_ASSUME_NONNULL_BEGIN

@interface MGSelectFaceController : MGBaseController

@property (nonatomic, strong) UIImage *originImage;

@property (nonatomic, strong) NSArray *imageList;

@property (nonatomic, copy) void (^selectedImageCallback)(UIImage *resultImage);

@end

NS_ASSUME_NONNULL_END
