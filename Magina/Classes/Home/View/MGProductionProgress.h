//
//  MGProductionProgress.h
//  Magina
//
//  Created by mac on 2025/8/25.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MGProductionProgress : UIView

@property (nonatomic, assign) CGFloat duration;/**<动画时长*/

//进度
@property (nonatomic, assign) CGFloat progress;/**<进度 0-1 */

@end

NS_ASSUME_NONNULL_END
