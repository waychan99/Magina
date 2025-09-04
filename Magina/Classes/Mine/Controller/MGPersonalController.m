//
//  MGPersonalController.m
//  Magina
//
//  Created by mac on 2025/8/18.
//

#import "MGPersonalController.h"
#import "MGMemberController.h"
#import "MGInviteFriendsController.h"
#import "MGPrivacyPolicyController.h"
#import "MGMineHeaderView.h"
#import "MGPersonalCell.h"

@interface MGPersonalController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UIImageView *topImageView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) MGMineHeaderView *header;
@property (nonatomic, strong) UIView *footer;
@property (nonatomic, strong) NSMutableArray<NSMutableArray *> *dataSource;
@end

@implementation MGPersonalController

#pragma mark - lifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self setupUIComponents];
}

#pragma mark - override
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    CGFloat selfW = self.view.lv_width;
    CGFloat selfH = self.view.lv_height;
    self.topImageView.frame = CGRectMake(0, 0, selfW, (selfW * 448) / 375);
    self.tableView.frame = CGRectMake(0, 0, selfW, selfH);
    self.header.frame = CGRectMake(0, 0, selfW, self.header.headerHeight);
}

#pragma mark - setupUIComponents
- (void)setupUIComponents {
    self.view.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.topImageView];
    [self.view addSubview:self.tableView];
    self.tableView.tableHeaderView = self.header;
    self.tableView.tableFooterView = self.footer;
    
    @lv_weakify(self)
    self.header.tapBgImageViewCallback = ^(UIGestureRecognizer * _Nonnull sender) {
        @lv_strongify(self)
        MGInviteFriendsController *vc = [[MGInviteFriendsController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    };
    
    self.header.tapHeaderIconCallback = ^(UIGestureRecognizer * _Nonnull sender) {
        
    };
}

#pragma mark - UITableViewDelegate, UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource[section].count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 53;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 17;
    }
    return 15;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.0001;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MGPersonalCell *cell = [tableView dequeueReusableCellWithIdentifier:MGPersonalCellKey forIndexPath:indexPath];
    cell.personalListCellModel = self.dataSource[indexPath.section][indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    EJPersonalListCellModel *model = self.dataSource[indexPath.section][indexPath.row];
    if (model.jumbController.length > 0) {
        UIViewController *targetVC = [[NSClassFromString(model.jumbController) alloc] init];
        if (targetVC) {
            [self.navigationController pushViewController:targetVC animated:YES];
        }
    } else {
        switch (model.cellType) {
            case MGPersonalCellTypeApplicationVersion: {
                
            }
                break;
                
            case MGPersonalCellTypeLogout: {
                
            }
                break;
                
            case MGPersonalCellTypeContactUs: {
                MGPrivacyPolicyController *vc = [[MGPrivacyPolicyController alloc] init];
                vc.customNavBarTitle = NSLocalizedString(@"contact_uss", nil);
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
                
            case MGPersonalCellTypePrivacyPolicy: {
                MGPrivacyPolicyController *vc = [[MGPrivacyPolicyController alloc] init];
                vc.customNavBarTitle = NSLocalizedString(@"privacy_policys", nil);
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
                
            default:
                break;
        }
    }
}

#pragma mark - JXCategoryListContentViewDelegate
- (UIView *)listView {
    return self.view;
}

#pragma mark - getter
- (UIImageView *)topImageView {
    if (!_topImageView) {
        _topImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MG_mine_top_bg"]];
    }
    return _topImageView;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.backgroundColor = [UIColor colorWithWhite:.0 alpha:.0];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        [_tableView registerNib:[UINib nibWithNibName:MGPersonalCellKey bundle:nil] forCellReuseIdentifier:MGPersonalCellKey];
    }
    return _tableView;
}

- (MGMineHeaderView *)header {
    if (!_header) {
        _header =  (MGMineHeaderView *)[[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([MGMineHeaderView class]) owner:nil options:nil] lastObject];
    }
    return _header;
}

- (UIView *)footer {
    if (!_footer) {
        _footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_W, 120)];
    }
    return _footer;
}

- (NSMutableArray<NSMutableArray *> *)dataSource {
    if (!_dataSource) {
        _dataSource = [EJPersonalListCellModel loadDataSource];
    }
    return _dataSource;
}

@end
