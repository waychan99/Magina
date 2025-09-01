//
//  MGHomeListController.m
//  Magina
//
//  Created by mac on 2025/8/12.
//

#import "MGHomeListController.h"
#import "MGTemplateDetailsController.h"
#import "MGTemplateCategoryModel.h"
#import "MGTemplateListModel.h"
#import "MGTemplateListViewModel.h"
#import "MGHomeListCell.h"
#import "LVEmptyView.h"
#import "LTVWaterFlowLayout.h"

@interface MGHomeListController ()<UICollectionViewDelegate, UICollectionViewDataSource, LTVWaterFlowLayoutDelegate>
@property (nonatomic, strong) UICollectionView *templateListView;
@property (nonatomic, strong) LTVWaterFlowLayout *waterFlowLayout;
@property (nonatomic, strong) UIActivityIndicatorView *indicator;
@property (nonatomic, strong) NSMutableArray<MGTemplateListViewModel *> *templateViewModels;
@property (nonatomic, strong) NSMutableArray<MGTemplateListModel *> *templateModels;
@property (nonatomic, assign) NSUInteger loadPage;
@property (nonatomic, strong) LVEmptyView *noDataView;
@property (nonatomic, strong) LVEmptyView *noNetworkView;
@property (nonatomic, strong) NSValue *toastPointValue;
@end

@implementation MGHomeListController

#pragma mark - lifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUIComponents];
    
    [self.templateListView ly_startLoading];
    [self requestTemplateListNeedIndicator:YES];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    self.templateListView.frame = self.view.bounds;
    [self.templateListView setCollectionViewLayout:self.waterFlowLayout];
    self.indicator.frame = self.view.bounds;
}

#pragma mark - setupUIComponents
- (void)setupUIComponents {
    [self.view addSubview:self.templateListView];
    self.templateListView.ly_emptyView = self.noDataView;
    self.templateListView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
}

#pragma mark - eventClick
- (void)reloadList {
    [self.templateListView ly_startLoading];
    [self requestTemplateListNeedIndicator:YES];
}

#pragma mark - request
- (void)requestTemplateListNeedIndicator:(BOOL)needIndicator {
    if (needIndicator) [self showLoading];
    NSUInteger tempPage = self.loadPage + 1;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:self.cateogryModel.term_id forKey:@"category_id"];
    [params setValue:@(tempPage) forKey:@"page"];
    [params setValue:@(20) forKey:@"limit"];
    NSString *filterType = @"";
    if (self.genderIndex == 0) {
        filterType = @"-1";
    } else if (self.genderIndex == 1) {
        filterType = @"1";
    } else if (self.genderIndex == 2) {
        filterType = @"0";
    }
    [params setValue:filterType forKey:@"filter_type"];
    [LVHttpRequest get:@"/magina-api/api/v1/get_template_products/" param:params header:@{} baseUrlType:CDHttpBaseUrlTypeMagina isNeedPublickParam:YES isNeedPublickHeader:YES isNeedEncryptHeader:YES isNeedEncryptParam:YES isNeedDecryptResponse:YES encryptType:CDHttpBaseUrlTypeMagina timeout:20.0 modelClass:nil completion:^(NSInteger status, NSString * _Nonnull message, id  _Nullable result, NSError * _Nullable error, id  _Nullable responseObject) {
        if (needIndicator) [self hideLoading];
        if (status != 1 || error) {
            [self.view makeToast:NSLocalizedString(@"global_request_error", nil) duration:2.0 position:self.toastPointValue];
            if (self.templateListView.mj_footer.isRefreshing) [self.templateListView.mj_footer endRefreshing];
            self.templateListView.ly_emptyView = self.noNetworkView;
            [self.templateListView ly_endLoading];
            return;
        }
        NSArray *resultArr = (NSArray *)result;
        if (resultArr.count > 0) {
            if (self.templateListView.mj_footer.isRefreshing) [self.templateListView.mj_footer endRefreshing];
            NSMutableArray *templates = [MGTemplateListModel mj_objectArrayWithKeyValuesArray:resultArr];
            [self.templateModels addObjectsFromArray:templates];
            NSMutableArray *viewModels = [NSMutableArray array];
            for (MGTemplateListModel *listModel in templates) {
                MGTemplateListViewModel *viewModel = [[MGTemplateListViewModel alloc] init];
                viewModel.listModel = listModel;
                [viewModels addObject:viewModel];
            }
            [self.templateViewModels addObjectsFromArray:viewModels];
            self.loadPage = tempPage;
        } else {
            if (self.templateListView.mj_footer.isRefreshing) [self.templateListView.mj_footer endRefreshingWithNoMoreData];
        }
        [self.templateListView reloadData];
        if (self.templateViewModels.count <= 0) {
            self.templateListView.ly_emptyView = self.noDataView;
        }
        [self.templateListView ly_endLoading];
    }];
}

- (void)loadMoreData {
    [self requestTemplateListNeedIndicator:NO];
}

#pragma mark - UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.templateViewModels.count;
}

- (CGFloat)waterFlowLayout:(LTVWaterFlowLayout *)WaterFlowLayout heightForWidth:(CGFloat)width andIndexPath:(NSIndexPath *)indexPath {
    MGTemplateListViewModel *viewModel = self.templateViewModels[indexPath.item];
    return viewModel.cellHeight;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MGHomeListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:MGHomeListCellKey forIndexPath:indexPath];
    cell.templateListViewModel = self.templateViewModels[indexPath.item];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    MGTemplateDetailsController *vc = [[MGTemplateDetailsController alloc] init];
    vc.templateModels = [self.templateModels copy];
    vc.currentTemplateIndex = indexPath.item;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - JXPagerViewListViewDelegate
- (UIView *)listView {
    return self.view;
}

#pragma mark - assistMethod
- (void)showLoading {
    if (self.indicator.superview == nil || self.indicator.superview != self.view) {
        [self.view addSubview:self.indicator];
        [self.view bringSubviewToFront:self.indicator];
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
- (UICollectionView *)templateListView {
    if (!_templateListView) {
        _templateListView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:[[UICollectionViewFlowLayout alloc] init]];
        _templateListView.backgroundColor = [UIColor blackColor];
        _templateListView.delegate = self;
        _templateListView.dataSource = self;
        _templateListView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        [_templateListView registerClass:[MGHomeListCell class] forCellWithReuseIdentifier:MGHomeListCellKey];
    }
    return _templateListView;
}

- (LTVWaterFlowLayout *)waterFlowLayout {
    if (!_waterFlowLayout) {
        _waterFlowLayout = [LTVWaterFlowLayout new];
        _waterFlowLayout.columnCount = 2;
        _waterFlowLayout.sectionInset = UIEdgeInsetsMake(0, 5, 5, 5);
        _waterFlowLayout.rowMargin = 0;
        _waterFlowLayout.columnMargin = 5;
        _waterFlowLayout.delegate = self;
    }
    return _waterFlowLayout;
}

- (UIActivityIndicatorView *)indicator {
    if (!_indicator) {
        _indicator = [[UIActivityIndicatorView alloc] init];
        _indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleMedium;
        _indicator.color = [UIColor lightGrayColor];
    }
    return _indicator;
}

- (NSMutableArray<MGTemplateListViewModel *> *)templateViewModels {
    if (!_templateViewModels) {
        _templateViewModels = [NSMutableArray array];
    }
    return _templateViewModels;
}

- (NSMutableArray<MGTemplateListModel *> *)templateModels {
    if (!_templateModels) {
        _templateModels = [NSMutableArray array];
    }
    return _templateModels;
}

- (LVEmptyView *)noDataView {
    if (!_noDataView) {
        _noDataView = [LVEmptyView emptyViewWithImage:[UIImage imageNamed:@"noData_placeHolder"] titleStr:nil detailStr:nil];
    }
    return _noDataView;
}

- (LVEmptyView *)noNetworkView {
    if (!_noNetworkView) {
        _noNetworkView = [LVEmptyView emptyActionViewWithImage:nil titleStr:nil detailStr:nil btnTitleStr:NSLocalizedString(@"No content available at the moment", nil) target:self action:@selector(reloadList)];
    }
    return _noNetworkView;
}

- (NSValue *)toastPointValue {
    if (!_toastPointValue) {
        _toastPointValue = [NSValue valueWithCGPoint:CGPointMake(self.view.lv_width / 2, self.view.lv_height / 2 - 60)];
    }
    return _toastPointValue;
}

@end

