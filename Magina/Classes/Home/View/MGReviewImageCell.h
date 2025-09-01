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

@class MGReviewImageCell;
@class MGTemplateListModel;

@protocol MGReviewImageCellDelegate<NSObject>

- (void)didClickedReviewImageCell:(MGReviewImageCell *)reviewImageCell index:(NSInteger)index;

@end


@interface MGReviewImageCell : UICollectionViewCell

@property (nonatomic, weak) NSObject<MGReviewImageCellDelegate> *delegate;

@property (nonatomic, assign) NSUInteger cellZoomScale;

@property (nonatomic, strong) MGImageWorksModel *worksModel;

@property (nonatomic, strong) MGTemplateListModel *templateModel;

@end

NS_ASSUME_NONNULL_END
