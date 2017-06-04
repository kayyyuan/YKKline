//
//  YKKlineView.m
//  YKKline
//
//  Created by nethanhan on 2017/6/4.
//  Copyright © 2017年 nethanhan. All rights reserved.
//

#import "YKKlineView.h"
#import "YKKlineViewConfig.h"
#import "UIColor+YKKlineThemeColor.h"


@interface YKKlineView ()

/**主图rect*/
@property (nonatomic, assign) CGRect mainRect;
/**副图rect*/
@property (nonatomic, assign) CGRect accessoryRect;
/**日期rect*/
@property (nonatomic, assign) CGRect dateRect;


@end

@implementation YKKlineView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self drawBorder];
    }
    
    return self;
}

/**
 绘制边框
 */
- (void)drawBorder
{
    //设置主图、主图指标、副图、副图指标rect
    _mainRect = CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame) * [YKKlineViewConfig kLineMainViewHeightScale]);
    _dateRect = CGRectMake(0, CGRectGetMaxY(_mainRect), CGRectGetWidth(self.frame), CGRectGetHeight(self.frame) * [YKKlineViewConfig kLineDateHeightScale]);
    _accessoryRect = CGRectMake(0, CGRectGetMaxY(_dateRect), CGRectGetWidth(self.frame), CGRectGetHeight(self.frame) * [YKKlineViewConfig kLineAccessoryViewHeightScale]);
    
    CAShapeLayer *borderLayer = [CAShapeLayer layer];
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:self.bounds];
    
    [path moveToPoint:CGPointMake(0, CGRectGetMaxY(_mainRect))];
    [path addLineToPoint:CGPointMake(CGRectGetWidth(self.frame), CGRectGetMaxY(_mainRect))];
    
    [path moveToPoint:CGPointMake(0, CGRectGetMaxY(_dateRect))];
    [path addLineToPoint:CGPointMake(CGRectGetWidth(self.frame), CGRectGetMaxY(_dateRect))];
    
    float mainUnitH = CGRectGetHeight(_mainRect) / 4.f;
    float mainUnitW = CGRectGetWidth(_mainRect) / 4.f;
    
    for (int idx = 1; idx <= 3; idx++)
    {
        //画3条横线
        [path moveToPoint:CGPointMake(CGRectGetMinX(_mainRect), mainUnitH * idx)];
        [path addLineToPoint:CGPointMake(CGRectGetWidth(self.frame), mainUnitH * idx)];
        
        //画3条竖线
        [path moveToPoint:CGPointMake(idx * mainUnitW, CGRectGetMinY(_mainRect))];
        [path addLineToPoint:CGPointMake(idx * mainUnitW, CGRectGetMaxY(_mainRect))];
        
        //画3条竖线
        [path moveToPoint:CGPointMake(idx * mainUnitW, CGRectGetMinY(_accessoryRect))];
        [path addLineToPoint:CGPointMake(idx * mainUnitW, CGRectGetMaxY(_accessoryRect))];
    }
    
    float accessoryUnitH = CGRectGetHeight(_accessoryRect) / 2.f;
    [path moveToPoint:CGPointMake(CGRectGetMinX(_accessoryRect),
                                  CGRectGetMaxY(_accessoryRect) - accessoryUnitH)];
    [path addLineToPoint:CGPointMake(CGRectGetMaxX(_accessoryRect),
                                     CGRectGetMaxY(_accessoryRect) - accessoryUnitH)];
    
    borderLayer.path = path.CGPath;
    borderLayer.lineWidth = 0.5f;
    borderLayer.strokeColor = [UIColor kLineBorderColor].CGColor;
    borderLayer.fillColor = [UIColor clearColor].CGColor;
    
    [self.layer addSublayer:borderLayer];
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
