//
//  MGMineListCell.m
//  Magina
//
//  Created by mac on 2025/8/15.
//

#import "MGMineListCell.h"

@interface MGMineListCell ()

@property (weak, nonatomic) IBOutlet UIImageView *contentImageView;

@end

@implementation MGMineListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    
    self.contentImageView.image = [UIImage imageNamed:@"MG_home_getPoints_free_alert_bg"];
}

@end
