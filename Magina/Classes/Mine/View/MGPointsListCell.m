//
//  MGPointsListCell.m
//  Magina
//
//  Created by mac on 2025/8/18.
//

#import "MGPointsListCell.h"
#import "MGPointsDetailsModel.h"

@interface MGPointsListCell ()
@property (weak, nonatomic) IBOutlet UILabel *detailsLab;
@property (weak, nonatomic) IBOutlet UILabel *gettingTimeLab;
@property (weak, nonatomic) IBOutlet UILabel *pointsAmountLab;
@end

@implementation MGPointsListCell

- (void)awakeFromNib {
    [super awakeFromNib];
   
}

- (void)setPointsDetailsModel:(MGPointsDetailsModel *)pointsDetailsModel {
    _pointsDetailsModel = pointsDetailsModel;
    
    self.detailsLab.text = pointsDetailsModel.desc;
    self.gettingTimeLab.text = pointsDetailsModel.create_time;
    if (pointsDetailsModel.symbol == 0) {
        self.pointsAmountLab.textColor = HEX_COLOR(0x06CA8B);
        self.pointsAmountLab.text = [NSString stringWithFormat:@"+%zd", pointsDetailsModel.integral];
    } else {
        self.pointsAmountLab.textColor = HEX_COLOR(0xFFFC05);
        self.pointsAmountLab.text = [NSString stringWithFormat:@"-%zd", pointsDetailsModel.integral];
    }
}

@end
