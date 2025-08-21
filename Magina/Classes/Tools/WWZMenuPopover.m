//
//  WWZMenuPopover.m
//  SmartOrange
//
//  Created by Orange on 2018/12/13.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "WWZMenuPopover.h"

#define kColorFromRGBA(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:a]

#define kReuseCellId @"MenuPopoverCell"

#define kBottomLineColor kColorFromRGBA(0, 0, 0, 0.2)

static NSTimeInterval kAnimationDuration = 0.3;

#pragma mark - cell

@interface WWZMenuCell : UITableViewCell

/**
 *  是否为最后一行cell
 */
@property (nonatomic, assign) BOOL isLastCell;

@property (nonatomic, strong) UIView *lineView;

+ (instancetype)wwz_menuCellWithTableView:(UITableView *)tableView;

@end

@implementation WWZMenuCell

+ (instancetype)wwz_menuCellWithTableView:(UITableView *)tableView{
    
    static NSString *reuseIdentifier = @"reuseCellID";
    WWZMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (!cell) {
        cell = [[self alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
//        self.textLabel.textColor = kColorFromRGBA(51, 51, 51, 1);
        self.textLabel.textColor = [UIColor blackColor];
        self.backgroundColor = [UIColor clearColor];
//        [self.contentView addSubview:self.lineView];
        //设置选中的背景
        self.selectedBackgroundView = [[UIView alloc] init];
        self.selectedBackgroundView.backgroundColor = kColorFromRGBA(217, 217, 217, 1);
    }
    return self;
}

/**
 *  隐藏最后cell分割线
 */
- (void)setIsLastCell:(BOOL)isLastCell{
    
    self.lineView.hidden = isLastCell;
}

/**
 *  分割线
 */
- (UIView *)lineView{
    if (!_lineView) {
        
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = kBottomLineColor;
    }
    return _lineView;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    self.lineView.frame = CGRectMake(10, self.frame.size.height-0.5, self.frame.size.width-20, 0.5);
}

@end

#pragma mark - WWZMenuPopover

@interface WWZMenuPopover ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

/**
 *  文本
 */
@property (nonatomic, strong) NSArray *titles;

/**
 *  图片
 */
@property (nonatomic, strong) NSArray *imageNames;
/**
 *  完全显示后的视图中心
 */
@property (nonatomic, assign) CGPoint finalCenter;

@end

@implementation WWZMenuPopover

+ (instancetype)wwz_menuPopoverWithViewWidth:(CGFloat)viewWidth
                                      titles:(NSArray *)titles
                                  imageNames:(NSArray *)imageNames{

    return [[self alloc] initWithViewWidth:viewWidth titles:titles imageNames:imageNames];
}

- (instancetype)initWithViewWidth:(CGFloat)viewWidth
                           titles:(NSArray *)titles
                       imageNames:(NSArray *)imageNames
{
    if (viewWidth == 0) viewWidth = 130.0;
    
    self = [self initWithFrame:CGRectMake(0, 0, viewWidth, 0)];
    
    if (self) {
        
        _titles = titles;
        
        _imageNames = imageNames;
        
        [self wwz_setInitContentValue];
        
    }
    return self;
}

/**
 *  初始设置
 */
- (void)wwz_setInitContentValue{
    
    _cornerRadius = 7.50;
    
    _anchorColor = [UIColor whiteColor];
    
    _titleFont = [UIFont systemFontOfSize:13.0];
    
    _lineColor = kColorFromRGBA(0, 0, 0, 0.2);
    
    _selectedBackColor = kColorFromRGBA(217, 217, 217, 1);
    
    CGFloat space = UI_SCREEN_W == 414.0 ? 10 : 5;
    
    self.anchorPoint = CGPointMake(UI_SCREEN_W - space - 39*0.5, 64.0);
    
    self.cellHeight = 45.0;
    
    self.pointerFrame = CGRectMake(self.frame.size.width-10-_cornerRadius*2, 0, 10, 6.5);
    
    self.backgroundColor = [UIColor clearColor];
    
    [self addSubview:self.tableView];
}


#pragma mark - setter

/**
 *  设置锚点
 */
- (void)setAnchorPoint:(CGPoint)anchorPoint{
    
    _anchorPoint = anchorPoint;
    
    CGRect frame = self.frame;
    frame.origin.y = _anchorPoint.y;
    frame.origin.x = _anchorPoint.x - _pointerFrame.size.width*0.5 - _pointerFrame.origin.x;
    self.frame = frame;
    
    _finalCenter = self.center;
}

/**
 *  cell 高度
 */
- (void)setCellHeight:(CGFloat)cellHeight{
    
    _cellHeight = cellHeight;
    
    CGRect frame = self.frame;
    
    frame.size.height = _cellHeight*self.titles.count + _pointerFrame.size.height;
    
    self.frame = frame;
    
    self.tableView.frame = CGRectMake(0, CGRectGetMaxY(_pointerFrame), self.frame.size.width, self.frame.size.height - CGRectGetMaxY(_pointerFrame));
    
    _finalCenter = self.center;
}

/**
 *  设置锚三角形frame
 */
- (void)setPointerFrame:(CGRect)pointerFrame{
    
    _pointerFrame = pointerFrame;
    
    CGRect frame = self.frame;
    
    frame.origin.x = _anchorPoint.x - _pointerFrame.size.width*0.5 - _pointerFrame.origin.x;
    frame.size.height = _cellHeight*self.titles.count + _pointerFrame.size.height;
    
    self.frame = frame;
    
    self.tableView.frame = CGRectMake(0, CGRectGetMaxY(_pointerFrame), self.frame.size.width, self.frame.size.height - CGRectGetMaxY(_pointerFrame));
    
    _finalCenter = self.center;
}
/**
 *  设置背景色
 */
- (void)setBackColor:(UIColor *)backColor{
    
    _backColor = backColor;
    
    self.tableView.backgroundColor = backColor;
}
/**
 *  圆角半径
 */
- (void)setCornerRadius:(CGFloat)cornerRadius{
    
    _cornerRadius = cornerRadius;
    
    self.tableView.layer.cornerRadius = _cornerRadius;
}



#pragma mark UITableViewDatasource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return _cellHeight;
}

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section{
    
    return _titles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    WWZMenuCell *cell = [WWZMenuCell wwz_menuCellWithTableView:tableView];
    
    cell.isLastCell = _titles.count == indexPath.row + 1;

    if (_titles.count > indexPath.row) {
        cell.textLabel.text = _titles[indexPath.row];
    }
    if (_imageNames.count > indexPath.row) {
        cell.imageView.image = [UIImage imageNamed:_imageNames[indexPath.row]];
    }
    
    cell.textLabel.font = _titleFont;
    cell.textLabel.textColor = _titleColor;
    cell.lineView.backgroundColor = _lineColor;
    cell.selectedBackgroundView.backgroundColor = _selectedBackColor;
    return cell;
}

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self wwz_hide];
    
    if ([_menuDelegate respondsToSelector:@selector(menuPopover:didSelectedItemAtIndex:)]   ) {
        [_menuDelegate menuPopover:self didSelectedItemAtIndex:indexPath.row];
    }
}


#pragma mark Actions
/**
 *  显示
 */
- (void)wwz_show{
    
    // 背景
    UIButton *backView = [[UIButton alloc] initWithFrame:[UIScreen mainScreen].bounds];
    backView.backgroundColor = kColorFromRGBA(0, 0, 0, 0.4);
    [backView addTarget:self action:@selector(wwz_hide) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:self];

    // 添加到window上
    [[UIApplication sharedApplication].keyWindow addSubview:backView];
    
    // 动画
    self.transform = CGAffineTransformMakeScale(0.01, 0.01);
    
    self.center = _anchorPoint;
    
    backView.alpha = 0;
    
    [UIView animateWithDuration:kAnimationDuration animations:^{
        
        self.transform = CGAffineTransformMakeScale(1, 1);
        //缩小到指定的位置
        self.center = _finalCenter;
        
        backView.alpha = 1.0;
        
    }];
}
/**
 *  隐藏
 */
- (void)wwz_hide{
    
    [UIView animateWithDuration:kAnimationDuration animations:^{
        
        self.transform = CGAffineTransformMakeScale(0.01, 0.01);
        //缩小到指定的位置
        self.center = _anchorPoint;
        
        self.superview.alpha = 0.0;
        
    }completion:^(BOOL finished) {
        
        [self.superview removeFromSuperview];
        [self removeFromSuperview];
        
    }];
}

- (UITableView *)tableView{
    if (!_tableView) {
        
        // Adding menu Items table
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.scrollEnabled = NO;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.layer.masksToBounds = YES;
        _tableView.layer.cornerRadius = _cornerRadius;
    }
    return _tableView;
}

/**
 *  画三角形
 */
- (void)drawRect:(CGRect)rect{
    
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint:CGPointMake(CGRectGetMaxX(_pointerFrame), CGRectGetMaxY(_pointerFrame))];
    [bezierPath addLineToPoint:CGPointMake(_pointerFrame.origin.x, CGRectGetMaxY(_pointerFrame))];
    [bezierPath addLineToPoint:CGPointMake(CGRectGetMidX(_pointerFrame), _pointerFrame.origin.y)];
    [bezierPath addLineToPoint:CGPointMake(CGRectGetMaxX(_pointerFrame), CGRectGetMaxY(_pointerFrame))];

    [_anchorColor set];
    
    [bezierPath fill];
}
- (void)dealloc{
    NSLog(@"%s", __func__);
}
@end
