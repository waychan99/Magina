//
//  MGAlbumPhotoListCell.m
//  Magina
//
//  Created by mac on 2025/8/20.
//

#import "MGAlbumPhotoListCell.h"
#import "MGAssetModel.h"
#import "MGImageManager.h"

@interface MGAlbumPhotoListCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation MGAlbumPhotoListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.imageView.clipsToBounds = YES;
}

- (void)setAssetModel:(MGAssetModel *)assetModel {
    _assetModel = assetModel;
    
    self.representedAssetIdentifier = assetModel.asset.localIdentifier;
    int32_t imageRequestID = [[MGImageManager shareInstance] getPhotoWithAsset:assetModel.asset photoWidth:self.lv_width completion:^(UIImage * _Nonnull photo, NSDictionary * _Nonnull info, BOOL isDegraded) {
        if ([self.representedAssetIdentifier isEqualToString:assetModel.asset.localIdentifier]) {
            self.imageView.image = photo;
            [self setNeedsLayout];
        } else {
            // NSLog(@"this cell is showing other asset");
            [[PHImageManager defaultManager] cancelImageRequest:self.imageRequestID];
        }
    } progressHandler:nil networkAccessAllowed:NO];
    if (imageRequestID && self.imageRequestID && imageRequestID != self.imageRequestID) {
        [[PHImageManager defaultManager] cancelImageRequest:self.imageRequestID];
    }
    self.imageRequestID = imageRequestID;
}

- (CGFloat)mg_albumPhotoListCellWidth {
    return self.frame.size.width;
}


@end
