//
//  MGAlbumListView.h
//  Magina
//
//  Created by 陈志伟 on 2025/8/23.
//

#import <UIKit/UIKit.h>
#import "MGAssetModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MGAlbumListView : UIView

+ (instancetype)showFromView:(UIView *)sender albumList:(NSArray *)albumList resultBlock:(void (^ __nullable)(MGAlbumModel *albumModel))resultBlock completion:(void (^ __nullable)(BOOL finished))completion;

@end

NS_ASSUME_NONNULL_END
