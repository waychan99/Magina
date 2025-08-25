//
//  MGAlbumListView.m
//  Magina
//
//  Created by 陈志伟 on 2025/8/23.
//

#import "MGAlbumListView.h"
#import "MGImageManager.h"

@interface MGAlbumListViewCell : UITableViewCell
@property (nonatomic, strong) UIImageView *headerIcon;
@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UILabel *contentLab;
@property (nonatomic, strong) MGAlbumModel *albumModel;
@end

@implementation MGAlbumListViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"MGAlbumListViewCell";
    MGAlbumListViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[MGAlbumListViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUIComponents];
    }
    return self;
}

- (void)setAlbumModel:(MGAlbumModel *)albumModel {
    _albumModel = albumModel;
    
    self.titleLab.text = albumModel.name;
    self.contentLab.text = [NSString stringWithFormat:@"%zd", albumModel.count - 1];
    [[MGImageManager shareInstance] getPostImageWithAlbumModel:albumModel completion:^(UIImage * _Nonnull postImage) {
        self.headerIcon.image = postImage;
        [self setNeedsLayout];
    }];
}

- (void)setupUIComponents {
    self.contentView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.headerIcon];
    [self.contentView addSubview:self.titleLab];
    [self.contentView addSubview:self.contentLab];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat selfW = self.contentView.lv_width;
    CGFloat selfH = self.contentView.lv_height;
    self.headerIcon.frame = CGRectMake(0, 0, selfH, selfH);
    CGFloat labX = CGRectGetMaxX(self.headerIcon.frame) + 16;
    self.titleLab.frame = CGRectMake(labX, 12, selfW - labX, 17);
    self.contentLab.frame = CGRectMake(labX, selfH - 12 - 16, selfW - labX, 16);
}

- (UIImageView *)headerIcon {
    if (!_headerIcon) {
        _headerIcon = [[UIImageView alloc] init];
        _headerIcon.layer.cornerRadius = 5.0f;
        _headerIcon.contentMode = UIViewContentModeScaleAspectFill;
        _headerIcon.clipsToBounds = YES;
    }
    return _headerIcon;
}

- (UILabel *)titleLab {
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] init];
        _titleLab.textAlignment = NSTextAlignmentLeft;
        _titleLab.textColor = HEX_COLOR(0x131418);
        _titleLab.font = [UIFont systemFontOfSize:14.0 weight:UIFontWeightBold];
    }
    return _titleLab;
}

- (UILabel *)contentLab {
    if (!_contentLab) {
        _contentLab = [[UILabel alloc] init];
        _contentLab.textAlignment = NSTextAlignmentLeft;
        _contentLab.textColor = HEX_COLOR(0x757985);
        _contentLab.font = [UIFont systemFontOfSize:13.0 weight:UIFontWeightSemibold];
    }
    return _contentLab;
}

@end

@interface MGAlbumListView ()<UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate>
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIImageView *upArrowImageView;
@property (nonatomic, copy) void (^resultBlcok)(MGAlbumModel *albumModel);
@property (nonatomic, weak) UIView *targetView;
@property (nonatomic, weak) NSArray *albumList;
@end

@implementation MGAlbumListView

+ (instancetype)showFromView:(UIView *)sender albumList:(NSArray *)albumList resultBlock:(void (^)(MGAlbumModel * _Nonnull))resultBlock completion:(void (^)(BOOL))completion {
    MGAlbumListView *listView = [[MGAlbumListView alloc] init];
    listView.resultBlcok = resultBlock;
    listView.targetView = sender;
    listView.albumList = albumList;
    [listView lv_showWithAnimateType:LVShowViewAnimateTypeAlpha dismissTapEnable:NO completion:completion];
    return listView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUIComponents];
    }
    return self;
}

- (void)setupUIComponents {
    self.backgroundColor = [UIColor colorWithWhite:.0 alpha:.0];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAlbumList:)];
    tap.delegate = self;
    [self addGestureRecognizer:tap];
    [self addSubview:self.upArrowImageView];
    [self addSubview:self.contentView];
    [self.contentView addSubview:self.tableView];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.lv_width, CGFLOAT_MIN)];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.frame = [UIScreen mainScreen].bounds;
    CGRect targetRect = [self.targetView.superview convertRect:self.targetView.frame toView:self];
    self.upArrowImageView.frame = CGRectMake(targetRect.origin.x + (targetRect.size.width / 2) - 8, CGRectGetMaxY(targetRect), 16, 10);
    self.contentView.frame = CGRectMake(18, CGRectGetMaxY(self.upArrowImageView.frame) - 1, UI_SCREEN_W - 36, 350);
    self.tableView.frame = CGRectMake(20, 20, self.contentView.lv_width - 40, self.contentView.lv_height - 27);
}

- (void)tapAlbumList:(UIGestureRecognizer *)sender {
    [self lv_dismiss];
}

#pragma mark - UITableViewDelegate, UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.albumList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.0001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 13;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MGAlbumListViewCell *cell = [MGAlbumListViewCell cellWithTableView:tableView];
    cell.albumModel = self.albumList[indexPath.section];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self lv_dismiss];
    !self.resultBlcok ?: self.resultBlcok(self.albumList[indexPath.section]);
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"] ||
        touch.view == self.contentView ||
        touch.view == self.tableView) {
        return NO;
    }
    return  YES;
}

#pragma mark - getter
- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = [UIColor whiteColor];
        _contentView.layer.cornerRadius = 14.0f;
    }
    return _contentView;
}

- (UIImageView *)upArrowImageView {
    if (!_upArrowImageView) {
        _upArrowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MG_popover_up_arrow"]];
    }
    return _upArrowImageView;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        _tableView.showsVerticalScrollIndicator = NO;
    }
    return _tableView;
}

@end
