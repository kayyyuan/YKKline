//
//  YKCAShapeLayer+YKCandleLayer.m
//  YKKline
//
//  Created by nethanhan on 2018/3/7.
//  Copyright © 2018年 nethanhan. All rights reserved.
//

#import "YKCAShapeLayer+YKCandleLayer.h"
#import "UIColor+YKKlineThemeColor.h"
#import <UIKit/UIColor.h>
#import <UIKit/UIBezierPath.h>

@implementation YKCAShapeLayer (YKCandleLayer)

/**
 生成OHLC
 
 @param model 蜡烛坐标模型
 @return 返回图层
 */
+ (YKCAShapeLayer *)getOHLCLayerWithPointModel:(YKCandlePointModel *)model candleW:(double)candleW
{
    //判断是否为涨跌
    BOOL isRed = model.oPoint.y >= model.cPoint.y ? YES : NO;
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    //绘制上下影线
    [path moveToPoint:model.lPoint];
    [path addLineToPoint:model.hPoint];
    //开盘线
    [path moveToPoint:model.oPoint];
    [path addLineToPoint:CGPointMake(model.oPoint.x - candleW/2 + 1, model.oPoint.y)];
    //开盘线
    [path moveToPoint:model.cPoint];
    [path addLineToPoint:CGPointMake(model.cPoint.x + candleW/2 - 1, model.cPoint.y)];
    
    YKCAShapeLayer *layer = [YKCAShapeLayer layer];
    layer.path = path.CGPath;
    
    //判断涨跌来设置颜色
    if (isRed)
    {
        //涨，设置红色
        layer.strokeColor = [UIColor kLineCandleRedColor].CGColor;
    } else
    {
        //跌，设置绿色
        layer.strokeColor = [UIColor kLineCandleGreenColor].CGColor;
    }
    layer.fillColor = [UIColor clearColor].CGColor;
    
    return layer;
}

/**
 生成蜡烛
 
 @param model 蜡烛坐标模型
 @return 返回layer
 */
+ (YKCAShapeLayer *)getCandleLayerWithPointModel:(YKCandlePointModel *)model candleW:(double)candleW
{
    //判断是否为涨跌
    BOOL isRed = model.oPoint.y >= model.cPoint.y ? YES : NO;
    
    //生成柱子的rect
    CGRect candleFrame = CGRectMake(isRed ? model.cPoint.x - candleW/2 + 1 : model.oPoint.x - candleW/2 + 1,
                                    isRed ? model.cPoint.y : model.oPoint.y,
                                    candleW-2,
                                    ABS(model.oPoint.y - model.cPoint.y));
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:candleFrame];
    
    //绘制上下影线
    [path moveToPoint:model.lPoint];
    [path addLineToPoint:model.hPoint];
    
    YKCAShapeLayer *layer = [YKCAShapeLayer layer];
    layer.path = path.CGPath;
    
    //判断涨跌来设置颜色
    if (isRed)
    {
        //涨，设置红色
        layer.strokeColor = [UIColor kLineCandleRedColor].CGColor;
        layer.fillColor = [UIColor kLineCandleRedColor].CGColor;
        
    } else
    {
        //跌，设置绿色
        layer.strokeColor = [UIColor kLineCandleGreenColor].CGColor;
        layer.fillColor = [UIColor kLineCandleGreenColor].CGColor;
    }
    
    return layer;
}

@end
