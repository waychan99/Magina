//
//  MGTemplateFilterSheet.m
//  Magina
//
//  Created by mac on 2025/8/13.
//

#import "MGTemplateFilterSheet.h"
#import "MGTemplateCategoryModel.h"

@interface MGTemplateFilterSheetSection : UICollectionReusableView

@property (nonatomic, strong) UILabel *sectionTitleLab;

@end

@implementation MGTemplateFilterSheetSection

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.sectionTitleLab];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.sectionTitleLab.frame = CGRectMake(23, 0, self.lv_width - 33, self.lv_height);
}

- (UILabel *)sectionTitleLab {
    if (!_sectionTitleLab) {
        _sectionTitleLab = [[UILabel alloc] init];
        _sectionTitleLab.textColor = HEX_COLOR(0x8C919D);
        _sectionTitleLab.textAlignment = NSTextAlignmentLeft;
        _sectionTitleLab.font = [UIFont systemFontOfSize:14.0 weight:UIFontWeightRegular];
    }
    return _sectionTitleLab;
}

@end

@interface MGTemplateFilterSheetCell : UICollectionViewCell

@property (nonatomic, strong) UILabel *titleLab;

@end

@implementation MGTemplateFilterSheetCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.1];
        self.layer.cornerRadius = 19.5;
        [self.contentView addSubview:self.titleLab];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.titleLab.frame = self.contentView.bounds;
}

- (UILabel *)titleLab {
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] init];
        _titleLab.textColor = [UIColor whiteColor];
        _titleLab.font = [UIFont systemFontOfSize:13 weight:UIFontWeightMedium];
        _titleLab.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLab;
}

@end

@interface MGTemplateFilterSheet ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIButton *comfirnBtn;
@property (nonatomic, strong) NSArray<MGTemplateCategoryModel *> *categorys;
@property (nonatomic, strong) NSMutableArray<NSArray *> *dateSource;
@property (nonatomic, copy) void (^resultBlcok)(MGTemplateCategoryModel *categoryModel, NSString *genderType);
@end

@implementation MGTemplateFilterSheet

+ (instancetype)showWithCategorys:(NSArray<MGTemplateCategoryModel *> *)categorys resultBlock:(void (^)(MGTemplateCategoryModel * _Nonnull, NSString * _Nonnull))resultBlock completion:(void (^)(BOOL))completion {
    MGTemplateFilterSheet *filterSheet = [[MGTemplateFilterSheet alloc] init];
    filterSheet.categorys = categorys;
    filterSheet.resultBlcok = resultBlock;
    [filterSheet lv_showWithAnimateType:LVShowViewAnimateTypeAlpha dismissTapEnable:YES completion:completion];
    return filterSheet;
}

- (void)clickComfirnBtn:(UIButton *)sender {
    
}

- (void)setCategorys:(NSArray<MGTemplateCategoryModel *> *)categorys {
    _categorys = categorys;
    
    self.dateSource = [NSMutableArray array];
    
    NSMutableArray *genderArrM = [NSMutableArray array];
    MGTemplateCategoryModel *allModel = [[MGTemplateCategoryModel alloc] init];
    allModel.genderType = @"-1";
    allModel.category_name = NSLocalizedString(@"All", nil);
    [genderArrM addObject:allModel];
    
    MGTemplateCategoryModel *manModel = [[MGTemplateCategoryModel alloc] init];
    manModel.genderType = @"1";
    manModel.category_name = NSLocalizedString(@"Man", nil);
    [genderArrM addObject:manModel];
    
    MGTemplateCategoryModel *womanModel = [[MGTemplateCategoryModel alloc] init];
    womanModel.genderType = @"0";
    womanModel.category_name = NSLocalizedString(@"Woman", nil);
    [genderArrM addObject:womanModel];
    
    [self.dateSource addObject:genderArrM];
    
    if (categorys.count > 0) {
        [self.dateSource addObject:categorys];
    }
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUIComponents];
    }
    return self;
}

- (void)setupUIComponents {
    self.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.0];
    self.layer.cornerRadius = 27.0;
    self.layer.masksToBounds = YES;
    
    [self addSubview:self.contentView];
    [self.contentView addSubview:self.collectionView];
    [self.contentView addSubview:self.comfirnBtn];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.frame = CGRectMake(0, 0, UI_SCREEN_W, 671);
    self.contentView.frame = CGRectMake(0, 88, self.lv_width, 671 - 88);
    self.collectionView.frame = CGRectMake(0, 20, self.contentView.lv_width, self.contentView.lv_height - 77 - 20);
    self.comfirnBtn.frame = CGRectMake(15, CGRectGetMaxY(self.collectionView.frame), self.contentView.lv_width - 30, 49);
    self.comfirnBtn.layer.cornerRadius = 24.5;
}

#pragma mark - UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.dateSource.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dateSource[section].count;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 15;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    if (section == 0) {
        return UIEdgeInsetsMake(23, 15, 33, 15);
    }
    return UIEdgeInsetsMake(23, 15, 23, 15);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat itemW = 0;
    if (indexPath.section == 0) {
        itemW = floorf((self.collectionView.lv_width - 50) / 3);
        return CGSizeMake(itemW, 39);
    }
    itemW = floorf((self.collectionView.lv_width - 40) / 2);
    return CGSizeMake(itemW, 39);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(self.collectionView.lv_width, 20);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MGTemplateFilterSheetCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MGTemplateFilterSheetCellId" forIndexPath:indexPath];
    MGTemplateCategoryModel *categoryModel = self.dateSource[indexPath.section][indexPath.item];
    cell.titleLab.text = categoryModel.category_name;
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    MGTemplateFilterSheetSection *sectionHeader = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"MGTemplateFilterSheetSectionId" forIndexPath:indexPath];
    if (indexPath.section == 0) {
        sectionHeader.sectionTitleLab.text = NSLocalizedString(@"Gender", nil);
    }
    sectionHeader.sectionTitleLab.text = NSLocalizedString(@"Style category", nil);
    return sectionHeader;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
  
}

#pragma mark - getter
- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = [UIColor blackColor];
    }
    return _contentView;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:[[UICollectionViewFlowLayout alloc] init]];
        _collectionView.backgroundColor = [UIColor blackColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[MGTemplateFilterSheetCell class] forCellWithReuseIdentifier:@"MGTemplateFilterSheetCellId"];
        [_collectionView registerClass:[MGTemplateFilterSheetSection class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"MGTemplateFilterSheetSectionId"];
        _collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    return _collectionView;
}

- (UIButton *)comfirnBtn {
    if (!_comfirnBtn) {
        _comfirnBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _comfirnBtn.backgroundColor = HEX_COLOR(0xEA4C89);
        [_comfirnBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _comfirnBtn.titleLabel.font = [UIFont systemFontOfSize:14.0 weight:UIFontWeightMedium];
        [_comfirnBtn setTitle:NSLocalizedString(@"Comfirn", nil) forState:UIControlStateNormal];
        [_comfirnBtn addTarget:self action:@selector(clickComfirnBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _comfirnBtn;
}

@end
