//
//  MGFaceResultCell.h
//  Magina
//
//  Created by 陈志伟 on 2025/8/24.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

static NSString * const MGFaceResultCellKey = @"MGFaceResultCell";

@interface MGFaceResultCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *contentImageView;

@property (nonatomic, copy) void (^deleteFaceCallback)(UIButton *sender, NSInteger index);

@end

NS_ASSUME_NONNULL_END
