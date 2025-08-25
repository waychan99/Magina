//
//  MGHomeListCell.m
//  Magina
//
//  Created by mac on 2025/8/13.
//

#import "MGHomeListCell.h"
#import "MGTemplateListModel.h"
#import "MGTemplateListViewModel.h"

@interface MGHomeListCell ()
@property (nonatomic, weak) UIImageView *topImageView;
@property (nonatomic, weak) UILabel *titleLab;
@end

@implementation MGHomeListCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUIComponents];
    }
    return self;
}

- (void)setupUIComponents {
    UIImageView *topImageView = [[UIImageView alloc] init];
    topImageView.layer.cornerRadius = 13.0f;
    topImageView.layer.masksToBounds = YES;
    topImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.contentView addSubview:topImageView];
    self.topImageView = topImageView;
    
    UILabel *titleLab = [[UILabel alloc] init];
    titleLab.textColor = [UIColor whiteColor];
    titleLab.font = [UIFont systemFontOfSize:12.0 weight:UIFontWeightSemibold];
    titleLab.textAlignment = NSTextAlignmentLeft;
    titleLab.numberOfLines = 0;
    [self.contentView addSubview:titleLab];
    self.titleLab = titleLab;
}

- (void)setTemplateListViewModel:(MGTemplateListViewModel *)templateListViewModel {
    _templateListViewModel = templateListViewModel;
    
    self.topImageView.frame = templateListViewModel.contentImageViewF;
    [self.topImageView sd_setImageWithURL:[NSURL URLWithString:templateListViewModel.listModel.change_face_thumbnai] placeholderImage:nil];
    
    self.titleLab.frame = templateListViewModel.titleLabF;
    self.titleLab.text = templateListViewModel.listModel.title;
}

@end
