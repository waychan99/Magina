//
//  MGPhotoListCell.m
//  Magina
//
//  Created by 陈志伟 on 2025/8/21.
//

#import "MGPhotoListCell.h"

@interface MGPhotoListCell ()
@property (weak, nonatomic) IBOutlet UIImageView *contentImageView;

@end

@implementation MGPhotoListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.contentImageView.image = [UIImage imageNamed:@"MG_home_getPoints_free_alert_bg"];
}

@end
