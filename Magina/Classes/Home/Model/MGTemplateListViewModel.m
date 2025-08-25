//
//  MGTemplateListViewModel.m
//  Magina
//
//  Created by 陈志伟 on 2025/8/24.
//

#import "MGTemplateListViewModel.h"
#import "MGTemplateListModel.h"

@implementation MGTemplateListViewModel

- (void)setListModel:(MGTemplateListModel *)listModel {
    _listModel = listModel;
    
    CGFloat cellW = ([UIScreen mainScreen].bounds.size.width - (MGHomeListCellBorderW * 2) - MGHomeListCellMargin) / 2;
    
    CGFloat contentImageViewW = cellW;
    CGFloat contentImageViewH = (cellW * 240) / 180;
    
    self.contentImageViewF = CGRectMake(0, 0, contentImageViewW, contentImageViewH);
    
    CGFloat titleLabY = CGRectGetMaxY(self.contentImageViewF) + 17;
    CGFloat titleLabW = cellW - 17 - 13;
    CGFloat titleLabH = [self sizeWithFont:[UIFont systemFontOfSize:12.0 weight:UIFontWeightSemibold] maxW:titleLabW text:listModel.title].height;
    self.titleLabF = CGRectMake(15, titleLabY, titleLabW, titleLabH);
    self.cellHeight = CGRectGetMaxY(self.titleLabF) + 21;
}

- (CGSize)sizeWithFont:(UIFont *)font maxW:(CGFloat)maxW text:(NSString *)text {
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = font;
    CGSize maxSize = CGSizeMake(maxW, MAXFLOAT);
    return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}

@end
