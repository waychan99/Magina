//
//  MGPointsListController.m
//  Magina
//
//  Created by mac on 2025/8/18.
//

#import "MGPointsListController.h"
#import "MGPointsListCell.h"

@interface MGPointsListController ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView *pointsListView;
@end

@implementation MGPointsListController

#pragma mark - lifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUIComponents];
}

#pragma mark - setupUIComponents
- (void)setupUIComponents {
    self.customNavBar.title = NSLocalizedString(@"points_detail", nil);
    [self.view addSubview:self.pointsListView];
}

#pragma mark - override
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    CGFloat selfW = self.view.lv_width;
    CGFloat selfH = self.view.lv_height;
    CGFloat pointsListViewY = self.customNavBar.lv_bottom + 15;
    self.pointsListView.frame = CGRectMake(20, pointsListViewY, selfW - 40, selfH - pointsListViewY);
}

#pragma mark - UICollectionViewDelegate, UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 50;
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
    if (indexPath.row == 0) {
        pointsListCell.contentView.frame = CGRectMake(20, 0, pointsListCell.contentView.lv_width, 71);
        [pointsListCell.contentView lp_setImageWithRadius:LPRadiusMake(15, 15, 0, 0) image:nil borderColor:nil borderWidth:0 backgroundColor:HEX_COLOR(0x15161A) contentMode:0 forState:0 completion:nil];
    } else if (indexPath.row == 49) {
        pointsListCell.contentView.frame = CGRectMake(20, 0, pointsListCell.contentView.lv_width, 71);
        [pointsListCell.contentView lp_setImageWithRadius:LPRadiusMake(0, 0, 15, 15) image:nil borderColor:nil borderWidth:0 backgroundColor:HEX_COLOR(0x15161A) contentMode:0 forState:0 completion:nil];
    } else {
        pointsListCell.contentView.backgroundColor = HEX_COLOR(0x15161A);
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

//- (LVEmptyView *)noDataView {
//    if (!_noDataView) {
//        _noDataView = [LVEmptyView emptyViewWithImage:[UIImage imageNamed:@"noData_placeHolder"] titleStr:nil detailStr:nil];
//    }
//    return _noDataView;
//}
//
//- (LVEmptyView *)noNetworkView {
//    if (!_noNetworkView) {
//        _noNetworkView = [LVEmptyView emptyActionViewWithImage:nil titleStr:NSLocalizedString(@"no_data_yet", nil) detailStr:nil btnTitleStr:NSLocalizedString(@"reload", nil) target:self action:@selector(reloadList)];
//    }
//    return _noNetworkView;
//}


@end
