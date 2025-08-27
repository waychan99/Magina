//
//  MGGeneratedListCell.m
//  Magina
//
//  Created by mac on 2025/8/27.
//

#import "MGGeneratedListCell.h"

@interface MGGeneratedListCell ()
@property (weak, nonatomic) IBOutlet UIImageView *mainImageView;
@end

@implementation MGGeneratedListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.mainImageView.layer.cornerRadius = 13.0f;
    self.mainImageView.layer.masksToBounds = YES;
    self.mainImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.mainImageView.backgroundColor = [UIColor blueColor];
}

@end
