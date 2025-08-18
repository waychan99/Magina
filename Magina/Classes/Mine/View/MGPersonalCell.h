//
//  MGPersonalCell.h
//  Magina
//
//  Created by mac on 2025/8/18.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, MGPersonalCellType) {
    MGPersonalCellTypePointsDetails,
    MGPersonalCellTypeInviteFriends,
    MGPersonalCellTypeContactUs,
    MGPersonalCellTypePrivacyPolicy,
    MGPersonalCellTypeApplicationVersion
};

static NSString * const MGPersonalCellKey = @"MGPersonalCell";

@interface EJPersonalListCellModel : NSObject

@property (nonatomic, assign) MGPersonalCellType cellType;
@property (nonatomic, copy) NSString *titleText;
@property (nonatomic, copy) NSString *contentText;
@property (nonatomic, copy) NSString *jumbController;

+ (NSMutableArray<NSMutableArray *> *)loadDataSource;

@end

@interface MGPersonalCell : UITableViewCell

@property (weak, nonatomic, readonly) IBOutlet UIView *lineView;

@property (nonatomic, strong) EJPersonalListCellModel *personalListCellModel;

@end

NS_ASSUME_NONNULL_END
