//
//  MGReviewImageController.m
//  Magina
//
//  Created by mac on 2025/8/29.
//

#import "MGReviewImageController.h"
#import "MGReviewImageCell.h"

@interface MGReviewImageController ()<UICollectionViewDelegate, UICollectionViewDataSource, MGReviewImageCellDelegate>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, assign) BOOL isFirstLoad;
@end

@implementation MGReviewImageController

#pragma mark - lifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
 
    self.isFirstLoad = YES;
    [self setupUIComponents];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    MGReviewImageCell *imageCell = (MGReviewImageCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:self.currentIndex inSection:0]];
    imageCell.cellZoomScale = MINZOOMSCALE;
}

#pragma mark - override
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    self.collectionView.frame = self.view.bounds;
    
    if (self.isFirstLoad) {
        self.isFirstLoad = NO;
        if (self.worksModel.generatedImageWorksCount > 0 && self.currentIndex < self.worksModel.generatedImageWorksCount) {
            [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.currentIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
        }
    }
}

#pragma mark - setupUIComponents
- (void)setupUIComponents {
    self.customNavBar.hidden = YES;
    [self.view addSubview:self.collectionView];
}

#pragma mark - UICollectionViewDelegate, UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.worksModel.generatedImageWorksCount;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(self.collectionView.lv_width, self.collectionView.lv_height);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MGReviewImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:MGReviewImageCellKey forIndexPath:indexPath];
    cell.delegate = self;
    cell.tag = indexPath.item;
    cell.worksModel = self.worksModel;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    MGReviewImageCell *imageCell = (MGReviewImageCell*)cell;
    imageCell.cellZoomScale = MINZOOMSCALE;
}

#pragma mark - MGReviewImageCellDelegate
- (void)didClickedReviewImageCell:(MGReviewImageCell *)reviewImageCell index:(NSInteger)index {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - getter
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor blackColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.pagingEnabled = YES;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        [_collectionView registerClass:[MGReviewImageCell class] forCellWithReuseIdentifier:MGReviewImageCellKey];
    }
    return _collectionView;
}

@end
