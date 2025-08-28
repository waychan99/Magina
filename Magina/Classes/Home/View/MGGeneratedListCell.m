//
//  MGGeneratedListCell.m
//  Magina
//
//  Created by mac on 2025/8/27.
//

#import "MGGeneratedListCell.h"
#import <FLAnimatedImage/FLAnimatedImage.h>
#import "NSString+LP.h"

@interface MGGeneratedListCell ()
@property (weak, nonatomic) IBOutlet FLAnimatedImageView *mainImageView;
@property (nonatomic, strong) NSData *leftImageLoadingGifData;
@property (nonatomic, strong) NSData *rightImageLoadingGifData;
@end

@implementation MGGeneratedListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.mainImageView.layer.cornerRadius = 13.0f;
    self.mainImageView.layer.masksToBounds = YES;
    self.mainImageView.contentMode = UIViewContentModeScaleAspectFill;
}

- (void)setWorksModel:(MGImageWorksModel *)worksModel {
    _worksModel = worksModel;
    
    if (self.tag % 2 == 0) {
        if (self.tag < worksModel.generatedImageWorksList.count) {
            NSString *imageName = [worksModel.downloadedImagePathInfo objectForKey:worksModel.generatedImageWorksList[self.tag]];
            if (imageName.length > 0) {
                NSString *imagePath = [NSString lp_documentFilePathWithFileName:[NSString stringWithFormat:@"%@/%@", MG_IMAGE_WORKS_FILES_DIRECTORY_PATH, imageName]];
                self.mainImageView.image = [UIImage imageWithContentsOfFile:imagePath];
            } else {
                self.mainImageView.animatedImage = [FLAnimatedImage animatedImageWithGIFData:self.leftImageLoadingGifData];
            }
        } else {
            self.mainImageView.animatedImage = [FLAnimatedImage animatedImageWithGIFData:self.leftImageLoadingGifData];
        }
    } else if (self.tag % 2 == 1) {
        if (self.tag < worksModel.generatedImageWorksList.count) {
            NSString *imageName = [worksModel.downloadedImagePathInfo objectForKey:worksModel.generatedImageWorksList[self.tag]];
            if (imageName.length > 0) {
                NSString *imagePath = [NSString lp_documentFilePathWithFileName:[NSString stringWithFormat:@"%@/%@", MG_IMAGE_WORKS_FILES_DIRECTORY_PATH, imageName]];
                self.mainImageView.image = [UIImage imageWithContentsOfFile:imagePath];
            } else {
                self.mainImageView.animatedImage = [FLAnimatedImage animatedImageWithGIFData:self.rightImageLoadingGifData];
            }
        } else {
            self.mainImageView.animatedImage = [FLAnimatedImage animatedImageWithGIFData:self.rightImageLoadingGifData];
        }
    }
}

- (NSData *)leftImageLoadingGifData {
    if (!_leftImageLoadingGifData) {
        NSString *gifPath = [[NSBundle mainBundle] pathForResource:@"left_loading" ofType:@"gif"];
        _leftImageLoadingGifData = [NSData dataWithContentsOfFile:gifPath];
    }
    return _leftImageLoadingGifData;
}

- (NSData *)rightImageLoadingGifData {
    if (!_rightImageLoadingGifData) {
        NSString *gifPath = [[NSBundle mainBundle] pathForResource:@"right_loading" ofType:@"gif"];
        _rightImageLoadingGifData = [NSData dataWithContentsOfFile:gifPath];
    }
    return _rightImageLoadingGifData;
}

@end
