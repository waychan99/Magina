//
//  MGTemplateListViewModel.h
//  Magina
//
//  Created by 陈志伟 on 2025/8/24.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

// cell之间的间距
#define MGHomeListCellMargin 5

// cell的边框宽度
#define MGHomeListCellBorderW 5


@class MGTemplateListModel;

@interface MGTemplateListViewModel : NSObject

@property (nonatomic, strong) MGTemplateListModel *listModel;

@property (nonatomic, assign) CGRect contentImageViewF;

@property (nonatomic, assign) CGRect titleLabF;

@property (nonatomic, assign) CGFloat cellHeight;

@end

NS_ASSUME_NONNULL_END
