//
//  MGHomeListCell.m
//  Magina
//
//  Created by mac on 2025/8/13.
//

#import "MGHomeListCell.h"
#import "MGTemplateListModel.h"

@interface MGHomeListCell ()
@property (weak, nonatomic) IBOutlet UIImageView *topImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@end

@implementation MGHomeListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.topImageView.layer.cornerRadius = 13.0f;
    self.topImageView.contentMode = UIViewContentModeScaleAspectFill;
}

- (void)setTemplateListModel:(MGTemplateListModel *)templateListModel {
    _templateListModel = templateListModel;
    
    [self.topImageView sd_setImageWithURL:[NSURL URLWithString:templateListModel.change_face_thumbnai] placeholderImage:nil];
    self.titleLab.text = templateListModel.title;
}

@end
