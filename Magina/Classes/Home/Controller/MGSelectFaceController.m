//
//  MGSelectFaceController.m
//  Magina
//
//  Created by 陈志伟 on 2025/8/23.
//

#import "MGSelectFaceController.h"
#import "MGSelectFaceCell.h"

@interface MGSelectFaceController ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UIImageView *displayImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@end

@implementation MGSelectFaceController

#pragma mark - lifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = [UIColor colorWithWhite:.0 alpha:.0];
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.collectionView.collectionViewLayout = layout;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    [self.collectionView registerNib:[UINib nibWithNibName:MGSelectFaceCellKey bundle:nil] forCellWithReuseIdentifier:MGSelectFaceCellKey];
    
    [self setupUIComponents];
}

#pragma mark - UICollectionViewDelegate, UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.imageList.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(59, 59);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 25, 0, 25);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MGSelectFaceCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:MGSelectFaceCellKey forIndexPath:indexPath];
    UIImage *image = (UIImage *)self.imageList[indexPath.row];
    cell.contentImageView.image = image;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = (UIImage *)self.imageList[indexPath.row];
    !self.selectedImageCallback ?: self.selectedImageCallback(image);
}

#pragma mark - setupUIComponents
- (void)setupUIComponents {
    
    self.displayImageView.image = self.originImage;
    self.titleLab.text = NSLocalizedString(@"Please select a facial image", nil);
}


@end
