//
//  MGReviewImageCell.h
//  Magina
//
//  Created by mac on 2025/8/28.
//

#import <UIKit/UIKit.h>

#define MAXZOOMSCALE 3
#define MINZOOMSCALE 1

NS_ASSUME_NONNULL_BEGIN

static NSString * const MGReviewImageCellKey = @"MGReviewImageCell";

@interface MGReviewImageCell : UICollectionViewCell

@property (nonatomic, assign) NSUInteger cellZoomScale;

@property (nonatomic, strong) MGImageWorksModel *worksModel;

@end

NS_ASSUME_NONNULL_END
