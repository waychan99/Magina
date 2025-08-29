//
//  MGGeneratedDetailsController.m
//  Magina
//
//  Created by mac on 2025/8/28.
//

#import "MGGeneratedDetailsController.h"
#import "MGReviewImageController.h"
#import "MGReviewImageCell.h"
#import "NSString+LP.h"
#import <PhotosUI/PhotosUI.h>

@interface MGGeneratedDetailsController ()<UICollectionViewDelegate, UICollectionViewDataSource, MGReviewImageCellDelegate>
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;
@property (weak, nonatomic) IBOutlet UIButton *saveBtn;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) UIActivityIndicatorView *deleteActionIndicator;
@property (nonatomic, assign) BOOL isFirstLoad;
@end

@implementation MGGeneratedDetailsController

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
    
    self.collectionView.frame = CGRectMake(0, 0, self.view.lv_width, self.saveBtn.lv_y - 24);
    self.pageControl.frame = CGRectMake((self.view.lv_width - 60) / 2, self.saveBtn.lv_y - 74, 60, 24);
    self.deleteActionIndicator.frame = self.deleteBtn.bounds;
    
    if (self.isFirstLoad) {
        self.isFirstLoad = NO;
        if (self.worksModel.generatedImageWorksCount > 0 && self.currentIndex < self.worksModel.generatedImageWorksCount) {
            [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.currentIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
        }
    }
}

#pragma mark - setupUIComponents
- (void)setupUIComponents {
    self.deleteBtn.backgroundColor = [UIColor colorWithWhite:0.4 alpha:0.3];
    [self.saveBtn setTitle:NSLocalizedString(@"Save", nil) forState:UIControlStateNormal];
    
    [self.view addSubview:self.collectionView];
    self.pageControl.numberOfPages = self.worksModel.generatedImageWorksCount;
    [self.view addSubview:self.pageControl];
    self.pageControl.currentPage = self.currentIndex;
    
    [self.view bringSubviewToFront:self.customNavBar];
}

#pragma mark - evnetClick
- (IBAction)clickSaveBtn:(UIButton *)sender {
    if (self.currentIndex < self.worksModel.generatedImageWorksList.count) {
        NSString *imageName = [self.worksModel.downloadedImagePathInfo objectForKey:self.worksModel.generatedImageWorksList[self.currentIndex]];
        if (imageName.length > 0) {
            NSString *imagePath = [NSString lp_documentFilePathWithFileName:[NSString stringWithFormat:@"%@/%@", MG_IMAGE_WORKS_FILES_DIRECTORY_PATH, imageName]];
            UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
            UIImage *waterMarkImage = [self addWatermarkToImage:image withImage:[UIImage imageNamed:@"MG_home_topBar_logo_icon"]];
            [self saveImageToAlbum:waterMarkImage];
        }
    }
}

- (IBAction)clickDeleteBtn:(UIButton *)sender {
    [self showLoading];
    [LVAlertView showAlertViewWithTitle:NSLocalizedString(@"确认删除作品", nil) buttonTitle:NSLocalizedString(@"confirm", nil) confirmBlock:^(int index) {
        if (index == 0) {
            if (self.currentIndex < self.worksModel.generatedImageWorksList.count) {
                [self.worksModel.downloadedImagePathInfo removeObjectForKey:self.worksModel.generatedImageWorksList[self.currentIndex]];
                [self.worksModel.generatedImageWorksList removeObjectAtIndex:self.currentIndex];
                self.worksModel.generatedImageWorksCount -= 1;
                if (self.worksModel.generatedImageWorksList.count > 0) {
                    self.currentIndex = 0;
                    [self.collectionView reloadData];
                    [[NSNotificationCenter defaultCenter] postNotificationName:MG_IMAGE_WORKS_DID_CHANGED_NOTI object:nil];
                } else {
                    [[MGImageWorksManager shareInstance].imageWorks removeObject:self.worksModel];
                }
                [[MGImageWorksManager shareInstance] saveImageWorksCompletion:^(NSMutableArray<MGImageWorksModel *> * _Nonnull imageWorks) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self hideLoading];
                        if (self.worksModel.generatedImageWorksList.count <= 0) {
                            [[NSNotificationCenter defaultCenter] postNotificationName:MG_IMAGE_WORKS_LIST_DID_CHANGED_NOTI object:nil];
                            [self.navigationController popToRootViewControllerAnimated:YES];
                        }
                    });
                }];
            }
        } else {
            [self hideLoading];
        }
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

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView == self.collectionView) {
        CGPoint pInView = [self.view convertPoint:self.collectionView.center toView:self.collectionView];
        NSIndexPath *indexPathNow = [self.collectionView indexPathForItemAtPoint:pInView];
        self.currentIndex = indexPathNow.item;
        self.pageControl.currentPage = self.currentIndex;
    }
}

#pragma mark - MGReviewImageCellDelegate
- (void)didClickedReviewImageCell:(MGReviewImageCell *)reviewImageCell index:(NSInteger)index {
    MGReviewImageController *vc = [[MGReviewImageController alloc] init];
    vc.currentIndex = self.currentIndex;
    vc.worksModel = self.worksModel;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - assistMethod
- (void)saveImageToAlbum:(UIImage *)image {
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^ {
        [PHAssetChangeRequest creationRequestForAssetFromImage:image];
    } completionHandler:^(BOOL success, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (success) {
                [self.view makeToast:NSLocalizedString(@"picture_save_success", nil)];
            } else {
                [self.view makeToast:NSLocalizedString(@"image_save_fail", nil)];
            }
        });
    }];
}

// 添加图片水印
- (UIImage *)addWatermarkToImage:(UIImage *)image withImage:(UIImage *)watermark {
    UIGraphicsBeginImageContextWithOptions(image.size, NO, image.scale);
    // 绘制原始图片
    [image drawAtPoint:CGPointZero];
    // 计算水印大小和位置（右下角）
    CGFloat watermarkSize = image.size.width * 0.15; // 水印大小为原图的15%
    CGFloat margin = image.size.width * 0.02;
    CGRect watermarkRect = CGRectMake(
        image.size.width - watermarkSize - margin,
        image.size.height - watermarkSize - margin,
        watermarkSize,
        watermarkSize
    );
    // 绘制水印图片
    [watermark drawInRect:watermarkRect blendMode:kCGBlendModeNormal alpha:0.5]; // 设置透明度
    // 获取处理后的图片
    UIImage *watermarkedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return watermarkedImage;
}

- (void)showLoading {
    if (self.deleteActionIndicator.superview == nil || self.deleteActionIndicator.superview != self.deleteBtn) {
        [self.deleteBtn addSubview:self.deleteActionIndicator];
        [self.deleteBtn bringSubviewToFront:self.deleteActionIndicator];
        [self.deleteActionIndicator startAnimating];
    }
}

- (void)hideLoading {
    if (self.deleteActionIndicator.superview) {
        [self.deleteActionIndicator stopAnimating];
        [self.deleteActionIndicator removeFromSuperview];
    }
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

- (UIPageControl *)pageControl {
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc] init];
        _pageControl.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.2];
        _pageControl.pageIndicatorTintColor = [UIColor darkGrayColor];
        _pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
        _pageControl.layer.cornerRadius = 12.0f;
    }
    return _pageControl;
}

- (UIActivityIndicatorView *)deleteActionIndicator {
    if (!_deleteActionIndicator) {
        _deleteActionIndicator = [[UIActivityIndicatorView alloc] init];
        _deleteActionIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleLarge;
        _deleteActionIndicator.color = HEX_COLOR(0xEA4C89);
    }
    return _deleteActionIndicator;
}

@end
