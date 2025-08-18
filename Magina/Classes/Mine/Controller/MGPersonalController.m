//
//  MGPersonalController.m
//  Magina
//
//  Created by mac on 2025/8/18.
//

#import "MGPersonalController.h"
#import "MGPointsListController.h"
#import "MGPersonalCell.h"

@interface MGPersonalController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray<NSMutableArray *> *dataSource;
@end

@implementation MGPersonalController

#pragma mark - lifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self setupUIComponents];
}

#pragma mark - setupUIComponents
- (void)setupUIComponents {
    self.view.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.tableView];
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

#pragma mark - getter
- (UITableView *)tableView {
    if (!_tableView) {
        CGFloat tableViewY = CGRectGetMaxY(self.customNavBar.frame);
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, tableViewY, self.view.lv_width, UI_SCREEN_H - tableViewY) style:UITableViewStyleGrouped];
        _tableView.backgroundColor = [UIColor blackColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerNib:[UINib nibWithNibName:MGPersonalCellKey bundle:nil] forCellReuseIdentifier:MGPersonalCellKey];
    }
    return _tableView;
}

- (NSMutableArray<NSMutableArray *> *)dataSource {
    if (!_dataSource) {
        _dataSource = [EJPersonalListCellModel loadDataSource];
    }
    return _dataSource;
}

@end
