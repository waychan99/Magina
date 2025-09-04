//
//  MGDeleteImageWorkSheet.h
//  Magina
//
//  Created by mac on 2025/9/3.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MGDeleteImageWorkSheet : UIView

+ (instancetype)showWithResultBlock:(void (^ __nullable)(NSInteger actionType))resultBlock completion:(void (^ __nullable)(BOOL finished))completion;

@end

NS_ASSUME_NONNULL_END
