//
//  MGPointsListController.m
//  Magina
//
//  Created by mac on 2025/8/18.
//

#import "MGPointsListController.h"
#import "MGPointsListCell.h"
#import "MGPointsDetailsModel.h"
#import "LVEmptyView.h"

@interface MGPointsListController ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView *pointsListView;
@property (nonatomic, strong) NSMutableArray<MGPointsDetailsModel *> *pointsListData;
@property (nonatomic, assign) NSUInteger loadPage;
@property (nonatomic, strong) LVEmptyView *noDataView;
@property (nonatomic, strong) LVEmptyView *noNetworkView;
@end

@implementation MGPointsListController

#pragma mark - lifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUIComponents];
    
    [self.pointsListView ly_startLoading];
    [self.pointsListView.mj_header beginRefreshing];
}

#pragma mark - override
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    CGFloat selfW = self.view.lv_width;
    CGFloat selfH = self.view.lv_height;
    CGFloat pointsListViewY = self.customNavBar.lv_bottom + 15;
    self.pointsListView.frame = CGRectMake(20, pointsListViewY, selfW - 40, selfH - pointsListViewY);
}

#pragma mark - eventClick
- (void)reloadList {
    [self.pointsListView ly_startLoading];
    [self.pointsListView.mj_header beginRefreshing];
}

#pragma mark - setupUIComponents
- (void)setupUIComponents {
    self.customNavBar.title = NSLocalizedString(@"points_detail", nil);
    [self.view addSubview:self.pointsListView];
    self.pointsListView.ly_emptyView = self.noDataView;
    self.pointsListView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(requestPointsDetailsList)];
    self.pointsListView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(requestPointsDetailsList)];
}

#pragma mark - request
- (void)requestPointsDetailsList {
    if (self.pointsListView.mj_header.isRefreshing) {
        self.loadPage = 0;
    }
    NSUInteger tempPage = self.loadPage + 1;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:[MGGlobalManager shareInstance].accountInfo.user_id forKey:@"user_id"];
    [params setValue:@(tempPage) forKey:@"page"];
    [params setValue:@20 forKey:@"size"];
    [LVHttpRequest get:@"/api/v1/getPointsHistory" param:params header:@{} baseUrlType:CDHttpBaseUrlTypeMagina_ljw isNeedPublickParam:YES isNeedPublickHeader:YES isNeedEncryptHeader:YES isNeedEncryptParam:YES isNeedDecryptResponse:YES encryptType:CDHttpBaseUrlTypeMagina_ljw timeout:20.0 modelClass:nil completion:^(NSInteger status, NSString * _Nonnull message, id  _Nullable result, NSError * _Nullable error, id  _Nullable responseObject) {
        if (self.pointsListView.mj_header.isRefreshing) {
            [self.pointsListData removeAllObjects];
            [self.pointsListView.mj_header endRefreshing];
            [self.pointsListView.mj_footer resetNoMoreData];
        }
        if (status != 1 || error) {
            [self.view makeToast:NSLocalizedString(@"global_request_error", nil)];
            if (self.pointsListView.mj_footer.isRefreshing) [self.pointsListView.mj_footer endRefreshing];
            self.pointsListView.ly_emptyView = self.noNetworkView;
            [self.pointsListView ly_endLoading];
            return;
        }
        NSArray *resultArr = (NSArray *)result;
        if (resultArr.count > 0) {
            if (self.pointsListView.mj_footer.isRefreshing) [self.pointsListView.mj_footer endRefreshing];
            [self.pointsListData addObjectsFromArray:[MGPointsDetailsModel mj_objectArrayWithKeyValuesArray:resultArr]];
            self.loadPage = tempPage;
        } else {
            if (self.pointsListView.mj_footer.isRefreshing) [self.pointsListView.mj_footer endRefreshingWithNoMoreData];
        }
        [self.pointsListView reloadData];
        if (self.pointsListData.count <= 0) {
            self.pointsListView.ly_emptyView = self.noDataView;
        }
        [self.pointsListView ly_endLoading];
    }];
}

#pragma mark - UICollectionViewDelegate, UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.pointsListData.count;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 1;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 20, 0);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(self.pointsListView.lv_width, 71);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MGPointsListCell *pointsListCell = [collectionView dequeueReusableCellWithReuseIdentifier:MGPointsListCellKey forIndexPath:indexPath];
    pointsListCell.contentView.backgroundColor = [UIColor blackColor];
    if (self.pointsListData.count <= 1) {
        pointsListCell.contentView.frame = CGRectMake(0, 0, pointsListCell.contentView.lv_width, 71);
        [pointsListCell.contentView lp_setImageWithRadius:LPRadiusMake(15, 15, 15, 15) image:nil borderColor:nil borderWidth:0 backgroundColor:HEX_COLOR(0x141519) contentMode:0 forState:0 completion:nil];
    } else {
        if (indexPath.row == 0) {
            pointsListCell.contentView.frame = CGRectMake(20, 0, pointsListCell.contentView.lv_width, 71);
            [pointsListCell.contentView lp_setImageWithRadius:LPRadiusMake(15, 15, 0, 0) image:nil borderColor:nil borderWidth:0 backgroundColor:HEX_COLOR(0x15161A) contentMode:0 forState:0 completion:nil];
        } else if (indexPath.row == 49) {
            pointsListCell.contentView.frame = CGRectMake(20, 0, pointsListCell.contentView.lv_width, 71);
            [pointsListCell.contentView lp_setImageWithRadius:LPRadiusMake(0, 0, 15, 15) image:nil borderColor:nil borderWidth:0 backgroundColor:HEX_COLOR(0x15161A) contentMode:0 forState:0 completion:nil];
        } else {
            pointsListCell.contentView.backgroundColor = HEX_COLOR(0x15161A);
        }
    }
    return pointsListCell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

}

#pragma mark - getter
- (UICollectionView *)pointsListView {
    if (!_pointsListView) {
        _pointsListView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:[[UICollectionViewFlowLayout alloc] init]];
        _pointsListView.backgroundColor = [UIColor blackColor];
        _pointsListView.delegate = self;
        _pointsListView.dataSource = self;
        _pointsListView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        [_pointsListView registerNib:[UINib nibWithNibName:MGPointsListCellKey bundle:nil] forCellWithReuseIdentifier:MGPointsListCellKey];
    }
    return _pointsListView;
}

- (NSMutableArray<MGPointsDetailsModel *> *)pointsListData {
    if (!_pointsListData) {
        _pointsListData = [NSMutableArray array];
    }
    return _pointsListData;
}


- (LVEmptyView *)noDataView {
    if (!_noDataView) {
        _noDataView = [LVEmptyView emptyViewWithImage:[UIImage imageNamed:@"noData_placeHolder"] titleStr:nil detailStr:nil];
    }
    return _noDataView;
}

- (LVEmptyView *)noNetworkView {
    if (!_noNetworkView) {
        _noNetworkView = [LVEmptyView emptyActionViewWithImage:nil titleStr:/*NSLocalizedString(@"no_data_yet", nil)*/nil detailStr:nil btnTitleStr:NSLocalizedString(@"No content available at the moment", nil) target:self action:@selector(reloadList)];
    }
    return _noNetworkView;
}

@end
