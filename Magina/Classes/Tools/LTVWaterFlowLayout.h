//
//  LTVWaterFlowLayout.h
//  LongTV
//
//  Created by mac on 2023/2/23.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class LTVWaterFlowLayout;

@protocol LTVWaterFlowLayoutDelegate

- (CGFloat)waterFlowLayout:(LTVWaterFlowLayout *) WaterFlowLayout heightForWidth:(CGFloat)width andIndexPath:(NSIndexPath *)indexPath;

@end

@interface LTVWaterFlowLayout : UICollectionViewLayout

@property (assign,nonatomic)CGFloat columnMargin;//每一列item之间的间距
@property (assign,nonatomic)CGFloat rowMargin;   //每一行item之间的间距
@property (assign,nonatomic)UIEdgeInsets sectionInset;//设置于collectionView边缘的间距
@property (assign,nonatomic)NSInteger columnCount;//设置每一行排列的个数

@property (weak,nonatomic)id<LTVWaterFlowLayoutDelegate> delegate; //设置代理

@end

NS_ASSUME_NONNULL_END
