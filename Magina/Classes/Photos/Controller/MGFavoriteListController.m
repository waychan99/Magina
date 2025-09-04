//
//  MGFavoriteListController.m
//  Magina
//
//  Created by 陈志伟 on 2025/8/25.
//

#import "MGFavoriteListController.h"
#import "MGTemplateDetailsController.h"
#import "MGPhotoListCell.h"
#import "MGFavoriteTemplateModel.h"
#import "MGTemplateListModel.h"
#import "LVEmptyView.h"

@interface MGFavoriteListController ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIActivityIndicatorView *indicator;
@property (nonatomic, strong) NSMutableArray<MGFavoriteTemplateModel *> *favoriteListData;
@property (nonatomic, assign) NSUInteger loadPage;
@property (nonatomic, strong) LVEmptyView *noDataView;
@property (nonatomic, strong) LVEmptyView *noNetworkView;
@property (nonatomic, strong) LVEmptyView *loginFirstView;
@property (nonatomic, strong) NSValue *toastPointValue;
@end

@implementation MGFavoriteListController

#pragma mark - lifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestFavoriteNotification:) name:MG_REQUEST_FAVORITE_TEMPLATE_STATUS_NOTI object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(favoriteTemplateListDidChanged) name:MG_FAVORITE_TEMPLATE_LIST_DID_CHANGED object:nil];
    
    [self setupUIComponents];
    
    [self.collectionView ly_startLoading];
    [self reqeustFavoriteListNeedIndicator:YES requestServer:YES];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - override
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    self.collectionView.frame = self.view.bounds;
    self.indicator.frame = self.view.bounds;
}

#pragma mark - setupUIComponents
- (void)setupUIComponents {
    [self.view addSubview:self.collectionView];
    self.collectionView.ly_emptyView = self.noDataView;
}

#pragma mark - eventClick
- (void)reloadList {
    [self.collectionView ly_startLoading];
    [self reqeustFavoriteListNeedIndicator:YES requestServer:YES];
}

- (void)loginFisrtAction {
    
}

#pragma mark - notification
- (void)requestFavoriteNotification:(NSNotification *)noti {
    NSDictionary *objc = noti.object;
    int status = [objc[@"status"] intValue];
    [self reqeustFavoriteListNeedIndicator:YES requestServer:status == 1 ? NO : YES];
}

- (void)favoriteTemplateListDidChanged {
    [self.favoriteListData removeAllObjects];
    [self.favoriteListData addObjectsFromArray:[MGFavoriteTemplateModel mj_objectArrayWithKeyValuesArray:[MGGlobalManager shareInstance].favoriteTemplates]];
    [self.collectionView reloadData];
    if (self.favoriteListData.count <= 0) {
        self.collectionView.ly_emptyView = self.noDataView;
    }
    [self.collectionView ly_endLoading];
}

#pragma mark - reqeust
- (void)reqeustFavoriteListNeedIndicator:(BOOL)needIndicator requestServer:(BOOL)requestServer {
    [self.favoriteListData removeAllObjects];
    if ([MGGlobalManager shareInstance].isLoggedIn) {
        if (requestServer) {
            if (needIndicator) [self showLoading];
            NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
            [params setValue:[MGGlobalManager shareInstance].accountInfo.user_id forKey:@"user_id"];
            [params setValue:@(1) forKey:@"page"];
            [params setValue:@(3000) forKey:@"limit"];
            [LVHttpRequest get:@"/api/v1/getUserCollections" param:params header:@{} baseUrlType:CDHttpBaseUrlTypeMagina_ljw isNeedPublickParam:YES isNeedPublickHeader:YES isNeedEncryptHeader:YES isNeedEncryptParam:YES isNeedDecryptResponse:YES encryptType:CDHttpBaseUrlTypeMagina_ljw timeout:20.0 modelClass:nil completion:^(NSInteger status, NSString * _Nonnull message, id  _Nullable result, NSError * _Nullable error, id  _Nullable responseObject) {
                if (needIndicator) [self hideLoading];
                if (status != 1 || error) {
                    self.collectionView.ly_emptyView = self.noNetworkView;
                    [self.collectionView ly_endLoading];
                    return;
                }
                NSArray *resultArr = (NSArray *)result;
                if (resultArr.count > 0) {
                    [self.favoriteListData addObjectsFromArray:[MGFavoriteTemplateModel mj_objectArrayWithKeyValuesArray:resultArr]];
                    NSMutableArray *resultArrM = [resultArr mutableCopy];
                    [MGGlobalManager shareInstance].favoriteTemplates = resultArrM;
                    [resultArrM writeToFile:[MGGlobalManager shareInstance].favoriteTemplatesPath atomically:YES];
                }
                [self.collectionView reloadData];
                if (self.favoriteListData.count <= 0) {
                    self.collectionView.ly_emptyView = self.noDataView;
                }
                [self.collectionView ly_endLoading];
            }];
        } else {
            [self.favoriteListData addObjectsFromArray:[MGFavoriteTemplateModel mj_objectArrayWithKeyValuesArray:[MGGlobalManager shareInstance].favoriteTemplates]];
            [self.collectionView reloadData];
            if (self.favoriteListData.count <= 0) {
                self.collectionView.ly_emptyView = self.noDataView;
            }
            [self.collectionView ly_endLoading];
        }
    } else {
        [self.collectionView reloadData];
        if (self.favoriteListData.count <= 0) {
            self.collectionView.ly_emptyView = self.loginFirstView;
        }
        [self.collectionView ly_endLoading];
    }
}

- (void)requestTemplateDetailsWithID:(NSString *)ID {
    [self showLoading];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:[MGGlobalManager shareInstance].accountInfo.access_token forKey:@"access_token"];
    [params setValue:ID forKey:@"id"];
    [LVHttpRequest get:@"/magina-api/api/v1/get_template_product_info/" param:params header:@{} baseUrlType:CDHttpBaseUrlTypeMagina isNeedPublickParam:YES isNeedPublickHeader:YES isNeedEncryptHeader:YES isNeedEncryptParam:YES isNeedDecryptResponse:YES encryptType:CDHttpBaseUrlTypeMagina timeout:20.0 modelClass:nil completion:^(NSInteger status, NSString * _Nonnull message, id  _Nullable result, NSError * _Nullable error, id  _Nullable responseObject) {
        [self hideLoading];
        if (status != 1 || error) {
            [self.view makeToast:NSLocalizedString(@"global_request_error", nil)];
            return;
        }
        MGTemplateListModel *templateListModel = [MGTemplateListModel mj_objectWithKeyValues:result];
        if (templateListModel) {
            MGTemplateDetailsController *vc = [[MGTemplateDetailsController alloc] init];
            vc.templateModels = @[templateListModel];
            vc.currentTemplateIndex = 0;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }];
}

#pragma mark - UICollectionViewDelegate, UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.favoriteListData.count;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 110, 0);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat itemW = floorf((UI_SCREEN_W - 3) / 3);
    CGFloat itemH = floorf((itemW * 163) / 123);
    return CGSizeMake(itemW, itemH);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 1.5;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 1.5;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MGPhotoListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:MGPhotoListCellKey forIndexPath:indexPath];
    cell.favoriteModel = self.favoriteListData[indexPath.item];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    MGFavoriteTemplateModel *model = self.favoriteListData[indexPath.item];
    [self requestTemplateDetailsWithID:model.ID];
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
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:[[UICollectionViewFlowLayout alloc] init]];
        _collectionView.backgroundColor = [UIColor blackColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        [_collectionView registerNib:[UINib nibWithNibName:MGPhotoListCellKey bundle:nil] forCellWithReuseIdentifier:MGPhotoListCellKey];
    }
    return _collectionView;
}

- (UIActivityIndicatorView *)indicator {
    if (!_indicator) {
        _indicator = [[UIActivityIndicatorView alloc] init];
        _indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleMedium;
        _indicator.color = [UIColor lightGrayColor];
    }
    return _indicator;
}

- (NSMutableArray<MGFavoriteTemplateModel *> *)favoriteListData {
    if (!_favoriteListData) {
        _favoriteListData = [NSMutableArray array];
    }
    return _favoriteListData;
}

- (LVEmptyView *)noDataView {
    if (!_noDataView) {
        _noDataView = [LVEmptyView emptyViewWithImage:[UIImage imageNamed:@"noData_placeHolder"] titleStr:nil detailStr:nil];
    }
    return _noDataView;
}

- (LVEmptyView *)noNetworkView {
    if (!_noNetworkView) {
        _noNetworkView = [LVEmptyView emptyActionViewWithImage:nil titleStr:nil detailStr:nil btnTitleStr:NSLocalizedString(@"no_datad", nil) target:self action:@selector(reloadList)];
    }
    return _noNetworkView;
}

- (LVEmptyView *)loginFirstView {
    if (!_loginFirstView) {
        _loginFirstView = [LVEmptyView emptyActionViewWithImage:nil titleStr:nil detailStr:nil btnTitleStr:NSLocalizedString(@"no_datad", nil) target:self action:@selector(loginFisrtAction)];
    }
    return _loginFirstView;
}

- (NSValue *)toastPointValue {
    if (!_toastPointValue) {
        _toastPointValue = [NSValue valueWithCGPoint:CGPointMake(self.view.lv_width / 2, self.view.lv_height / 2 - 60)];
    }
    return _toastPointValue;
}

@end
