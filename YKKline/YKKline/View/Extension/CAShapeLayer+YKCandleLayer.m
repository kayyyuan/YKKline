//
//  CAShapeLayer+YKCandleLayer.m
//  YKKline
//
//  Created by nethanhan on 2017/6/5.
//  Copyright © 2017年 nethanhan. All rights reserved.
//

#import "CAShapeLayer+YKCandleLayer.h"
#import <UIKit/UIColor.h>
#import <UIKit/UIBezierPath.h>

@implementation CAShapeLayer (YKCandleLayer)

/**
 生成蜡烛Layer
 
 @param model 蜡烛坐标模型
 @return 返回layer
 */
+ (CAShapeLayer *)getCandleLayerWithPointModel:(YKCandlePointModel *)model candleW:(double)candleW
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
    
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.path = path.CGPath;
    
    //判断涨跌来设置颜色
    if (isRed)
    {
        //涨，设置红色
        layer.strokeColor = [UIColor redColor].CGColor;
        layer.fillColor = [UIColor redColor].CGColor;
        
    } else
    {
        //跌，设置绿色
        layer.strokeColor = [UIColor greenColor].CGColor;
        layer.fillColor = [UIColor greenColor].CGColor;
    }
    
    return layer;
}

@end
