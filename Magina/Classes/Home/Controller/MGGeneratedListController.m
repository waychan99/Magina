//
//  MGGeneratedListController.m
//  Magina
//
//  Created by mac on 2025/8/27.
//

#import "MGGeneratedListController.h"
#import "MGGeneratedDetailsController.h"
#import "MGGeneratedListCell.h"

@interface MGGeneratedListController ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView *collectionView;
@end

@implementation MGGeneratedListController

#pragma mark - liftCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(imageWorksDidChange) name:MG_IMAGE_WORKS_DID_CHANGED_NOTI object:nil];
    
    [self setupUIComponents];
    if (self.needDownload) [self downloadImage];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - override
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    self.collectionView.frame = CGRectMake(0, self.customNavBar.lv_bottom, self.view.lv_width, self.view.lv_height - self.customNavBar.lv_bottom);
}

#pragma mark - setupUIComponents
- (void)setupUIComponents {
    self.customNavBar.title = NSLocalizedString(@"Generated Records", nil);
    [self.view addSubview:self.collectionView];
}

#pragma mark - notification
- (void)imageWorksDidChange {
    [self.collectionView reloadData];
}

#pragma mark - request
- (void)downloadImage {
    [[MGImageWorksManager shareInstance] downloadImageWorksModel:self.worksModel completion:^(MGImageWorksModel * _Nonnull imageWorksModel) {
        [self.collectionView reloadData];
    }];
}

#pragma mark - UICollectionViewDelegate, UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.worksModel.generatedImageWorksCount;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 5, 10, 5);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat itemW = floorf((UI_SCREEN_W - 15) / 2);
    CGFloat itemH = floorf((itemW * 240) / 180);
    return CGSizeMake(itemW, itemH);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 5;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 5;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MGGeneratedListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:MGGeneratedListCellKey forIndexPath:indexPath];
    cell.tag = indexPath.item;
    cell.worksModel = self.worksModel;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.worksModel.isDownloaded) {
        MGGeneratedDetailsController *vc = [[MGGeneratedDetailsController alloc] init];
        vc.worksModel = self.worksModel;
        vc.currentIndex = indexPath.item;
        [self.navigationController pushViewController:vc animated:YES];
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
        [_collectionView registerNib:[UINib nibWithNibName:MGGeneratedListCellKey bundle:nil] forCellWithReuseIdentifier:MGGeneratedListCellKey];
    }
    return _collectionView;
}

@end
