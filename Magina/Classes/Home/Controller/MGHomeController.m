//
//  MGHomeController.m
//  Magina
//
//  Created by mac on 2025/8/12.
//

#import "MGHomeController.h"
#import "MGHomeListController.h"
#import "MGMineController.h"
#import "MGTemplateCategoryModel.h"
#import "MGTemplateFilterSheet.h"
#import "MGGetPointsView.h"
#import "MGGetPointsFreeAlertView.h"
#import "JXCategoryListContainerView.h"
#import <JXCategoryView/JXCategoryView.h>
#import "UIView+GradientColors.h"

@interface MGHomeController ()<JXCategoryListContainerViewDelegate, JXCategoryViewDelegate>
@property (nonatomic, strong) UIView *topBar;
@property (nonatomic, strong) CAGradientLayer *topBarGradientLayer;
@property (nonatomic, strong) UIImageView *logoImageView;
@property (nonatomic, strong) UIView *pointsBgView;
@property (nonatomic, strong) UIImageView *pointsImageView;
@property (nonatomic, strong) UILabel *pointsLab;
@property (nonatomic, strong) UIImageView *headerIcon;

@property (nonatomic, strong) JXCategoryTitleView *categoryView;
@property (nonatomic, strong) JXCategoryIndicatorLineView *lineView;
@property (nonatomic, strong) JXCategoryListContainerView *listContainerView;

@property (nonatomic, strong) UIButton *filterBtn;
@property (nonatomic, strong) UIActivityIndicatorView *indicator;

@property (nonatomic, strong) NSMutableArray<MGTemplateCategoryModel *> *categoryList;
@property (nonatomic, assign) int testCount;
@end

@implementation MGHomeController

#pragma mark - lifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.navigationController.navigationBar.translucent = false;
//    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [self setupUIComponents];
    [self requestCategoryList];
    
//    LVLog(@"fffff == %zd -- %zd", 9 / 2, 9 % 2);
}

#pragma mark - setupUIComponents
- (void)setupUIComponents {
    [self.view addSubview:self.topBar];
    
    [self.topBar addSubview:self.logoImageView];
    [self.topBar addSubview:self.pointsBgView];
    [self.pointsBgView addSubview:self.pointsImageView];
    [self.pointsBgView addSubview:self.pointsLab];
    [self.pointsBgView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapPointsBgViewAction:)]];
    [self.topBar addSubview:self.headerIcon];
    [self.headerIcon addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHeaderIconAction:)]];
    
    [self.topBar addSubview:self.categoryView];
    [self.topBar addSubview:self.filterBtn];
    [self.view addSubview:self.listContainerView];
    
    self.categoryView.indicators = @[self.lineView];
    self.categoryView.listContainer = self.listContainerView;
}

#pragma mark - override
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    CGFloat selfW = self.view.lv_width;
    self.topBar.frame = CGRectMake(0, 0, selfW, 138);
    self.topBarGradientLayer.frame = self.topBar.bounds;
    [self.topBar.layer insertSublayer:self.topBarGradientLayer atIndex:0];
    
    self.logoImageView.frame = CGRectMake(23, 52.5, 111, 29);
    self.headerIcon.frame = CGRectMake(selfW - 32 - 15.5, 0, 32, 32);
    self.headerIcon.lv_centerY = self.logoImageView.lv_centerY;
    self.pointsImageView.frame = CGRectMake(14, (31 - 17) / 2, 18, 17);
    self.pointsLab.frame = CGRectMake(CGRectGetMaxX(self.pointsImageView.frame) + 5, (31 - 17) / 2, self.pointsLab.lv_width, 17);
    CGFloat pointsBgViewW = 14 + self.pointsImageView.lv_width + 5 + self.pointsLab.lv_width + 16;
    self.pointsBgView.frame = CGRectMake(self.headerIcon.lv_x - 12.5 - pointsBgViewW, 0, pointsBgViewW, 31);
    self.pointsBgView.lv_centerY = self.logoImageView.lv_centerY;
    
    self.categoryView.frame = CGRectMake(0, 138 - 50, selfW - 50, 50);
    self.indicator.frame = CGRectMake(0, 138 - 50, selfW, 50);
    self.filterBtn.frame = CGRectMake(selfW - 50, 138 - 50, 50, 50);
    self.listContainerView.frame = CGRectMake(0, 138, selfW, self.view.lv_height - 138);
}

#pragma mark - eventClick
- (void)clickFilterBtn:(UIButton *)sender {
//    self.testCount ++;
//    
//    if (self.testCount == 3) {
//        self.pointsLab.text = @"fdasd";
//    } else if (self.testCount == 4) {
//        self.pointsLab.text = @"40";
//    } else if (self.testCount == 5) {
//        self.pointsLab.text = @"fdasdfasdf";
//    } else {
//        self.pointsLab.text = @"50";
//    }
//    [self.pointsLab sizeToFit];
//    CGFloat pointsBgViewW = 14 + self.pointsImageView.lv_width + 5 + self.pointsLab.lv_width + 16;
//    self.pointsBgView.frame = CGRectMake(self.headerIcon.lv_x - 12.5 - pointsBgViewW, 0, pointsBgViewW, 31);
//    self.pointsBgView.lv_centerY = self.logoImageView.lv_centerY;
    
    [MGTemplateFilterSheet showWithCategorys:self.categoryList resultBlock:^(MGTemplateCategoryModel * _Nonnull categoryModel, NSString * _Nonnull genderType) {
        
    } completion:nil];
}

- (void)tapPointsBgViewAction:(UIGestureRecognizer *)sender {
//    [MGGetPointsView showWithResultBlock:^(NSInteger actionType) {
//            
//    } completion:nil];
    
    [MGGetPointsFreeAlertView showWithResultBlock:^(NSInteger actionType) {
            
    } completion:nil];
}

- (void)tapHeaderIconAction:(UIGestureRecognizer *)sender {
    MGMineController *vc = [[MGMineController  alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - request
- (void)requestCategoryList {
    [self showLoading];
    [LVHttpRequest get:@"/magina-api/api/v1/get_template_categorys/" param:@{} header:@{} baseUrlType:CDHttpBaseUrlTypeMagina isNeedPublickParam:YES isNeedPublickHeader:YES isNeedEncryptHeader:YES isNeedEncryptParam:YES isNeedDecryptResponse:YES encryptType:CDHttpBaseUrlTypeMagina timeout:20.0 modelClass:nil completion:^(NSInteger status, NSString * _Nonnull message, id  _Nullable result, NSError * _Nullable error, id  _Nullable responseObject) {
        [self hideLoading];
        if (status != 1 || error) {
            [self.view makeToast:NSLocalizedString(@"global_request_error", nil)];
            return;
        }
        self.categoryList = [MGTemplateCategoryModel mj_objectArrayWithKeyValuesArray:result];
        self.categoryView.titles = [self.categoryList valueForKeyPath:@"category_name"];
        [self.categoryView reloadData];
        [self.listContainerView reloadData];
    }];
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
    MGHomeListController *list = [[MGHomeListController alloc] init];
    list.cateogryModel = self.categoryList[index];
    return list;
}

#pragma mark - assistMethod
- (void)showLoading {
    if (self.indicator.superview == nil || self.indicator.superview != self.topBar) {
        [self.topBar addSubview:self.indicator];
        [self.topBar bringSubviewToFront:self.indicator];
        [self.indicator startAnimating];
    }
}

- (void)hideLoading {
    if (self.indicator.superview) {
        [self.indicator stopAnimating];
        [self.indicator removeFromSuperview];
    }
}

#pragma mark - getter
- (UIView *)topBar {
    if (!_topBar) {
        _topBar = [[UIView alloc] init];
    }
    return _topBar;
}

- (CAGradientLayer *)topBarGradientLayer {
    if (!_topBarGradientLayer) {
        _topBarGradientLayer = [self.topBar setGradientColors:@[(__bridge id)HEX_COLOR(0x220A51).CGColor,(__bridge id)HEX_COLOR(0x000000).CGColor] andGradientPosition:PositonVertical frame:CGRectZero];
    }
    return _topBarGradientLayer;
}

- (UIImageView *)logoImageView {
    if (!_logoImageView) {
        _logoImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MG_home_topBar_logo_icon"]];
    }
    return _logoImageView;
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

- (UIImageView *)headerIcon {
    if (!_headerIcon) {
        _headerIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MG_home_topbar_user_placeholder_icon"]];
        _headerIcon.userInteractionEnabled = YES;
    }
    return _headerIcon;
}

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

- (UIButton *)filterBtn {
    if (!_filterBtn) {
        _filterBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_filterBtn setImage:[UIImage imageNamed:@"MG_home_topbar_menu_settings_icon"] forState:UIControlStateNormal];
        [_filterBtn addTarget:self action:@selector(clickFilterBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _filterBtn;
}

- (UIActivityIndicatorView *)indicator {
    if (!_indicator) {
        _indicator = [[UIActivityIndicatorView alloc] init];
        _indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleMedium;
        _indicator.color = [UIColor lightGrayColor];
    }
    return _indicator;
}

- (NSMutableArray<MGTemplateCategoryModel *> *)categoryList {
    if (!_categoryList) {
        _categoryList = [NSMutableArray array];
    }
    return _categoryList;
}

@end
