//
//  MGFaceResultCell.m
//  Magina
//
//  Created by 陈志伟 on 2025/8/24.
//

#import "MGFaceResultCell.h"

@interface MGFaceResultCell ()

@end

@implementation MGFaceResultCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.contentImageView.layer.borderColor = [UIColor whiteColor].CGColor;
}

- (IBAction)clickDeleteFaceBtn:(UIButton *)sender {
    !self.deleteFaceCallback ?: self.deleteFaceCallback(sender, self.tag);
}


@end
