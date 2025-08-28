//
//  MGPhotoListController.m
//  Magina
//
//  Created by 陈志伟 on 2025/8/21.
//

#import "MGPhotoListController.h"
#import "MGGeneratedListController.h"
#import "MGPhotoListCell.h"
#import "LVEmptyView.h"

@interface MGPhotoListController ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray<MGImageWorksModel *> *worksModelData;
@property (nonatomic, strong) LVEmptyView *noDataView;
@property (nonatomic, strong) LVEmptyView *loginFirstView;
@end

@implementation MGPhotoListController

#pragma mark - lifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestData) name:MG_IMAGE_WORKS_DID_DOWNLOADED_NOTI object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestData) name:MG_IMAGE_WORKS_LIST_DID_CHANGED_NOTI object:nil];
    
    [self setupUIComponents];
    [self requestData];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - override
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    self.collectionView.frame = self.view.bounds;
}

#pragma mark - setupUIComponents
- (void)setupUIComponents {
    [self.view addSubview:self.collectionView];
}

#pragma mark - request
- (void)requestData {
    [self.collectionView ly_startLoading];
    [self.worksModelData removeAllObjects];
    if ([MGGlobalManager shareInstance].isLoggedIn) {
        NSMutableArray *localData = [MGImageWorksManager shareInstance].imageWorks;
        for (MGImageWorksModel *worksModel in localData) {
            if (worksModel.isDownloaded) {
                [self.worksModelData addObject:worksModel];
            }
        }
        [self.collectionView reloadData];
        if (self.worksModelData.count <= 0) {
            self.collectionView.ly_emptyView = self.noDataView;
        }
        [self.collectionView ly_endLoading];
    } else {
        [self.collectionView reloadData];
        if (self.worksModelData.count <= 0) {
            self.collectionView.ly_emptyView = self.loginFirstView;
        }
        [self.collectionView ly_endLoading];
    }
}

#pragma mark - UICollectionViewDelegate, UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.worksModelData.count;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 10, 0);
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
    cell.worksModel = self.worksModelData[indexPath.item];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    MGGeneratedListController *vc = [[MGGeneratedListController alloc] init];
    vc.needDownload = YES;
    vc.worksModel = self.worksModelData[indexPath.item];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - JXPagerViewListViewDelegate
- (UIView *)listView {
    return self.view;
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

- (NSMutableArray<MGImageWorksModel *> *)worksModelData {
    if (!_worksModelData) {
        _worksModelData = [NSMutableArray array];
    }
    return _worksModelData;
}

- (LVEmptyView *)noDataView {
    if (!_noDataView) {
        _noDataView = [LVEmptyView emptyViewWithImage:[UIImage imageNamed:@"noData_placeHolder"] titleStr:nil detailStr:nil];
    }
    return _noDataView;
}

- (LVEmptyView *)loginFirstView {
    if (!_loginFirstView) {
        _loginFirstView = [LVEmptyView emptyActionViewWithImage:nil titleStr:nil detailStr:nil btnTitleStr:NSLocalizedString(@"请登录", nil) target:self action:@selector(loginFisrtAction)];
    }
    return _loginFirstView;
}

@end
