//
//  MGShotController.h
//  Magina
//
//  Created by mac on 2025/8/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MGShotController : UIViewController

@property (nonatomic, copy) void (^outputPhotoCallback)(UIImage *resultImage);

@end

NS_ASSUME_NONNULL_END
