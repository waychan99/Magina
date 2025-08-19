//
//  MGMainContainerController.m
//  Magina
//
//  Created by mac on 2025/8/18.
//

#import "MGMainContainerController.h"
#import "MGHomeController.h"
#import "MGMineController.h"
#import "JXCategoryListContainerView.h"
#import "JXCategoryImageView.h"

@interface MGMainContainerController ()<JXCategoryListContainerViewDelegate, JXCategoryViewDelegate>
@property (nonatomic, strong) UIView *categoryBgView;
@property (nonatomic, strong) JXCategoryImageView *categoryView;
@property (nonatomic, strong) JXCategoryListContainerView *listContainerView;
@property (nonatomic, strong) NSArray<NSString *> *imageNames;
@property (nonatomic, strong) NSArray<NSString *> *selectedImageNames;
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
    self.categoryView.frame = CGRectMake(30, self.view.lv_height - 120, self.view.lv_width - 60, 60);
}

#pragma mark - setupUIComponents
- (void)setupUIComponents {
    self.view.backgroundColor = [UIColor blackColor];
    
    self.categoryView = [[JXCategoryImageView alloc] initWithFrame:CGRectZero];
    self.categoryView.delegate = self;
    self.categoryView.imageNames = self.imageNames;
    self.categoryView.selectedImageNames = self.selectedImageNames;
    self.categoryView.imageSize = CGSizeMake(31, 31);
    self.categoryView.backgroundColor = [UIColor colorWithWhite:0.4 alpha:0.2];
    self.categoryView.layer.cornerRadius = 30.0f;
    
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
    }
    return [[MGMineController alloc] init];
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

@end
