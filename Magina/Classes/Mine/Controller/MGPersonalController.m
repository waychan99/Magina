//
//  MGPersonalController.m
//  Magina
//
//  Created by mac on 2025/8/18.
//

#import "MGPersonalController.h"
#import "MGPointsListController.h"
#import "MGMemberController.h"
#import "MGMineHeaderView.h"
#import "MGPersonalCell.h"
#import "MGAppleLogin.h"

static NSString *const kAppleLoginKey  = @"apple";

@interface MGPersonalController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UIImageView *topImageView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) MGMineHeaderView *header;
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
    
    @lv_weakify(self)
    self.header.tapBgImageViewCallback = ^(UIGestureRecognizer * _Nonnull sender) {
        @lv_strongify(self)
        MGMemberController *vc = [[MGMemberController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    };
    
    self.header.tapHeaderIconCallback = ^(UIGestureRecognizer * _Nonnull sender) {
        @lv_strongify(self)
        [self appleLogin];
    };
}

#pragma mark - request
- (void)loginRequestWithCode:(NSString *)code fromType:(NSString *)fromType email:(NSString *)email userName:(NSString *)userName userAvatar:(NSString *)userAvatar {
    [SVProgressHUD show];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:code forKey:@"from_code"];
    [params setValue:fromType forKey:@"from_type"];
    [params setValue:email forKey:@"third_email"];
    [params setValue:userName forKey:@"third_user_name"];
    [params setValue:userAvatar forKey:@"third_user_avatar"];
    [LVHttpRequest get:@"/magina-api/api/v1/login/index.php" param:params header:@{} baseUrlType:CDHttpBaseUrlTypeMagina isNeedPublickParam:YES isNeedPublickHeader:YES isNeedEncryptHeader:YES isNeedEncryptParam:YES isNeedDecryptResponse:YES encryptType:CDHttpBaseUrlTypeMagina timeout:20.0 modelClass:nil completion:^(NSInteger status, NSString * _Nonnull message, id  _Nullable result, NSError * _Nullable error, id  _Nullable responseObject) {
        [SVProgressHUD dismiss];
        if (status != 1 || error) {
            [self.view makeToast:NSLocalizedString(@"global_request_error", nil)];
            return;
        }
        [MGLoginFactory saveAccountInfo:result];
        [MGGlobalManager shareInstance].accountInfo = [MGAccountInfo mj_objectWithKeyValues:result];
        [[NSNotificationCenter defaultCenter] postNotificationName:MG_LOGIN_SUCCESSED_NOTI object:nil];
        [self requestFavoriteList];
    }];
}

- (void)requestFavoriteList {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:[MGGlobalManager shareInstance].accountInfo.user_id forKey:@"user_id"];
    [params setValue:@(1) forKey:@"page"];
    [params setValue:@(3000) forKey:@"limit"];
    [LVHttpRequest get:@"/api/v1/getUserCollections" param:params header:@{} baseUrlType:CDHttpBaseUrlTypeMagina_ljw isNeedPublickParam:YES isNeedPublickHeader:YES isNeedEncryptHeader:YES isNeedEncryptParam:YES isNeedDecryptResponse:YES encryptType:CDHttpBaseUrlTypeMagina_ljw timeout:20.0 modelClass:nil completion:^(NSInteger status, NSString * _Nonnull message, id  _Nullable result, NSError * _Nullable error, id  _Nullable responseObject) {
        if (status != 1 || error) {
            [[NSNotificationCenter defaultCenter] postNotificationName:MG_REQUEST_FAVORITE_TEMPLATE_STATUS_NOTI object:@{@"status" : @(0)}];
            return;
        }
        NSArray *resultArr = (NSArray *)result;
        if (resultArr.count > 0) {
            NSMutableArray *resultArrM = [resultArr mutableCopy];
            [MGGlobalManager shareInstance].favoriteTemplates = resultArrM;
            [resultArrM writeToFile:[MGGlobalManager shareInstance].favoriteTemplatesPath atomically:YES];
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:MG_REQUEST_FAVORITE_TEMPLATE_STATUS_NOTI object:@{@"status" : @(1)}];
    }];
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
    }
}

#pragma mark - JXCategoryListContentViewDelegate
- (UIView *)listView {
    return self.view;
}

#pragma mark - assistMethod
- (void)appleLogin {
    @lv_weakify(self)
    [[MGAppleLogin shareInstance] mg_loginWithCompleteHandler:^(BOOL successed, NSString * _Nullable user, NSString * _Nullable familyName, NSString * _Nullable givenName, NSString * _Nullable email, NSString * _Nullable password, NSData * _Nullable identityToken, NSData * _Nullable authorizationCode, NSError * _Nullable error, NSString * _Nonnull msg) {
        if (!error) {
            @lv_strongify(self)
            [self loginRequestWithCode:user fromType:kAppleLoginKey email:email userName:[NSString stringWithFormat:@"%@ %@", givenName, familyName] userAvatar:nil];
        }
    }];
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

- (NSMutableArray<NSMutableArray *> *)dataSource {
    if (!_dataSource) {
        _dataSource = [EJPersonalListCellModel loadDataSource];
    }
    return _dataSource;
}

@end
