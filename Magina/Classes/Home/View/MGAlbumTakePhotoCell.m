//
//  MGAlbumTakePhotoCell.m
//  Magina
//
//  Created by mac on 2025/8/21.
//

#import "MGAlbumTakePhotoCell.h"
#import "MGAssetModel.h"

@interface MGAlbumTakePhotoCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation MGAlbumTakePhotoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.imageView.clipsToBounds = YES;
}

- (void)setAssetModel:(MGAssetModel *)assetModel {
    _assetModel = assetModel;
    
    self.imageView.image = [UIImage imageNamed:@"MG_takePhoto_icon"];
}
    
@end
