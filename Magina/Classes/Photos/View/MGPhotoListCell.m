//
//  MGPhotoListCell.m
//  Magina
//
//  Created by 陈志伟 on 2025/8/21.
//

#import "MGPhotoListCell.h"
#import "MGFavoriteTemplateModel.h"
#import "NSString+LP.h"

@interface MGPhotoListCell ()
@property (weak, nonatomic) IBOutlet UIImageView *contentImageView;

@end

@implementation MGPhotoListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.contentImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.contentImageView.layer.masksToBounds = YES;
}

- (void)setFavoriteModel:(MGFavoriteTemplateModel *)favoriteModel {
    _favoriteModel = favoriteModel;
    
    [self.contentImageView sd_setImageWithURL:[NSURL URLWithString:favoriteModel.template_img] placeholderImage:nil];
}

- (void)setWorksModel:(MGImageWorksModel *)worksModel {
    _worksModel = worksModel;
    
    if (worksModel.generatedImageWorksList.count > 0) {
        NSString *imageName = [worksModel.downloadedImagePathInfo objectForKey:worksModel.generatedImageWorksList.firstObject];
        NSString *imagePath = [NSString lp_documentFilePathWithFileName:[NSString stringWithFormat:@"%@/%@", MG_IMAGE_WORKS_FILES_DIRECTORY_PATH, imageName]];
        self.contentImageView.image = [UIImage imageWithContentsOfFile:imagePath];
    }
}

@end
