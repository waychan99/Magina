//
//  MGMainContainerController.m
//  Magina
//
//  Created by mac on 2025/8/18.
//

#import "MGMainContainerController.h"
#import "MGHomeController.h"
#import "MGPersonalController.h"
#import "MGPhotosController.h"
#import "JXCategoryListContainerView.h"
#import "JXCategoryImageView.h"
#import "UIView+GradientColors.h"

@interface MGMainContainerController ()<JXCategoryListContainerViewDelegate, JXCategoryViewDelegate>
@property (nonatomic, strong) UIView *categoryBgView;
@property (nonatomic, strong) JXCategoryImageView *categoryView;
@property (nonatomic, strong) JXCategoryListContainerView *listContainerView;
@property (nonatomic, strong) NSArray<NSString *> *imageNames;
@property (nonatomic, strong) NSArray<NSString *> *selectedImageNames;
@property (nonatomic, strong) CAGradientLayer *categoryView_gradientLayer;
@end

@implementation MGMainContainerController

#pragma mark - lifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUIComponents];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    self.listContainerView.frame = self.view.bounds;
    self.categoryView.frame = CGRectMake(35, self.view.lv_height - 105, self.view.lv_width - 70, 70);
    
    self.categoryView_gradientLayer.frame = self.categoryView.bounds;
    self.categoryView_gradientLayer.cornerRadius = 35.0f;
    [self.categoryView.layer insertSublayer:self.categoryView_gradientLayer atIndex:0];
}

#pragma mark - setupUIComponents
- (void)setupUIComponents {
    self.view.backgroundColor = [UIColor blackColor];
    
    self.categoryView = [[JXCategoryImageView alloc] initWithFrame:CGRectZero];
    self.categoryView.contentScrollViewClickTransitionAnimationEnabled = NO;
    self.categoryView.selectedAnimationDuration = .0f;
    self.categoryView.delegate = self;
    self.categoryView.imageNames = self.imageNames;
    self.categoryView.selectedImageNames = self.selectedImageNames;
    self.categoryView.imageSize = CGSizeMake(31, 31);
    self.categoryView.layer.cornerRadius = 35.0f;
    
    [self.view addSubview:self.listContainerView];
    [self.view addSubview:self.categoryView];
    self.categoryView.listContainer = self.listContainerView;
}

#pragma mark - JXCategoryListContainerViewDelegate
- (NSInteger)numberOfListsInlistContainerView:(JXCategoryListContainerView *)listContainerView {
    return self.imageNames.count;
}

- (id<JXCategoryListContentViewDelegate>)listContainerView:(JXCategoryListContainerView *)listContainerView initListForIndex:(NSInteger)index {
    if (index == 0) {
        return [[MGHomeController alloc] init];
    } else if (index == 1) {
        return [[MGPhotosController alloc] init];
    } else {
        return [[MGPersonalController alloc] init];
    }
}

#pragma mark - getter
- (UIView *)categoryBgView {
    if (!_categoryBgView) {
        _categoryBgView = [[UIView alloc] init];
    }
    return _categoryBgView;
}

- (JXCategoryListContainerView *)listContainerView {
    if (!_listContainerView) {
        _listContainerView = [[JXCategoryListContainerView alloc] initWithType:JXCategoryListContainerType_ScrollView delegate:self];
        _listContainerView.scrollView.backgroundColor = [UIColor blackColor];
        _listContainerView.scrollView.scrollEnabled = NO;
    }
    return _listContainerView;
}

- (NSArray<NSString *> *)imageNames {
    if (!_imageNames) {
        _imageNames = @[@"MG_container_home_icon_normal", @"MG_container_beauty_icon_normal", @"MG_container_mine_icon_normal"];
    }
    return _imageNames;
}

- (NSArray<NSString *> *)selectedImageNames {
    if (!_selectedImageNames) {
        _selectedImageNames = @[@"MG_container_home_icon", @"MG_container_beauty_icon", @"MG_container_mine_icon"];
    }
    return _selectedImageNames;
}

- (CAGradientLayer *)categoryView_gradientLayer {
    if (!_categoryView_gradientLayer) {
        _categoryView_gradientLayer = [self.categoryView setGradientColors:@[(__bridge id)RGBA(11, 13, 15, 0.5).CGColor,(__bridge id)RGBA(30, 31, 36, 0.5).CGColor] andGradientPosition:PositonVertical frame:CGRectZero];
        _categoryView_gradientLayer.borderColor = RGBA(54, 54, 54, 0.5).CGColor;
        _categoryView_gradientLayer.borderWidth = 0.4f;
    }
    return _categoryView_gradientLayer;
}

@end
