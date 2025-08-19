//
//  MGMemberListController.m
//  Magina
//
//  Created by mac on 2025/8/19.
//

#import "MGMemberListController.h"
#import "MGMineListCell.h"

@interface MGMemberListController ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView *collectionView;
@end

@implementation MGMemberListController

#pragma mark - lifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blueColor];
    
    [self setupUIComponents];
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

#pragma mark - UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 1;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 10, 0);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat itemW = floorf((UI_SCREEN_W - 1.5) / 3);
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
    MGMineListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:MGMineListCellKey forIndexPath:indexPath];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
 
}

#pragma mark - JXPagerViewListViewDelegate
- (UIView *)listView {
    return self.view;
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
        _collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        [_collectionView registerNib:[UINib nibWithNibName:MGMineListCellKey bundle:nil] forCellWithReuseIdentifier:MGMineListCellKey];
    }
    return _collectionView;
}

@end
