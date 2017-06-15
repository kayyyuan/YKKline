//
//  YKSegmentView.m
//  YKKline
//
//  Created by nethanhan on 2017/6/15.
//  Copyright © 2017年 nethanhan. All rights reserved.
//

#import "YKSegmentView.h"

@interface YKSegmentView()

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSArray *btnArray;
@property (nonatomic, strong) NSArray *titleArray;

@property (nonatomic, assign) NSUInteger oldIndex;
@property (nonatomic, assign) NSUInteger newIndex;
@end

@implementation YKSegmentView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self initSegmentView];
    }
    
    return self;
}

- (void)initSegmentView
{
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
//    _scrollView.backgroundColor = [UIColor redColor];
    NSDictionary *attribute = @{NSFontAttributeName:[UIFont systemFontOfSize:12.f]};
    float x = 0;
    NSMutableArray *btnArr = [NSMutableArray array];
    for (int idx = 0; idx<self.titleArray.count; idx++)
    {
        NSString *str = self.titleArray[idx];
        
        CGRect strRect = [self rectOfNSString:str attribute:attribute];
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(x, 0, strRect.size.width+30, CGRectGetHeight(self.frame))];
        btn.tag = idx + 1000;
//        btn.layer.borderWidth = 1.f;
//        btn.layer.borderColor = [UIColor yellowColor].CGColor;
        btn.titleLabel.font = [UIFont systemFontOfSize:12.f];
        [btn setTitle:str forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
        
        [btn addTarget:self action:@selector(didClickWitnBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        x += (strRect.size.width+30);
        [btnArr addObject:btn];
        
        [_scrollView addSubview:btn];
    }
    _scrollView.contentSize =CGSizeMake(x, CGRectGetHeight(self.frame));
    
    _btnArray = [NSArray arrayWithArray:btnArr];
    
    [self addSubview:_scrollView];
    
    _oldIndex = 99999;
    _newIndex = 0;
    
    [self didClickWitnBtn:self.btnArray[_newIndex]];
}

- (void)didClickWitnBtn:(UIButton *)btn
{
    _oldIndex = _newIndex;
    _newIndex = btn.tag - 1000;
    
    if (_oldIndex < self.titleArray.count)
    {
        UIButton *oldBtn = self.btnArray[_oldIndex];
        oldBtn.selected = NO;
    }
    if (_newIndex < self.titleArray.count)
    {
        UIButton *newBtn = self.btnArray[_newIndex];
        newBtn.selected = YES;
    }
    
    if ((btn.center.x > CGRectGetWidth(_scrollView.frame)/2) &&
        ((_scrollView.contentSize.width - CGRectGetWidth(_scrollView.frame)/2)>btn.center.x))
    {
        CGPoint offsetPoint = CGPointMake(btn.center.x-CGRectGetWidth(_scrollView.frame)/2, 0);
        [_scrollView setContentOffset:offsetPoint animated:YES];
    }
}

- (NSArray *)titleArray
{
    if (!_titleArray)
    {
        _titleArray = @[@"分时", @"1分", @"5分", @"10分", @"15分", @"30分", @"60分", @"120分", @"240分", @"日K", @"周K", @"月K", @"年K"];
    }
    
    return _titleArray;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

/**
 工具类:根据字符串和富文本属性来生成rect
 
 @param string 字符串
 @param attribute 富文本属性
 @return 返回生成的rect
 */
- (CGRect)rectOfNSString:(NSString *)string attribute:(NSDictionary *)attribute
{
    CGRect rect = [string boundingRectWithSize:CGSizeMake(MAXFLOAT, 0)
                                       options:NSStringDrawingTruncatesLastVisibleLine |NSStringDrawingUsesLineFragmentOrigin |
                   NSStringDrawingUsesFontLeading
                                    attributes:attribute
                                       context:nil];
    return rect;
}

@end
