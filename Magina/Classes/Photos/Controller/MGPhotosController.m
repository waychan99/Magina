//
//  MGPhotosController.m
//  Magina
//
//  Created by 陈志伟 on 2025/8/21.
//

#import "MGPhotosController.h"
#import "MGPhotoListController.h"
#import "MGFavoriteListController.h"
#import <JXCategoryView/JXCategoryView.h>

@interface MGPhotosController ()<JXCategoryListContainerViewDelegate, JXCategoryViewDelegate>
@property (nonatomic, strong) JXCategoryTitleView *categoryView;
@property (nonatomic, strong) JXCategoryIndicatorLineView *lineView;
@property (nonatomic, strong) JXCategoryListContainerView *listContainerView;
@end

@implementation MGPhotosController

#pragma mark - lefeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUIComponents];
}

#pragma mark - setupUIComponents
- (void)setupUIComponents {
    [self.view addSubview:self.categoryView];
    [self.view addSubview:self.listContainerView];
    
    self.categoryView.indicators = @[self.lineView];
    self.categoryView.titles = @[NSLocalizedString(@"workk", nil), NSLocalizedString(@"collectt", nil)];
    self.categoryView.listContainer = self.listContainerView;
}

#pragma mark - override
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    CGFloat selfW = self.view.lv_width;
    self.categoryView.frame = CGRectMake(0, UIStatusBar_H, selfW, 50);
    self.listContainerView.frame = CGRectMake(0, self.categoryView.lv_bottom, selfW, self.view.lv_height - self.categoryView.lv_bottom);
}

#pragma mark - JXCategoryListContentViewDelegate
- (UIView *)listView {
    return self.view;
}

#pragma mark - JXCategoryListContainerViewDelegate
- (NSInteger)numberOfListsInlistContainerView:(JXCategoryListContainerView *)listContainerView {
    return self.categoryView.titles.count;
}

- (id<JXCategoryListContentViewDelegate>)listContainerView:(JXCategoryListContainerView *)listContainerView initListForIndex:(NSInteger)index {
    if (index == 0) {
        MGPhotoListController *photoList = [[MGPhotoListController alloc] init];
        return photoList;
    } else {
        MGFavoriteListController *favoriteList = [[MGFavoriteListController alloc] init];
        return favoriteList;
    }
}

#pragma mark - getter
- (JXCategoryTitleView *)categoryView {
    if (!_categoryView) {
        _categoryView = [[JXCategoryTitleView alloc] initWithFrame:CGRectZero];
        _categoryView.delegate = self;
        _categoryView.cellSpacing = 24;
        _categoryView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.0];
        _categoryView.titleFont = [UIFont systemFontOfSize:13.0 weight:UIFontWeightHeavy];
        _categoryView.titleSelectedFont = [UIFont systemFontOfSize:13.0 weight:UIFontWeightMedium];
        _categoryView.titleColor = HEX_COLOR(0x8C919D);
        _categoryView.titleSelectedColor = [UIColor whiteColor];
        _categoryView.averageCellSpacingEnabled = NO;
    }
    return _categoryView;
}

- (JXCategoryIndicatorLineView *)lineView {
    if (!_lineView) {
        _lineView = [[JXCategoryIndicatorLineView alloc] init];
        _lineView.indicatorColor = HEX_COLOR(0xFE6191);
        _lineView.indicatorWidth = 16;
        _lineView.indicatorHeight = 2.5;
        _lineView.indicatorCornerRadius = 1.25;
        _lineView.verticalMargin = 7;
    }
    return _lineView;
}

- (JXCategoryListContainerView *)listContainerView {
    if (!_listContainerView) {
        _listContainerView = [[JXCategoryListContainerView alloc] initWithType:JXCategoryListContainerType_ScrollView delegate:self];
        _listContainerView.scrollView.backgroundColor = [UIColor blackColor];
    }
    return _listContainerView;
}

@end
