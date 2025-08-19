//
//  MGMineController.m
//  Magina
//
//  Created by mac on 2025/8/15.
//

#import "MGMineController.h"
#import "MGMineListController.h"
#import "MGPersonalController.h"
#import "MGMemberController.h"
#import "MGMineHeaderView.h"

static const CGFloat MGMineCategoryHeight = 56;

@interface MGMineController ()<JXCategoryViewDelegate>
@property (nonatomic, strong) UIImageView *topImageView;
@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UIButton *settingBtn;
@property (nonatomic, strong) UIView *pointsBgView;
@property (nonatomic, strong) UIImageView *pointsImageView;
@property (nonatomic, strong) UILabel *pointsLab;

@property (nonatomic, strong) JXPagerView *pagerView;
@property (nonatomic, strong) JXCategoryTitleView *categoryView;
@property (nonatomic, strong) JXCategoryIndicatorLineView *lineView;
@property (nonatomic, strong) MGMineHeaderView *header;
@end

@implementation MGMineController

#pragma mark - lifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUIComponents];
}

#pragma mark - override
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    CGFloat selfW = self.view.lv_width;
    CGFloat selfH = self.view.lv_height;
    
    self.topImageView.frame = CGRectMake(0, 0, selfW, (selfW * 448) / 375);
    self.settingBtn.frame = CGRectMake(selfW - 30 - 10, 0, 30, 30);
    self.settingBtn.lv_centerY = self.wrNaviBar_leftButton.lv_centerY;
    
    self.titleLab.frame = CGRectMake(CGRectGetMaxX(self.wrNaviBar_leftButton.frame), 0, self.titleLab.lv_width, 30);
    self.titleLab.lv_centerY = self.wrNaviBar_leftButton.lv_centerY;
    self.pointsImageView.frame = CGRectMake(14, (31 - 17) / 2, 18, 17);
    self.pointsLab.frame = CGRectMake(CGRectGetMaxX(self.pointsImageView.frame) + 5, (31 - 17) / 2, self.pointsLab.lv_width, 17);
    CGFloat pointsBgViewW = 14 + self.pointsImageView.lv_width + 5 + self.pointsLab.lv_width + 16;
    self.pointsBgView.frame = CGRectMake(self.settingBtn.lv_x - 12 - pointsBgViewW, 0, pointsBgViewW, 31);
    self.pointsBgView.lv_centerY = self.wrNaviBar_leftButton.lv_centerY;
    
    CGFloat pagerViewY = self.customNavBar.lv_bottom;
    self.pagerView.frame = CGRectMake(0, pagerViewY, selfW, selfH - pagerViewY);
}

#pragma mark - setupUIComponents
- (void)setupUIComponents {
    [self.view addSubview:self.topImageView];
    [self.customNavBar addSubview:self.titleLab];
    [self.customNavBar addSubview:self.settingBtn];
    [self.customNavBar addSubview:self.pointsBgView];
    [self.pointsBgView addSubview:self.pointsImageView];
    [self.pointsBgView addSubview:self.pointsLab];

    self.categoryView.indicators = @[self.lineView];
    self.categoryView.titles = @[@"fff", @"ee"];
    [self.view addSubview:self.pagerView];
    self.categoryView.listContainer = (id<JXCategoryViewListContainer>)self.pagerView.listContainerView;
    
    [self.view bringSubviewToFront:self.customNavBar];
    
    @lv_weakify(self)
    self.header.tapBgImageViewCallback = ^(UIGestureRecognizer * _Nonnull sender) {
        @lv_strongify(self)
        MGMemberController *vc = [[MGMemberController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    };
}

#pragma mark - eventClick
- (void)clickSettingBtn:(UIButton *)sender {
    MGPersonalController *vc = [[MGPersonalController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - JXCategoryListContentViewDelegate
- (UIView *)listView {
    return self.view;
}

#pragma mark - JXPagingViewDelegate
- (UIView *)tableHeaderViewInPagerView:(JXPagerView *)pagerView {
    return self.header;
}

- (NSUInteger)tableHeaderViewHeightInPagerView:(JXPagerView *)pagerView {
    return self.header.headerHeight;
}

- (NSUInteger)heightForPinSectionHeaderInPagerView:(JXPagerView *)pagerView {
    return MGMineCategoryHeight;
}

- (UIView *)viewForPinSectionHeaderInPagerView:(JXPagerView *)pagerView {
    return self.categoryView;
}

- (NSInteger)numberOfListsInPagerView:(JXPagerView *)pagerView {
    return self.categoryView.titles.count;
}

- (id<JXPagerViewListViewDelegate>)pagerView:(JXPagerView *)pagerView initListAtIndex:(NSInteger)index {
    MGMineListController *vc = [[MGMineListController alloc] init];
    return vc;
}

#pragma mark - JXCategoryViewDelegate
- (void)categoryView:(JXCategoryBaseView *)categoryView didSelectedItemAtIndex:(NSInteger)index {
    //    self.navigationController.interactivePopGestureRecognizer.enabled = (index == 0);
}

#pragma mark - JXPagerMainTableViewGestureDelegate
- (BOOL)mainTableViewGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    //禁止categoryView左右滑动的时候，上下和左右都可以滚动
    if (otherGestureRecognizer == self.categoryView.collectionView.panGestureRecognizer) {
        return NO;
    }
    return [gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]] && [otherGestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]];
}

#pragma mark - getter
- (UIImageView *)topImageView {
    if (!_topImageView) {
        _topImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MG_mine_top_bg"]];
    }
    return _topImageView;
}

- (UILabel *)titleLab {
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] init];
        _titleLab.textAlignment = NSTextAlignmentLeft;
        _titleLab.textColor = [UIColor whiteColor];
        _titleLab.font = [UIFont systemFontOfSize:14.0 weight:UIFontWeightBold];
        _titleLab.text = NSLocalizedString(@"Personal Center", nil);
        [_titleLab sizeToFit];
    }
    return _titleLab;
}

- (UIButton *)settingBtn {
    if (!_settingBtn) {
        _settingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_settingBtn setImage:[UIImage imageNamed:@"MG_mine_setting_icon"] forState:UIControlStateNormal];
        [_settingBtn addTarget:self action:@selector(clickSettingBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _settingBtn;
}

- (UIView *)pointsBgView {
    if (!_pointsBgView) {
        _pointsBgView = [[UIView alloc] init];
        _pointsBgView.backgroundColor = [UIColor colorWithWhite:0.7 alpha:0.1];
        _pointsBgView.layer.cornerRadius = 15.5;
    }
    return _pointsBgView;
}

- (UIImageView *)pointsImageView {
    if (!_pointsImageView) {
        _pointsImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MG_home_topbar_points_icon"]];
    }
    return _pointsImageView;
}

- (UILabel *)pointsLab {
    if (!_pointsLab) {
        _pointsLab = [[UILabel alloc] init];
        _pointsLab.textColor = [UIColor whiteColor];
        _pointsLab.font = [UIFont systemFontOfSize:14.0 weight:UIFontWeightMedium];
        _pointsLab.text = @"0";
        [_pointsLab sizeToFit];
    }
    return _pointsLab;
}

- (JXPagerView *)pagerView {
    if (!_pagerView) {
        _pagerView = [[JXPagerView alloc] initWithDelegate:self];
        _pagerView.mainTableView.backgroundColor = [UIColor blackColor];
        _pagerView.mainTableView.gestureDelegate = self;
    }
    return _pagerView;
}

- (MGMineHeaderView *)header {
    if (!_header) {
        _header =  (MGMineHeaderView *)[[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([MGMineHeaderView class]) owner:nil options:nil] lastObject];
    }
    return _header;
}

- (JXCategoryTitleView *)categoryView {
    if (!_categoryView) {
        _categoryView = [[JXCategoryTitleView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_W, MGMineCategoryHeight)];
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

@end
