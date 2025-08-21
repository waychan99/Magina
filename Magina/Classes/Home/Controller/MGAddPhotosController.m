//
//  MGAddPhotosController.m
//  Magina
//
//  Created by mac on 2025/8/19.
//

#import "MGAddPhotosController.h"
#import "MGAlbumPhotoListCell.h"
#import "MGAlbumTakePhotoCell.h"
#import "MGImageManager.h"
#import "MGAssetModel.h"
#import <HWPanModal/HWPanModal.h>

@interface MGAddPhotosController ()<HWPanModalPresentable, UICollectionViewDelegate, UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) MGAlbumModel *albumModel;
@end

@implementation MGAddPhotosController

#pragma mark - lifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUIComponents];
    
    [[MGImageManager shareInstance] getCameraRollAlbumWithFetchAssets:YES completion:^(MGAlbumModel * _Nonnull model) {
        self->_albumModel = model;
        MGAssetModel *takePhotoModel = [[MGAssetModel alloc] init];
        takePhotoModel.modelType = MGAssetModelTypeTakePhoto;
        [self->_albumModel.models insertObject:takePhotoModel atIndex:0];
        self->_albumModel.count += 1;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.collectionView reloadData];
        });
    }];
}

#pragma mark - setupUIComponents
- (void)setupUIComponents {
    self.customNavBar.hidden = YES;
    self.view.backgroundColor = HEX_COLOR(0x1E1F24);
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = HEX_COLOR(0x1E1F24);
    [self.collectionView registerNib:[UINib nibWithNibName:MGAlbumPhotoListCellKey bundle:nil] forCellWithReuseIdentifier:MGAlbumPhotoListCellKey];
    [self.collectionView registerNib:[UINib nibWithNibName:MGAlbumTakePhotoCellKey bundle:nil] forCellWithReuseIdentifier:MGAlbumTakePhotoCellKey];
}

#pragma mark - eventClick
- (IBAction)clickDismissBtn:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:^{}];
}

#pragma mark - UICollectionViewDelegate, UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.albumModel.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat itemWH = floorf((self.collectionView.lv_width - 10) / 4);
    return CGSizeMake(itemWH, itemWH);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 2;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 2;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 2, 0, 2);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MGAssetModel *assetModel = self.albumModel.models[indexPath.item];
    if (assetModel.modelType == MGAssetModelTypeNormal) {
        MGAlbumPhotoListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:MGAlbumPhotoListCellKey forIndexPath:indexPath];
        cell.assetModel = assetModel;
        return cell;
    } else {
        MGAlbumTakePhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:MGAlbumTakePhotoCellKey forIndexPath:indexPath];
        cell.assetModel = assetModel;
        return cell;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    MGAssetModel *assetModel = self.albumModel.models[indexPath.item];
    if (assetModel.modelType == MGAssetModelTypeNormal) {
        [[MGImageManager shareInstance] getPhotoWithAsset:assetModel.asset completion:^(UIImage * _Nonnull photo, NSDictionary * _Nonnull info, BOOL isDegraded) {
            LVLog(@"fffff --- %@ -- %i", photo, isDegraded);
        }];
    } else {
        [self dismissViewControllerAnimated:YES completion:^{
            !self.dismissCallback ?: self.dismissCallback();
        }];
    }
}

#pragma mark - HWPanModalPresentable
- (BOOL)shouldRespondToPanModalGestureRecognizer:(nonnull UIPanGestureRecognizer *)panGestureRecognizer {
    return NO;
}

- (BOOL)showDragIndicator {
    return NO;
}

- (BOOL)allowsTapBackgroundToDismiss {
    return YES;
}

- (PanModalHeight)longFormHeight {
    return PanModalHeightMake(PanModalHeightTypeMaxTopInset, 60);
}

- (CGFloat)cornerRadius {
    return 20.0f;
}

@end
