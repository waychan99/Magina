//
//  MGSelectFaceCell.h
//  Magina
//
//  Created by 陈志伟 on 2025/8/23.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

static NSString * const MGSelectFaceCellKey = @"MGSelectFaceCell";

@interface MGSelectFaceCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *contentImageView;

@end

NS_ASSUME_NONNULL_END
