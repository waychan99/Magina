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
#import "MGFaceResultCell.h"
#import "MGTemplateDetailsCell.h"
#import "MGTemplateListModel.h"
#import "MGFaceRecognition.h"
#import "SPButton.h"
#import <HWPanModal/HWPanModal.h>
#import <Photos/Photos.h>

@interface MGTemplateDetailsController ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) UILabel *pointsLab;
@property (nonatomic, strong) UIImageView *pointsImageView;
@property (weak, nonatomic) IBOutlet UICollectionView *templateCollectionView;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UIImageView *addPhotoImageView;
@property (weak, nonatomic) IBOutlet UICollectionView *avatarCollectionView;
@property (weak, nonatomic) IBOutlet UIButton *collectBtn;
@property (weak, nonatomic) IBOutlet SPButton *photographBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *templateCollectionViewTop;
@property (nonatomic, strong) NSMutableArray<UIImage *> *faceImageResults;
@property (nonatomic, assign) BOOL isFirstLoad;
@end

@implementation MGTemplateDetailsController

#pragma mark - lifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.isFirstLoad = YES;
    
    [self setupUIComponents];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.isFirstLoad) {
        self.isFirstLoad = NO;
        [self.templateCollectionView setNeedsLayout];
        [self.templateCollectionView layoutIfNeeded];
        
        if (self.templateModels.count > 0) {
            [self.templateCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.currentFaceIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
        }
    }
}

- (void)dealloc {
    LVLog(@"MGTemplateDetailsController -- dealloc");
}

#pragma mark - setupUIComponents
- (void)setupUIComponents {
    self.view.backgroundColor = [UIColor blackColor];

    [self.customNavBar addSubview:self.pointsLab];
    [self.customNavBar addSubview:self.pointsImageView];
    
    [self.photographBtn setTitle:NSLocalizedString(@"10  拍同款", nil) forState:UIControlStateNormal];
    [self.photographBtn setImage:[UIImage imageNamed:@"MG_home_topbar_points_icon"] forState:UIControlStateNormal];
    
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
}

#pragma mark - override
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    CGFloat selfW = self.view.lv_width;
    CGFloat pointsLabX = selfW - 20 - self.pointsLab.lv_width;
    self.pointsLab.frame = CGRectMake(pointsLabX, 0, self.pointsLab.lv_width, 17);
    self.pointsLab.lv_centerY = self.wrNaviBar_leftButton.lv_centerY;
    CGFloat pointsImageViewX = self.pointsLab.lv_x - 5 - 18;
    self.pointsImageView.frame = CGRectMake(pointsImageViewX, 0, 18, 17);
    self.pointsImageView.lv_centerY = self.wrNaviBar_leftButton.lv_centerY;
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
    MGProductionController *vc = [[MGProductionController alloc] init];
    vc.templateModel = [self.templateModels objectAtIndex:self.currentFaceIndex];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UICollectionViewDelegate, UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (collectionView == self.avatarCollectionView) {
        return self.faceImageResults.count;
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
        UIImage *image = self.faceImageResults[indexPath.row];
        cell.contentImageView.image = image;
        cell.contentImageView.layer.borderWidth = self.currentFaceIndex == indexPath.item ? 2 : 0;
        @lv_weakify(self)
        cell.deleteFaceCallback = ^(UIButton * _Nonnull sender, NSInteger index) {
            @lv_strongify(self)
            [self.faceImageResults removeObjectAtIndex:index];
            [self.avatarCollectionView reloadData];
        };
        return cell;
    } else {
        MGTemplateDetailsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:MGTemplateDetailsCellKey forIndexPath:indexPath];
        cell.listModel = self.templateModels[indexPath.item];
        return cell;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView == self.avatarCollectionView)  {
        self.currentFaceIndex = indexPath.item;
        [self.avatarCollectionView reloadData];
    } else {
        
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
                        [self.faceImageResults addObject:images.firstObject];
                        [self.avatarCollectionView reloadData];
                    } else if (images.count > 1) {
                        MGSelectFaceController *vc = [[MGSelectFaceController alloc] init];
                        vc.originImage = resultImage;
                        vc.imageList = [images copy];
                        vc.selectedImageCallback = ^(UIImage * _Nonnull resultImage) {
                            [self.faceImageResults addObject:resultImage];
                            [self.avatarCollectionView reloadData];
                        };
                        vc.modalPresentationStyle = UIModalPresentationFullScreen;
                        [self.navigationController presentViewController:vc animated:YES completion:nil];
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
                    [self.faceImageResults addObject:images.firstObject];
                    [self.avatarCollectionView reloadData];
                } else if (images.count > 1) {
                    MGSelectFaceController *vc = [[MGSelectFaceController alloc] init];
                    vc.originImage = resultImage;
                    vc.imageList = [images copy];
                    vc.selectedImageCallback = ^(UIImage * _Nonnull resultImage) {
                        [self.faceImageResults addObject:resultImage];
                        [self.avatarCollectionView reloadData];
                    };
                    vc.modalPresentationStyle = UIModalPresentationFullScreen;
                    [self.navigationController presentViewController:vc animated:YES completion:nil];
                }
            });
        }];
    };
    [self.navigationController presentPanModal:vc completion:nil];
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

- (NSMutableArray<UIImage *> *)faceImageResults {
    if (!_faceImageResults) {
        _faceImageResults = [NSMutableArray array];
    }
    return _faceImageResults;
}

- (NSArray<MGTemplateListModel *> *)templateModels {
    if (!_templateModels) {
        _templateModels = [NSArray array];
    }
    return _templateModels;
}

@end

