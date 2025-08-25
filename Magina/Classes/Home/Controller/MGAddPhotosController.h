//
//  MGAddPhotosController.h
//  Magina
//
//  Created by mac on 2025/8/19.
//

#import "MGBaseController.h"

NS_ASSUME_NONNULL_BEGIN

@interface MGAddPhotosController : MGBaseController

@property (nonatomic, copy) void (^dismissCallback)(void);

@property (nonatomic, copy) void (^selectedImageCallback)(UIImage *resultImage);

@end

NS_ASSUME_NONNULL_END
