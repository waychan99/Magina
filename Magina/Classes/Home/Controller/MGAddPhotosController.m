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
#import "MGAlbumListView.h"
#import <HWPanModal/HWPanModal.h>

@interface MGAddPhotosController ()<HWPanModalPresentable, UICollectionViewDelegate, UICollectionViewDataSource> {
    NSTimer *_timer;
}
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLab;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UILabel *allPhotosLab;
@property (nonatomic, strong) NSMutableArray<MGAlbumModel *> *albumArrM;
@property (nonatomic, strong) MGAlbumModel *currentAlbumModel;
@end

@implementation MGAddPhotosController

#pragma mark - lifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUIComponents];
    
    if ([PHPhotoLibrary authorizationStatus] != PHAuthorizationStatusAuthorized) {
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {}];
        if ([PHPhotoLibrary authorizationStatus] == PHAuthorizationStatusNotDetermined) {
            _timer = [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(observeAuthrizationStatusChange) userInfo:nil repeats:NO];
        }
    } else {
        [self loadImageData];
    }
}

#pragma mark - setupUIComponents
- (void)setupUIComponents {
    self.customNavBar.hidden = YES;
    self.view.backgroundColor = HEX_COLOR(0x1E1F24);
    
    self.titleLab.text = NSLocalizedString(@"photo_uploadd", nil);
    self.subTitleLab.text = NSLocalizedString(@"photo_tipp", nil);
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = HEX_COLOR(0x1E1F24);
    [self.collectionView registerNib:[UINib nibWithNibName:MGAlbumPhotoListCellKey bundle:nil] forCellWithReuseIdentifier:MGAlbumPhotoListCellKey];
    [self.collectionView registerNib:[UINib nibWithNibName:MGAlbumTakePhotoCellKey bundle:nil] forCellWithReuseIdentifier:MGAlbumTakePhotoCellKey];
    
    self.allPhotosLab.userInteractionEnabled = YES;
    [self.allPhotosLab addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAllPhotoAction:)]];
}

#pragma mark - eventClick
- (IBAction)clickDismissBtn:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:^{}];
}

- (void)tapAllPhotoAction:(UIGestureRecognizer *)sender {
    if (self.albumArrM.count > 0) {
        [MGAlbumListView showFromView:sender.view albumList:self.albumArrM resultBlock:^(MGAlbumModel * _Nonnull albumModel) {
            self.currentAlbumModel = albumModel;
        } completion:nil];
    }
}

#pragma mark - observerAction
- (void)observeAuthrizationStatusChange {
    [_timer invalidate];
    _timer = nil;
    if ([PHPhotoLibrary authorizationStatus] == PHAuthorizationStatusNotDetermined) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(observeAuthrizationStatusChange) userInfo:nil repeats:NO];
    }
    if ([PHPhotoLibrary authorizationStatus] == PHAuthorizationStatusAuthorized) {
        [self loadImageData];
    }
}

#pragma mark - request
- (void)loadImageData {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [[MGImageManager shareInstance] getAllAlbumsWithFetchAssets:YES completion:^(NSArray<MGAlbumModel *> * _Nonnull models) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.albumArrM = [NSMutableArray arrayWithArray:models];
                for (MGAlbumModel *model in self.albumArrM) {
                    MGAssetModel *takePhotoModel = [[MGAssetModel alloc] init];
                    takePhotoModel.modelType = MGAssetModelTypeTakePhoto;
                    [model.models insertObject:takePhotoModel atIndex:0];
                    model.count += 1;
                    if (model.isCameraRoll) {
                        self.currentAlbumModel = model;
                    }
                }
                if (!self.currentAlbumModel && self.albumArrM.count > 0) {
                    self.currentAlbumModel = self.albumArrM.firstObject;
                }
            });
        }];
    });
}

#pragma mark - UICollectionViewDelegate, UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.currentAlbumModel.count;
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
    MGAssetModel *assetModel = self.currentAlbumModel.models[indexPath.item];
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
    MGAssetModel *assetModel = self.currentAlbumModel.models[indexPath.item];
    if (assetModel.modelType == MGAssetModelTypeNormal) {
        [[MGImageManager shareInstance] getPhotoWithAsset:assetModel.asset completion:^(UIImage * _Nonnull photo, NSDictionary * _Nonnull info, BOOL isDegraded) {
            if (!isDegraded) {
                [self dismissViewControllerAnimated:YES completion:^{
                    !self.selectedImageCallback ?: self.selectedImageCallback(photo);
                }];
            }
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

#pragma mark - setter
- (void)setCurrentAlbumModel:(MGAlbumModel *)currentAlbumModel {
    _currentAlbumModel = currentAlbumModel;

    self.allPhotosLab.text = currentAlbumModel.name;
    [self.collectionView reloadData];
}

#pragma mark - getter
- (NSMutableArray<MGAlbumModel *> *)albumArrM {
    if (!_albumArrM) {
        _albumArrM = [NSMutableArray array];
    }
    return _albumArrM;
}

@end
