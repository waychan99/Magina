//
//  MGTemplateDetailsCell.h
//  Magina
//
//  Created by 陈志伟 on 2025/8/24.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

static NSString * const MGTemplateDetailsCellKey = @"MGTemplateDetailsCell";

@class MGTemplateListModel;

@interface MGTemplateDetailsCell : UICollectionViewCell

@property (nonatomic, strong) MGTemplateListModel *listModel;

- (void)loadImageWithUrlString:(NSString *)urlString;

@end

NS_ASSUME_NONNULL_END
