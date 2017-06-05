//
//  CAShapeLayer+YKOHLCLayer.m
//  YKKline
//
//  Created by nethanhan on 2017/6/5.
//  Copyright © 2017年 nethanhan. All rights reserved.
//

#import "CAShapeLayer+YKOHLCLayer.h"
#import <UIKit/UIColor.h>
#import <UIKit/UIBezierPath.h>

@implementation CAShapeLayer (YKOHLCLayer)

/**
 生成OHLC
 
 @param model 蜡烛坐标模型
 @return 返回图层
 */
+ (CAShapeLayer *)getOHLCLayerWithPointModel:(YKCandlePointModel *)model candleW:(double)candleW
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
    
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.path = path.CGPath;
    
    //判断涨跌来设置颜色
    if (isRed)
    {
        //涨，设置红色
        layer.strokeColor = [UIColor redColor].CGColor;
    } else
    {
        //跌，设置绿色
        layer.strokeColor = [UIColor greenColor].CGColor;
    }
    layer.fillColor = [UIColor clearColor].CGColor;
    
    return layer;
}

@end
