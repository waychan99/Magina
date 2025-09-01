//
//  MGTemplateDetailsCell.m
//  Magina
//
//  Created by 陈志伟 on 2025/8/24.
//

#import "MGTemplateDetailsCell.h"
#import "MGTemplateListModel.h"
#import <FLAnimatedImage/FLAnimatedImage.h>

@interface MGTemplateDetailsCell ()
@property (weak, nonatomic) IBOutlet FLAnimatedImageView *mainImageView;
@property (weak, nonatomic) IBOutlet UIView *btnBgView;
@property (weak, nonatomic) IBOutlet UIButton *thinBtn;
@property (weak, nonatomic) IBOutlet UIButton *fatBtn;
@property (nonatomic, strong) NSData *imageLoadingGifData;
@end

@implementation MGTemplateDetailsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.mainImageView.layer.cornerRadius = 17.0f;
    self.mainImageView.layer.masksToBounds = YES;
    self.mainImageView.contentMode = UIViewContentModeScaleAspectFill;
    
    self.btnBgView.backgroundColor = [UIColor colorWithWhite:.3 alpha:.4];
}

- (void)prepareForReuse {
    [super prepareForReuse];
    
    self.mainImageView.image = nil;
}

- (void)setListModel:(MGTemplateListModel *)listModel {
    _listModel = listModel;
    
//    if (listModel.bodyTye == 0) {
//        self.thinBtn.selected = YES;
//        self.fatBtn.selected = NO;
//        if (listModel.standardImgs.count > 0) {
//            [self loadImageWithUrlString:listModel.standardImgs.firstObject];
//        }
//    } else {
//        self.thinBtn.selected = NO;
//        self.fatBtn.selected = YES;
//        if (listModel.fatImgs.count > 0) {
//            [self loadImageWithUrlString:listModel.fatImgs.firstObject];
//        }
//    }
    
    [self loadImageWithUrlString:listModel.standardImgs.firstObject];
}

- (void)loadImageWithUrlString:(NSString *)urlString {
//    [[SDImageCache sharedImageCache] queryCacheOperationForKey:urlString done:^(UIImage * _Nullable image, NSData * _Nullable data, SDImageCacheType cacheType) {
//        if (image) {
//            self.mainImageView.image = image;
//        } else {
//            self.mainImageView.animatedImage = [FLAnimatedImage animatedImageWithGIFData:self.imageLoadingGifData];
//            [self.mainImageView sd_setImageWithURL:[NSURL URLWithString:urlString] placeholderImage:nil options:SDWebImageScaleDownLargeImages context:@{SDWebImageContextImageThumbnailPixelSize : [NSValue valueWithCGSize:CGSizeMake(self.mainImageView.lv_width * 3.0, self.mainImageView.lv_height * 3.0)]}];
//        }
//    }];
    self.mainImageView.animatedImage = [FLAnimatedImage animatedImageWithGIFData:self.imageLoadingGifData];
    [self.mainImageView sd_setImageWithURL:[NSURL URLWithString:urlString] placeholderImage:nil options:SDWebImageScaleDownLargeImages context:@{SDWebImageContextImageThumbnailPixelSize : [NSValue valueWithCGSize:CGSizeMake(self.mainImageView.lv_width * 3.0, self.mainImageView.lv_height * 3.0)]}];
}

//- (IBAction)clickThinBtn:(UIButton *)sender {
//    sender.backgroundColor = HEX_COLOR(0xEA4C89);
//    self.fatBtn.backgroundColor = [UIColor colorWithWhite:.0 alpha:.0];
//    self.listModel.bodyTye = 0;
//    if (self.listModel.standardImgs.count > 0) {
//        [self loadImageWithUrlString:self.listModel.standardImgs.firstObject];
//    }
//}
//
//- (IBAction)clickFatBtn:(UIButton *)sender {
//    sender.backgroundColor = HEX_COLOR(0xEA4C89);
//    self.thinBtn.backgroundColor = [UIColor colorWithWhite:.0 alpha:.0];
//    self.listModel.bodyTye = 1;
//    if (self.listModel.fatImgs.count > 0) {
//        [self loadImageWithUrlString:self.listModel.fatImgs.firstObject];
//    }
//}

- (NSData *)imageLoadingGifData {
    if (!_imageLoadingGifData) {
        NSString *gifPath = [[NSBundle mainBundle] pathForResource:@"left_loading" ofType:@"gif"];
        _imageLoadingGifData = [NSData dataWithContentsOfFile:gifPath];
    }
    return _imageLoadingGifData;
}

@end
