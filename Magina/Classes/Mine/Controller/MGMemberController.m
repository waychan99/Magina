//
//  MGMemberController.m
//  Magina
//
//  Created by mac on 2025/8/19.
//

#import "MGMemberController.h"
#import "MGMemberListController.h"
#import "MGMemberHeader.h"
#import <JXCategoryView/JXCategoryView.h>

static const CGFloat MGMemberCategoryHeight = 56;

@interface MGMemberController ()<JXCategoryViewDelegate, JXCategoryListContainerViewDelegate>
@property (nonatomic, strong) JXCategoryTitleView *categoryView;
@property (nonatomic, strong) JXCategoryIndicatorLineView *lineView;
@property (nonatomic, strong) JXCategoryListContainerView *listContainerView;
@property (nonatomic, strong) MGMemberHeader *header;
@end

@implementation MGMemberController

#pragma mark - lifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUIComponents];
}

#pragma mark - setupUIComponents
- (void)setupUIComponents {
    [self.view addSubview:self.header];
    
    [self.view addSubview:self.categoryView];
    [self.view addSubview:self.listContainerView];
    
    self.categoryView.indicators = @[self.lineView];
    self.categoryView.listContainer = self.listContainerView;
    
    self.categoryView.titles = @[@"fff", @"ee", @"ddd"];
    
    [self.view bringSubviewToFront:self.customNavBar];
}

#pragma mark - override
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    self.header.frame = CGRectMake(0, 0, self.view.lv_width, 520);
    self.categoryView.frame = CGRectMake(0, self.header.lv_bottom, self.view.lv_width, 50);
    self.listContainerView.frame = CGRectMake(0, self.categoryView.lv_bottom, self.view.lv_width, self.view.lv_height - self.categoryView.lv_bottom);
}

#pragma mark - JXCategoryListContainerViewDelegate
- (NSInteger)numberOfListsInlistContainerView:(JXCategoryListContainerView *)listContainerView {
    return self.categoryView.titles.count;
}

- (id<JXCategoryListContentViewDelegate>)listContainerView:(JXCategoryListContainerView *)listContainerView initListForIndex:(NSInteger)index {
    MGMemberListController *list = [[MGMemberListController alloc] init];
    return list;
}

#pragma mark - JXCategoryViewDelegate
//- (void)categoryView:(JXCategoryBaseView *)categoryView didSelectedItemAtIndex:(NSInteger)index {
//    //    self.navigationController.interactivePopGestureRecognizer.enabled = (index == 0);
//}

#pragma mark - getter
- (MGMemberHeader *)header {
    if (!_header) {
        _header = (MGMemberHeader *)[[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([MGMemberHeader class]) owner:nil options:nil] lastObject];
    }
    return _header;
}

- (JXCategoryTitleView *)categoryView {
    if (!_categoryView) {
        _categoryView = [[JXCategoryTitleView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_W, MGMemberCategoryHeight)];
        _categoryView.delegate = self;
        _categoryView.cellSpacing = 24;
        _categoryView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.0];
        _categoryView.titleFont = [UIFont systemFontOfSize:13.0 weight:UIFontWeightMedium];
        _categoryView.titleSelectedFont = [UIFont systemFontOfSize:13.0 weight:UIFontWeightHeavy];
        _categoryView.titleColor = HEX_COLOR(0x8C919D);
        _categoryView.titleSelectedColor = [UIColor whiteColor];
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
