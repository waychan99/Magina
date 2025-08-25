//
//  MGTemplateDetailsCell.m
//  Magina
//
//  Created by 陈志伟 on 2025/8/24.
//

#import "MGTemplateDetailsCell.h"
#import "MGTemplateListModel.h"

@interface MGTemplateDetailsCell ()
@property (weak, nonatomic) IBOutlet UIImageView *mainImageView;
@property (weak, nonatomic) IBOutlet UIView *btnBgView;
@property (weak, nonatomic) IBOutlet UIButton *thinBtn;
@property (weak, nonatomic) IBOutlet UIButton *fatBtn;
@end

@implementation MGTemplateDetailsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.mainImageView.layer.cornerRadius = 17.0f;
    self.mainImageView.layer.masksToBounds = YES;
    self.mainImageView.contentMode = UIViewContentModeScaleAspectFill;
    
    self.btnBgView.backgroundColor = [UIColor colorWithWhite:.3 alpha:.4];
}

- (void)setListModel:(MGTemplateListModel *)listModel {
    _listModel = listModel;
    
    [self.mainImageView sd_setImageWithURL:[NSURL URLWithString:listModel.change_face_thumbnai] placeholderImage:nil];
}
- (IBAction)clickThinBtn:(UIButton *)sender {
    sender.backgroundColor = HEX_COLOR(0xEA4C89);
    self.fatBtn.backgroundColor = [UIColor colorWithWhite:.0 alpha:.0];
}

- (IBAction)clickFatBtn:(UIButton *)sender {
    sender.backgroundColor = HEX_COLOR(0xEA4C89);
    self.thinBtn.backgroundColor = [UIColor colorWithWhite:.0 alpha:.0];
}

@end
