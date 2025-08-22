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
#import "MGHomeListCell.h"

@interface MGHomeListController ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView *templateListView;
@property (nonatomic, strong) UIActivityIndicatorView *indicator;
@property (nonatomic, strong) NSMutableArray<MGTemplateListModel *> *templateList;
@property (nonatomic, assign) NSUInteger loadPage;
@end

@implementation MGHomeListController

#pragma mark - lifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUIComponents];
    [self requestTemplateListNeedIndicator:YES];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    self.templateListView.frame = self.view.bounds;
    self.indicator.frame = self.view.bounds;
}

#pragma mark - setupUIComponents
- (void)setupUIComponents {
    [self.view addSubview:self.templateListView];
    self.templateListView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
}

#pragma mark - request
- (void)requestTemplateListNeedIndicator:(BOOL)needIndicator {
    if (needIndicator) [self showLoading];
    NSUInteger tempPage = self.loadPage + 1;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:self.cateogryModel.term_id forKey:@"category_id"];
    [params setValue:@(tempPage) forKey:@"page"];
    [params setValue:@(20) forKey:@"limit"];
    [LVHttpRequest get:@"/magina-api/api/v1/get_template_products/" param:params header:@{} baseUrlType:CDHttpBaseUrlTypeMagina isNeedPublickParam:YES isNeedPublickHeader:YES isNeedEncryptHeader:YES isNeedEncryptParam:YES isNeedDecryptResponse:YES encryptType:CDHttpBaseUrlTypeMagina timeout:20.0 modelClass:nil completion:^(NSInteger status, NSString * _Nonnull message, id  _Nullable result, NSError * _Nullable error, id  _Nullable responseObject) {
        if (needIndicator) [self hideLoading];
        if (status != 1 || error) {
            [self.view makeToast:NSLocalizedString(@"global_request_error", nil)];
            if (self.templateListView.mj_footer.isRefreshing) [self.templateListView.mj_footer endRefreshing];
            return;
        }
        self.loadPage = tempPage;
        NSMutableArray *templates = [MGTemplateListModel mj_objectArrayWithKeyValuesArray:result];
        if (templates.count > 0) {
            if (self.templateListView.mj_footer.isRefreshing) [self.templateListView.mj_footer endRefreshing];
            [self.templateList addObjectsFromArray:templates];
            [self.templateListView reloadData];
        } else {
            if (self.templateListView.mj_footer.isRefreshing) [self.templateListView.mj_footer endRefreshingWithNoMoreData];
        }
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
    return self.templateList.count;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 5;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 5, 5, 5);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat itemW = floorf((self.templateListView.lv_width - 15) / 2);
    CGFloat itemH = ((itemW * 240) / 180) + 53;
    return CGSizeMake(itemW, itemH);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MGHomeListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:MGHomeListCellKey forIndexPath:indexPath];
    cell.templateListModel = self.templateList[indexPath.item];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    MGTemplateDetailsController *vc = [[MGTemplateDetailsController alloc] init];
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

- (void)setGenderIndex:(NSInteger)genderIndex {
    if (_genderIndex != genderIndex) {
        LVLog(@"需要刷新列表 --- %zd", genderIndex);
    }
    _genderIndex = genderIndex;
    LVLog(@"初始的 --- %zd", genderIndex);
}

#pragma mark - getter
- (UICollectionView *)templateListView {
    if (!_templateListView) {
        _templateListView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:[[UICollectionViewFlowLayout alloc] init]];
        _templateListView.backgroundColor = [UIColor blackColor];
        _templateListView.delegate = self;
        _templateListView.dataSource = self;
        _templateListView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        [_templateListView registerNib:[UINib nibWithNibName:MGHomeListCellKey bundle:nil] forCellWithReuseIdentifier:MGHomeListCellKey];
    }
    return _templateListView;
}

- (UIActivityIndicatorView *)indicator {
    if (!_indicator) {
        _indicator = [[UIActivityIndicatorView alloc] init];
        _indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleMedium;
        _indicator.color = [UIColor lightGrayColor];
    }
    return _indicator;
}

- (NSMutableArray<MGTemplateListModel *> *)templateList {
    if (!_templateList) {
        _templateList = [NSMutableArray array];
    }
    return _templateList;
}

@end
