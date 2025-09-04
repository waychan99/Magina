//
//  MGTemplateDetailsController.m
//  Magina
//
//  Created by mac on 2025/8/19.
//

#import "MGTemplateDetailsController.h"
#import "MGAddPhotosController.h"
#import "MGShotController.h"
#import "MGSelectFaceController.h"
#import "MGProductionController.h"
#import "MGReviewImageController.h"
#import "MGFaceResultCell.h"
#import "MGTemplateDetailsCell.h"
#import "MGProductionLoading.h"
#import "MGTemplateListModel.h"
#import "MGFaceRecognition.h"
#import "SPButton.h"
#import "NSString+LP.h"
#import <HWPanModal/HWPanModal.h>
#import <Photos/Photos.h>

@interface MGTemplateDetailsController ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) UILabel *pointsLab;
@property (nonatomic, strong) UIImageView *pointsImageView;
@property (nonatomic, strong) MGProductionLoading *productionLoading;
@property (nonatomic, strong) UIActivityIndicatorView *collectionIndicator;
@property (weak, nonatomic) IBOutlet UICollectionView *templateCollectionView;
@property (weak, nonatomic) IBOutlet UIView *btnBgView;
@property (weak, nonatomic) IBOutlet UIButton *standardBtn;
@property (weak, nonatomic) IBOutlet UIButton *fatBtn;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UIImageView *addPhotoImageView;
@property (weak, nonatomic) IBOutlet UICollectionView *avatarCollectionView;
@property (weak, nonatomic) IBOutlet UIButton *collectBtn;
@property (weak, nonatomic) IBOutlet SPButton *photographBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *templateCollectionViewTop;
@property (nonatomic, assign) NSInteger currentFaceIndex;
@property (nonatomic, assign) NSInteger bodyTye;/** 0:标准   1:肥胖 */
@property (nonatomic, assign) BOOL isFirstLoad;
@property (nonatomic, weak) MGGlobalManager *globalManager;
@end

@implementation MGTemplateDetailsController

#pragma mark - lifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.isFirstLoad = YES;
    
    [self setupUIComponents];
    
    if ([MGGlobalManager shareInstance].sse_url.length <= 0) {
        [[MGGlobalManager shareInstance] requestSseConfig];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.isFirstLoad) {
        self.isFirstLoad = NO;
        [self.templateCollectionView setNeedsLayout];
        [self.templateCollectionView layoutIfNeeded];
        
        if (self.templateModels.count > 0 && self.currentTemplateIndex < self.templateModels.count) {
            [self.templateCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.currentTemplateIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
        }
    }
}

- (void)dealloc {
    [[SDImageCache sharedImageCache] clearMemory];
    [[SDImageCache sharedImageCache] clearDiskOnCompletion:nil];
}

#pragma mark - setupUIComponents
- (void)setupUIComponents {
    self.view.backgroundColor = [UIColor blackColor];
    
    [self.customNavBar addSubview:self.pointsLab];
    [self.customNavBar addSubview:self.pointsImageView];
    
    self.btnBgView.backgroundColor = [UIColor colorWithWhite:.3 alpha:.4];
    self.titleLab.text = NSLocalizedString(@"recently_usedd", nil);
    [self.photographBtn setTitle:[NSString stringWithFormat:@"10 %@", NSLocalizedString(@"photographh", nil)] forState:UIControlStateNormal];
    [self.photographBtn setImage:[UIImage imageNamed:@"MG_home_topbar_points_icon"] forState:UIControlStateNormal];
    [self.photographBtn setImage:[UIImage imageNamed:@"MG_home_topbar_points_icon"] forState:UIControlStateHighlighted];
    [self.addPhotoImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAddPhotoImageView:)]];
    
    self.templateCollectionView.layer.cornerRadius = 17.0f;
    self.templateCollectionView.delegate = self;
    self.templateCollectionView.dataSource = self;
    self.templateCollectionView.backgroundColor = [UIColor colorWithWhite:.0 alpha:.0];
    self.templateCollectionView.showsVerticalScrollIndicator = NO;
    self.templateCollectionView.pagingEnabled = YES;
    [self.templateCollectionView registerNib:[UINib nibWithNibName:MGTemplateDetailsCellKey bundle:nil] forCellWithReuseIdentifier:MGTemplateDetailsCellKey];
    
    self.avatarCollectionView.delegate = self;
    self.avatarCollectionView.dataSource = self;
    self.avatarCollectionView.backgroundColor = [UIColor colorWithWhite:.0 alpha:.0];
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.avatarCollectionView.collectionViewLayout = layout;
    self.avatarCollectionView.showsHorizontalScrollIndicator = NO;
    [self.avatarCollectionView registerNib:[UINib nibWithNibName:MGFaceResultCellKey bundle:nil] forCellWithReuseIdentifier:MGFaceResultCellKey];
    
    if ([MGGlobalManager shareInstance].isLoggedIn) {
        NSArray *ids = [[MGGlobalManager shareInstance].favoriteTemplates valueForKeyPath:@"id"];
        ids = [ids valueForKey:@"stringValue"];
        MGTemplateListModel *currentModel = [self.templateModels objectAtIndex:self.currentTemplateIndex];
        if ([ids containsObject:currentModel.ID]) {
            self.collectBtn.selected = YES;
        } else {
            self.collectBtn.selected = NO;
        }
    } else {
        self.collectBtn.selected = NO;
    }
    
    @lv_weakify(self)
    [self.KVOController observe:[MGGlobalManager shareInstance] keyPath:@"currentPoints" options:NSKeyValueObservingOptionNew block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSString *,id> * _Nonnull change) {
        @lv_strongify(self)
        self.pointsLab.text = [NSString stringWithFormat:@"%.0f", [MGGlobalManager shareInstance].currentPoints];
        [self.pointsLab sizeToFit];
        [self setupPointsUIComponentsFrame];
    }];
}

#pragma mark - override
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    [self setupPointsUIComponentsFrame];
}

- (void)setupPointsUIComponentsFrame {
    CGFloat selfW = self.view.lv_width;
    CGFloat pointsLabX = selfW - 20 - self.pointsLab.lv_width;
    self.pointsLab.frame = CGRectMake(pointsLabX, 0, self.pointsLab.lv_width, 17);
    self.pointsLab.lv_centerY = self.wrNaviBar_leftButton.lv_centerY;
    CGFloat pointsImageViewX = self.pointsLab.lv_x - 5 - 18;
    self.pointsImageView.frame = CGRectMake(pointsImageViewX, 0, 18, 17);
    self.pointsImageView.lv_centerY = self.wrNaviBar_leftButton.lv_centerY;
    self.collectionIndicator.frame = self.collectBtn.bounds;
}

- (void)updateViewConstraints {
    [super updateViewConstraints];
    
    self.templateCollectionViewTop.constant = self.customNavBar.lv_height;
}

#pragma mark - eventClick
- (void)tapAddPhotoImageView:(UIGestureRecognizer *)sender {
    [self openAddPhotosVc];
}

- (IBAction)clickPhotographBtn:(SPButton *)sender {
    [self uploadFaceAndMakingPicture];
}

- (IBAction)clickCollectBtn:(UIButton *)sender {
    if (![MGGlobalManager shareInstance].isLoggedIn) {
        [self.view makeToast:NSLocalizedString(@"global_request_error", nil)];
        return;
    }
    [self templateCollectionRequestWithIsCollection:!sender.isSelected];
}

- (IBAction)clickStandardBtn:(UIButton *)sender {
    sender.backgroundColor = HEX_COLOR(0xEA4C89);
    self.fatBtn.backgroundColor = [UIColor colorWithWhite:.0 alpha:.0];
    if (self.bodyTye != 0) {
        self.bodyTye = 0;
        MGTemplateDetailsCell *detailsCell = (MGTemplateDetailsCell *)[self.templateCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:self.currentTemplateIndex inSection:0]];
        MGTemplateListModel *currentModel = [self.templateModels objectAtIndex:self.currentTemplateIndex];
        [detailsCell loadImageWithUrlString:currentModel.standardImgs.firstObject];
    }
}

- (IBAction)clickFatBtn:(UIButton *)sender {
    sender.backgroundColor = HEX_COLOR(0xEA4C89);
    self.standardBtn.backgroundColor = [UIColor colorWithWhite:.0 alpha:.0];
    if (self.bodyTye != 1) {
        self.bodyTye = 1;
        MGTemplateDetailsCell *detailsCell = (MGTemplateDetailsCell *)[self.templateCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:self.currentTemplateIndex inSection:0]];
        MGTemplateListModel *currentModel = [self.templateModels objectAtIndex:self.currentTemplateIndex];
        [detailsCell loadImageWithUrlString:currentModel.fatImgs.firstObject];
    }
}

#pragma mark - request
- (void)templateCollectionRequestWithIsCollection:(BOOL)isCollection {
    [self showLoading];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:[MGGlobalManager shareInstance].accountInfo.user_id forKey:@"user_id"];
    [params setValue:isCollection ? @"1" : @"0" forKey:@"collection_type"];
    MGTemplateListModel *currentModel = [self.templateModels objectAtIndex:self.currentTemplateIndex];
    [params setValue:currentModel.ID forKey:@"template_id"];
    [params setValue:currentModel.change_face_thumbnai forKey:@"template_img"];
    [LVHttpRequest post:@"/api/v1/collection" param:params header:@{} baseUrlType:CDHttpBaseUrlTypeMagina_ljw isNeedPublickParam:YES isNeedPublickHeader:YES isNeedEncryptHeader:YES isNeedEncryptParam:YES isNeedDecryptResponse:YES encryptType:CDHttpBaseUrlTypeMagina_ljw timeout:20.0 modelClass:nil completion:^(NSInteger status, NSString * _Nonnull message, id  _Nullable result, NSError * _Nullable error, id  _Nullable responseObject) {
        [self hideLoading];
        if (status != 1 || error) {
            [self.view makeToast:NSLocalizedString(@"global_request_error", nil)];
            return;
        }
        NSDictionary *resultDict = @{@"id" : currentModel.ID, @"template_img" : currentModel.change_face_thumbnai};
        if (isCollection) {
            [[MGGlobalManager shareInstance] saveFavoriteTemplateRecord:resultDict];
        } else {
            [[MGGlobalManager shareInstance] deleteFavoriteTemplateRecord:resultDict];
        }
        self.collectBtn.selected = isCollection;
        [[NSNotificationCenter defaultCenter] postNotificationName:MG_FAVORITE_TEMPLATE_LIST_DID_CHANGED object:nil];
    }];
}

- (void)uploadFaceAndMakingPicture {
    if (![MGGlobalManager shareInstance].isLoggedIn) {
        [self.view makeToast:NSLocalizedString(@"global_request_error", nil)];
        return;
    }
    
    if ([MGGlobalManager shareInstance].currentPoints >= 10) {
        [MGGlobalManager shareInstance].currentPoints -= 10;
    } else {
        [self.view makeToast:NSLocalizedString(@"insufficient_points", nil)];
        return;
    }
    
    UIImage *faceImage = nil;
    if (self.currentFaceIndex <= self.globalManager.faceImageRecords.count && self.globalManager.faceImageRecords.count > 0) {
        NSString *imageName = self.globalManager.faceImageRecords[self.currentFaceIndex];
        NSString *imagePath = [self.globalManager.faceImageDataFileDirPath stringByAppendingPathComponent:imageName];
        faceImage = [UIImage imageWithContentsOfFile:imagePath];
    }
    if (!faceImage) {
        [self.view makeToast:NSLocalizedString(@"not_facee", nil)];
        return;
    }
    [self.productionLoading show];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:[MGGlobalManager shareInstance].accountInfo.user_id forKey:@"user_id"];
    params = [LVHttpRequestHelper dict:params byAppendingDict:[LVHttpRequestHelper getPublicParam]];
    params = [LVHttpRequestHelper paramEncryption:params keyType:CDHttpBaseUrlTypeMagina_ljw];
    long long currentTimeStamp = (long long)([[NSDate date] timeIntervalSince1970] * 1000);
    NSData *imageData = UIImageJPEGRepresentation(faceImage, 1.0);
    LVUploadParam *uploadParam = [[LVUploadParam alloc] initWithData:imageData paramName:@"image" fileName:[NSString stringWithFormat:@"%lld_faceImage.png", currentTimeStamp] mineType:@"image/jpeg"];
    NSString *imageUploadPath = [NSString stringWithFormat:@"%@%@", kLjwMaginaService, @"/api/v1/upload"];
    [LVHttpRequest upload:imageUploadPath param:params header:@{} uploadParam:uploadParam success:^(id  _Nonnull result) {
        if ([result[@"status"] intValue] != 1 || !result[@"data"]) {
            [self.productionLoading dismiss];
            [self.view makeToast:result[@"msg"]];
            return;
        }
        NSString *resultUrl = result[@"data"][@"url"];
        NSMutableDictionary *postParmas = [NSMutableDictionary dictionary];
        [postParmas setValue:[MGGlobalManager shareInstance].accountInfo.user_id forKey:@"user_id"];
        [postParmas setValue:resultUrl forKey:@"source_img"];
        NSMutableArray *imagesArrM = [NSMutableArray array];
        if (self.currentTemplateIndex < self.templateModels.count) {
            MGTemplateListModel *templateModel = [self.templateModels objectAtIndex:self.currentTemplateIndex];
            NSArray *templatedArr = templateModel.standardImgs;
            if (self.bodyTye == 1) {
                templatedArr = templateModel.fatImgs;
            }
            if (templatedArr.count > 0) {
                if (templatedArr.count == 1) {
                    NSString *firstImageUrl = templatedArr.firstObject;
                    [imagesArrM addObject:firstImageUrl];
                    NSString *jsonString = [imagesArrM mj_JSONString];
                    [postParmas setValue:jsonString forKey:@"imgs"];
                } else {
                    NSString *firstImageUrl = templatedArr.firstObject;
                    int i = (arc4random() % (templateModel.standardImgs.count - 1)) + 1;
                    NSString *secondImageUrl = templateModel.standardImgs[i];
                    [imagesArrM addObject:firstImageUrl];
                    [imagesArrM addObject:secondImageUrl];
                    NSString *jsonString = [imagesArrM mj_JSONString];
                    [postParmas setValue:jsonString forKey:@"imgs"];
                }
            }
        }
        [LVHttpRequest post:@"/api/v1/generateImages" param:postParmas header:@{} baseUrlType:CDHttpBaseUrlTypeMagina_ljw isNeedPublickParam:YES isNeedPublickHeader:YES isNeedEncryptHeader:YES isNeedEncryptParam:YES isNeedDecryptResponse:YES encryptType:CDHttpBaseUrlTypeMagina_ljw timeout:2.0 modelClass:nil completion:^(NSInteger status, NSString * _Nonnull message, id  _Nullable result, NSError * _Nullable error, id  _Nullable responseObject) {
            [self.productionLoading dismiss];
            if (status != 1 || error) {
                [self.view makeToast:message];
                return;
            }
            NSString *tagString = result[@"tag"];
            MGProductionController *vc = [[MGProductionController alloc] init];
            vc.templateModel = [self.templateModels objectAtIndex:self.currentTemplateIndex];
            vc.generatedTag = tagString;
            vc.imageWorksCount = imagesArrM.count;
            [self.navigationController pushViewController:vc animated:YES];
        }];
    } failure:^(NSError * _Nonnull error) {
        [self.productionLoading dismiss];
        [self.view makeToast:NSLocalizedString(@"global_request_error", nil)];
    }];
}

#pragma mark - UICollectionViewDelegate, UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (collectionView == self.avatarCollectionView) {
        return self.globalManager.faceImageRecords.count;
    } else {
        return self.templateModels.count;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView == self.avatarCollectionView) {
        return CGSizeMake(59, 59);
    } else {
        return CGSizeMake(self.templateCollectionView.lv_width, self.templateCollectionView.lv_height);
    }
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    if (collectionView == self.avatarCollectionView) {
        return 0;
    } else {
        return 0;
    }
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    if (collectionView == self.avatarCollectionView) {
        return 10;
    } else {
        return 0;
    }
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    if (collectionView == self.avatarCollectionView) {
        return UIEdgeInsetsMake(0, 0, 0, 25);
    } else {
        return UIEdgeInsetsMake(0, 0, 0, 0);
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView == self.avatarCollectionView) {
        MGFaceResultCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:MGFaceResultCellKey forIndexPath:indexPath];
        cell.tag = indexPath.item;
        NSString *imageName = self.globalManager.faceImageRecords[indexPath.item];
        NSString *imagePath = [self.globalManager.faceImageDataFileDirPath stringByAppendingPathComponent:imageName];
        UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
        cell.contentImageView.image = image;
        cell.contentImageView.layer.borderWidth = self.currentFaceIndex == indexPath.item ? 2 : 0;
        @lv_weakify(self)
        cell.deleteFaceCallback = ^(UIButton * _Nonnull sender, NSInteger index) {
            @lv_strongify(self)
            if (index < self.globalManager.faceImageRecords.count) {
                NSString *imageName = self.globalManager.faceImageRecords[index];
                [self.globalManager deleteFaceImageRecord:imageName completion:^{
                    [self.avatarCollectionView reloadData];
                }];
            }
        };
        return cell;
    } else {
        MGTemplateDetailsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:MGTemplateDetailsCellKey forIndexPath:indexPath];
        cell.listModel = self.templateModels[indexPath.item];
        return cell;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView == self.templateCollectionView) {
        MGTemplateListModel *currentModel = [self.templateModels objectAtIndex:indexPath.item];
        MGTemplateDetailsCell *detailsCell = (MGTemplateDetailsCell *)cell;
        [detailsCell loadImageWithUrlString:currentModel.standardImgs.firstObject];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView == self.avatarCollectionView)  {
        self.currentFaceIndex = indexPath.item;
        [self.avatarCollectionView reloadData];
    } else {
        MGReviewImageController *vc = [[MGReviewImageController alloc] init];
        vc.currentIndex = self.bodyTye;
        vc.templateModel = self.templateModels[indexPath.item];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView == self.templateCollectionView) {
        CGPoint pInView = [self.view convertPoint:self.templateCollectionView.center toView:self.templateCollectionView];
        NSIndexPath *indexPathNow = [self.templateCollectionView indexPathForItemAtPoint:pInView];
        if (self.bodyTye != 0 && self.currentTemplateIndex != indexPathNow.item) {
            self.bodyTye = 0;
            self.standardBtn.backgroundColor = HEX_COLOR(0xEA4C89);
            self.fatBtn.backgroundColor = [UIColor colorWithWhite:.0 alpha:.0];
        }
        self.currentTemplateIndex = indexPathNow.item;
    }
}

#pragma mark - assistMethod
- (void)openAddPhotosVc {
    MGAddPhotosController *vc = [[MGAddPhotosController alloc] init];
    vc.dismissCallback = ^{
        MGShotController *vc = [[MGShotController alloc] init];
        vc.outputPhotoCallback = ^(UIImage * _Nonnull resultImage) {
            [[MGFaceRecognition shareInstance] detectFacesWithTargetImge:resultImage resultBlock:^(NSMutableArray<UIImage *> * _Nonnull images) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (images.count == 1) {
                        [self.globalManager saveFaceImage:images.firstObject completion:^{
                            [self.avatarCollectionView reloadData];
                        }];
                    } else if (images.count > 1) {
                        MGSelectFaceController *vc = [[MGSelectFaceController alloc] init];
                        vc.originImage = resultImage;
                        vc.imageList = [images copy];
                        vc.selectedImageCallback = ^(UIImage * _Nonnull resultImage) {
                            [self.globalManager saveFaceImage:resultImage completion:^{
                                [self.avatarCollectionView reloadData];
                            }];
                        };
                        vc.modalPresentationStyle = UIModalPresentationFullScreen;
                        [self.navigationController presentViewController:vc animated:YES completion:nil];
                    } else {
                        [self.view makeToast:NSLocalizedString(@"crop_faill", nil)];
                    }
                });
            }];
        };
        vc.modalPresentationStyle = UIModalPresentationFullScreen;
        [self.navigationController presentViewController:vc animated:YES completion:nil];
    };
    vc.selectedImageCallback = ^(UIImage * _Nonnull resultImage) {
        [[MGFaceRecognition shareInstance] detectFacesWithTargetImge:resultImage resultBlock:^(NSMutableArray<UIImage *> * _Nonnull images) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (images.count == 1) {
                    [self.globalManager saveFaceImage:images.firstObject completion:^{
                        [self.avatarCollectionView reloadData];
                    }];
                } else if (images.count > 1) {
                    MGSelectFaceController *vc = [[MGSelectFaceController alloc] init];
                    vc.originImage = resultImage;
                    vc.imageList = [images copy];
                    vc.selectedImageCallback = ^(UIImage * _Nonnull resultImage) {
                        [self.globalManager saveFaceImage:resultImage completion:^{
                            [self.avatarCollectionView reloadData];
                        }];
                    };
                    vc.modalPresentationStyle = UIModalPresentationFullScreen;
                    [self.navigationController presentViewController:vc animated:YES completion:nil];
                } else {
                    [self.view makeToast:NSLocalizedString(@"crop_faill", nil)];
                }
            });
        }];
    };
    [self.navigationController presentPanModal:vc completion:nil];
}

- (void)showLoading {
    if (self.collectionIndicator.superview == nil || self.collectionIndicator.superview != self.collectBtn) {
        [self.collectBtn addSubview:self.collectionIndicator];
        [self.collectionIndicator startAnimating];
    }
}

- (void)hideLoading {
    if (self.collectionIndicator.superview) {
        [self.collectionIndicator stopAnimating];
        [self.collectionIndicator removeFromSuperview];
    }
}

#pragma mark - getter
- (UILabel *)pointsLab {
    if (!_pointsLab) {
        _pointsLab = [[UILabel alloc] init];
        _pointsLab.textColor = [UIColor whiteColor];
        _pointsLab.font = [UIFont systemFontOfSize:14.0 weight:UIFontWeightMedium];
        _pointsLab.text = [NSString stringWithFormat:@"%.0f", [MGGlobalManager shareInstance].currentPoints];
        [_pointsLab sizeToFit];
    }
    return _pointsLab;
}

- (UIImageView *)pointsImageView {
    if (!_pointsImageView) {
        _pointsImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MG_home_topbar_points_icon"]];
    }
    return _pointsImageView;
}

- (MGProductionLoading *)productionLoading {
    if (!_productionLoading) {
        _productionLoading = [MGProductionLoading createLoading];
    }
    return _productionLoading;
}

- (NSArray<MGTemplateListModel *> *)templateModels {
    if (!_templateModels) {
        _templateModels = [NSArray array];
    }
    return _templateModels;
}

- (MGGlobalManager *)globalManager {
    if (!_globalManager) {
        _globalManager = [MGGlobalManager shareInstance];
    }
    return _globalManager;
}

- (UIActivityIndicatorView *)collectionIndicator {
    if (!_collectionIndicator) {
        _collectionIndicator = [[UIActivityIndicatorView alloc] init];
        _collectionIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleLarge;
        _collectionIndicator.color = HEX_COLOR(0xEA4C89);
    }
    return _collectionIndicator;
}

@end

