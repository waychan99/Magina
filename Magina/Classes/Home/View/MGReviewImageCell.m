//
//  MGReviewImageCell.m
//  Magina
//
//  Created by mac on 2025/8/28.
//

#import "MGReviewImageCell.h"
#import "NSString+LP.h"

@interface MGReviewImageCell ()<UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIImageView *imageView;
@end

@implementation MGReviewImageCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.scrollView = [[UIScrollView alloc]initWithFrame:self.contentView.bounds];
        self.scrollView.minimumZoomScale = MINZOOMSCALE;
        self.scrollView.maximumZoomScale = MAXZOOMSCALE;
        self.scrollView.bounces = NO;
        self.scrollView.delegate = self;
        self.scrollView.showsVerticalScrollIndicator = NO;
        self.scrollView.showsHorizontalScrollIndicator = NO;
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction)];
//        [self.scrollView addGestureRecognizer:tap];
        [self.contentView addSubview:self.scrollView];
        self.imageView = [[UIImageView alloc]initWithFrame:frame];
        self.imageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doubleClickAction:)];
        doubleTap.numberOfTouchesRequired = 1;
        doubleTap.numberOfTapsRequired = 2;
        [self.imageView addGestureRecognizer:doubleTap];
        //优先触发双击手势
//        [tap requireGestureRecognizerToFail:doubleTap];
        [self.scrollView addSubview:self.imageView];
    }
    return self;
}

- (void)doubleClickAction:(UIGestureRecognizer *)gesture {
    CGFloat k = MAXZOOMSCALE;
    UIScrollView *scrollView = (UIScrollView *)gesture.view.superview;
    CGFloat width = gesture.view.frame.size.width;
    CGFloat height = gesture.view.frame.size.height;
    CGPoint point = [gesture locationInView:gesture.view];
    //获取双击坐标，分4种情况计算scrollview的contentoffset
    if (point.x<=width/2 && point.y<=height/2) {
        point = CGPointMake(point.x*k, point.y*k);
        point = CGPointMake(point.x-UI_SCREEN_W/2>0?point.x-UI_SCREEN_W/2:0,point.y-UI_SCREEN_H/2>0?point.y-UI_SCREEN_H/2:0);
    } else if (point.x<=width/2 && point.y>height/2) {
        point = CGPointMake(point.x*k, (height-point.y)*k);
        point = CGPointMake(point.x-UI_SCREEN_W/2>0?point.x-UI_SCREEN_W/2:0,point.y>UI_SCREEN_H/2?height*k-point.y-UI_SCREEN_H/2:height*k>UI_SCREEN_H?height*k-UI_SCREEN_H:0);
    } else if (point.x>width/2 && point.y<=height/2) {
        point = CGPointMake((width-point.x)*k, point.y*k);
        point = CGPointMake(point.x>UI_SCREEN_W/2?width*k-point.x-UI_SCREEN_W/2:width*k>UI_SCREEN_W?width*k-UI_SCREEN_W:0, point.y-UI_SCREEN_H/2>0?point.y-UI_SCREEN_H/2:0);
    } else {
        point = CGPointMake((width-point.x)*k, (height-point.y)*k);
        point = CGPointMake(point.x>UI_SCREEN_W/2?width*k-point.x-UI_SCREEN_W/2:width*k>UI_SCREEN_W?width*k-UI_SCREEN_W:0, point.y>UI_SCREEN_H/2?height*k-point.y-UI_SCREEN_H/2:height*k>UI_SCREEN_H?height*k-UI_SCREEN_H:0);
    }
    
    if (scrollView.zoomScale == 1) {
        [UIView animateWithDuration:0.3 animations:^{
            scrollView.zoomScale = k;
            scrollView.contentOffset = point;
        } completion:^(BOOL finished) {
            
        }];
    } else {
        [UIView animateWithDuration:0.3 animations:^{
            scrollView.zoomScale = 1;
        }];
    }
}

- (void)setWorksModel:(MGImageWorksModel *)worksModel {
    _worksModel = worksModel;
    
    if (self.tag < worksModel.generatedImageWorksList.count) {
        NSString *imageName = [worksModel.downloadedImagePathInfo objectForKey:worksModel.generatedImageWorksList[self.tag]];
        if (imageName.length > 0) {
            NSString *imagePath = [NSString lp_documentFilePathWithFileName:[NSString stringWithFormat:@"%@/%@", MG_IMAGE_WORKS_FILES_DIRECTORY_PATH, imageName]];
            UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
            [self setupImage:image];
        }
    }
}

- (void)setupImage:(UIImage *)image {
    if (!image) return;
    self.scrollView.zoomScale = 1;  //重置zoomscale为1
    self.imageView.image = image;
    CGFloat scrollView_W = self.scrollView.lv_width;
    CGFloat scrollView_H = self.scrollView.lv_height;
    CGFloat x = scrollView_H / scrollView_W;
    CGFloat y = image.size.height/image.size.width;
    //x为屏幕尺寸，y为图片尺寸，通过两个尺寸的比较，重置imageview的frame
    if (y>x) {
        self.imageView.frame = CGRectMake(0, 0, scrollView_H / y, scrollView_H);
    } else {
        self.imageView.frame = CGRectMake(0, 0, scrollView_W, scrollView_W * y);
    }
    self.imageView.center = CGPointMake(scrollView_W / 2, scrollView_H / 2);
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width)?
    (scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5 : 0.0;
    CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height)?
    (scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5 : 0.0;
    scrollView.subviews[0].center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX,
                                                scrollView.contentSize.height * 0.5 + offsetY);
}

- (void)setCellZoomScale:(NSUInteger)cellZoomScale {
    _cellZoomScale = cellZoomScale;
    
    self.scrollView.zoomScale = cellZoomScale;
}

@end
