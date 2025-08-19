//
//  MGPersonalCell.m
//  Magina
//
//  Created by mac on 2025/8/18.
//

#import "MGPersonalCell.h"

@implementation EJPersonalListCellModel

+ (NSMutableArray<NSMutableArray *> *)loadDataSource {
    NSMutableArray *originData = [NSMutableArray array];
    [originData addObject:@[@{@"cellType"        : @(MGPersonalCellTypePointsDetails),
                              @"titleText"       : NSLocalizedString(@"Points Details", nil),
                              @"contentText"     : @"",
                              @"jumbController"  : @"MGPointsListController"},
                            @{@"cellType"        : @(MGPersonalCellTypeInviteFriends),
                              @"titleText"       : NSLocalizedString(@"Invite friends", nil),
                              @"contentText"     : @"",
                              @"jumbController"  : @"MGInviteFriendsController"}]];
     
     [originData addObject:@[@{@"cellType"        : @(MGPersonalCellTypeContactUs),
                               @"titleText"       : NSLocalizedString(@"Contact Us", nil),
                               @"contentText"     : @"",
                               @"jumbController"  : @""},
                             @{@"cellType"        : @(MGPersonalCellTypePrivacyPolicy),
                               @"titleText"       : NSLocalizedString(@"Privacy Policy", nil),
                               @"contentText"     :  @"",
                               @"jumbController"  : @""},
                             @{@"cellType"        : @(MGPersonalCellTypeApplicationVersion),
                               @"titleText"       : NSLocalizedString(@"Application version", nil),
                               @"contentText"     : @"",
                               @"jumbController"  : @""}]];
    
    NSMutableArray *dataSource = [NSMutableArray array];
    for (NSArray *subArr in originData) {
        NSMutableArray *subArrM = [NSMutableArray array];
        for (NSDictionary *dict in subArr) {
            [subArrM addObject:[EJPersonalListCellModel mj_objectWithKeyValues:dict]];
        }
        [dataSource addObject:subArrM];
    }
    return dataSource;
}

@end

@interface MGPersonalCell ()
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *contentLab;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleLeftMargin;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UIImageView *rightArrow;
@end

@implementation MGPersonalCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setPersonalListCellModel:(EJPersonalListCellModel *)personalListCellModel {
    _personalListCellModel = personalListCellModel;
    
    self.iconImageView.hidden = YES;
    self.titleLeftMargin.constant = 20;
    self.titleLab.text = personalListCellModel.titleText;
    self.contentLab.text = personalListCellModel.contentText;
    self.bgView.backgroundColor = [UIColor blackColor];
    if (personalListCellModel.cellType == MGPersonalCellTypePointsDetails ||
        personalListCellModel.cellType == MGPersonalCellTypeContactUs) {
        self.bgView.frame = CGRectMake(20, 0, self.contentView.lv_width - 40, 53);
        [self.bgView lp_setImageWithRadius:LPRadiusMake(16, 16, 0, 0) image:nil borderColor:nil borderWidth:0 backgroundColor:HEX_COLOR(0x15161A) contentMode:0 forState:0 completion:nil];
    } else if (personalListCellModel.cellType == MGPersonalCellTypeInviteFriends ||
               personalListCellModel.cellType == MGPersonalCellTypeApplicationVersion) {
        self.bgView.frame = CGRectMake(20, 0, self.contentView.lv_width - 40, 53);
        [self.bgView lp_setImageWithRadius:LPRadiusMake(0, 0, 16, 16) image:nil borderColor:nil borderWidth:0 backgroundColor:HEX_COLOR(0x15161A) contentMode:0 forState:0 completion:nil];
    } else {
        self.bgView.backgroundColor = HEX_COLOR(0x15161A);
    }
}

@end
