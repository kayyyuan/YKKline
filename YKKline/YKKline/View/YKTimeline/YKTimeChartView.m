//
//  YKTimeChartView.m
//  timeLineDemo
//
//  Created by nethanhan on 2017/5/18.
//  Copyright © 2017年 nethanhan. All rights reserved.
//

#import "YKTimeChartView.h"
#import "CATextLayer+YKTextLayer.h"
#import "CAShapeLayer+YKBorderLayer.h"
#import "YKTimeLinePointModel.h"
#import "YKCAShapeLayer.h"

@interface YKTimeChartView ()

/**最大值*/
@property (nonatomic, assign) double maxValue;

/**最小值*/
@property (nonatomic, assign) double minValue;

/**十字叉图层*/
@property (nonatomic, strong) CAShapeLayer *ticksLayer;

/**存储坐标点数组*/
@property (nonatomic, strong) NSMutableArray *pointArr;

@end

@implementation YKTimeChartView



//x轴时间点高
static float timePointH = 20.f;

/**
 绘制十字叉
 
 @param point 长按时获取到的坐标点
 */
- (void)drawTicksWithPoint:(CGPoint)point
{
    //先清理十字叉图层再添加
    [self clearTicks];
    
    //根据坐标计算索引
    float unitW = CGRectGetWidth(self.frame) / 1440;
    int index = (int)(point.x / unitW);
    if (index >= self.timeCharModelArr.count)
    {
        index = (int)self.timeCharModelArr.count - 1;
    }
    YKTimeLinePointModel *pointModel = self.pointArr[index];
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    //竖线
    [path moveToPoint:CGPointMake(pointModel.linePoint.x, 0)];
    [path addLineToPoint:CGPointMake(pointModel.linePoint.x, CGRectGetHeight(self.frame)-timePointH)];
    //横线
    [path moveToPoint:CGPointMake(0, pointModel.linePoint.y)];
    [path addLineToPoint:CGPointMake(CGRectGetWidth(self.frame), pointModel.linePoint.y)];
    //设置横竖线的属性
    self.ticksLayer.path = path.CGPath;
    self.ticksLayer.lineWidth = 1.f;
    self.ticksLayer.strokeColor = [UIColor blackColor].CGColor;
    self.ticksLayer.fillColor = [UIColor clearColor].CGColor;
    //取出数据模型
    YKTimeChartModel *model = self.timeCharModelArr[index];
    NSDictionary *attribute = @{NSFontAttributeName:[UIFont systemFontOfSize:9.f]};
    //计算各种rect
    NSString *timeStr = [NSString stringWithFormat:@"%d:%d", model.min / 60, model.min % 60];
    NSString *priceStr = [NSString stringWithFormat:@"%.2f", model.clp];
    NSString *perStr = [NSString stringWithFormat:@"%.2f%%", (self.maxValue - model.clp - self.yc)/self.yc];
    CGRect timeStrRect = [self rectOfNSString:timeStr attribute:attribute];
    CGRect priceStrRect = [self rectOfNSString:priceStr attribute:attribute];
    CGRect perStrRect = [self rectOfNSString:perStr attribute:attribute];
    
    CGRect maskTimeRect = CGRectMake(pointModel.linePoint.x - CGRectGetWidth(timeStrRect)/2-5.f,
                                     CGRectGetHeight(self.frame) - timePointH,
                                     CGRectGetWidth(timeStrRect)+10.f,
                                     CGRectGetHeight(timeStrRect) + 5.f);
    CGRect maskPriceRect = CGRectMake(0,
                                      pointModel.linePoint.y - CGRectGetHeight(priceStrRect)/2-2.5f,
                                      CGRectGetWidth(priceStrRect)+10.f,
                                      CGRectGetHeight(priceStrRect)+5.f);
    CGRect maskPerRect = CGRectMake(CGRectGetWidth(self.frame)-CGRectGetWidth(perStrRect)-10.f,
                                    pointModel.linePoint.y - CGRectGetHeight(priceStrRect)/2-2.5f,
                                    CGRectGetWidth(perStrRect)+10.f, CGRectGetHeight(perStrRect)+5.f);
    
    CGRect timeRect = CGRectMake(CGRectGetMinX(maskTimeRect)+5.f, CGRectGetMinY(maskTimeRect)+2.5f, CGRectGetWidth(timeStrRect), CGRectGetHeight(timeStrRect));
    CGRect priceRect = CGRectMake(CGRectGetMinX(maskPriceRect)+5.f, CGRectGetMinY(maskPriceRect)+2.5f, CGRectGetWidth(priceStrRect), CGRectGetHeight(priceStrRect));
    CGRect perRect = CGRectMake(CGRectGetMinX(maskPerRect)+5.f, CGRectGetMinY(maskPerRect)+2.5f, CGRectGetWidth(perStrRect), CGRectGetHeight(perStrRect));
    //生成时间方块图层
    CAShapeLayer *timeLayer = [CAShapeLayer getRectLayerWithRect:maskTimeRect dataRect:timeRect dataStr:timeStr fontSize:9.f textColor:[UIColor whiteColor] backColor:[UIColor blackColor]];
    //生成价格方块图层
    CAShapeLayer *priceLayer = [CAShapeLayer getRectLayerWithRect:maskPriceRect dataRect:priceRect dataStr:priceStr fontSize:9.f textColor:[UIColor whiteColor] backColor:[UIColor blackColor]];
    //生成百分比方块图层
    CAShapeLayer *perLayer = [CAShapeLayer getRectLayerWithRect:maskPerRect dataRect:perRect dataStr:perStr fontSize:9.f textColor:[UIColor whiteColor] backColor:[UIColor blackColor]];
    //把3个图层全部添加到十字叉图层中
    [self.ticksLayer addSublayer:timeLayer];
    [self.ticksLayer addSublayer:priceLayer];
    [self.ticksLayer addSublayer:perLayer];
    //再添加到分时图view的图层中
    [self.layer addSublayer:self.ticksLayer];
    
}


/**
 清理长按响应图层
 */
- (void)clearTicks
{
    //清理十字叉图层
    self.ticksLayer.sublayers = nil;
    [self.ticksLayer removeFromSuperlayer];
}


/**
 绘制
 */
- (void)draw
{
    //获取极限值
    [self findMaxMinValue];
    //绘制边框
    [self drawBorderLayer];
    //绘制时间点
    [self drawTimePointLayer];
    //绘制价格范围
    [self drawPriceRange];
    //绘制分时线、均线、呼吸灯
    [self drawTimeLine];
}

/**
 绘制边框
 */
- (void)drawBorderLayer
{
    float frameX = 0.f;
    float frameY = 0.f;
    float frameW = CGRectGetWidth(self.frame);
    float frameH = CGRectGetHeight(self.frame) - timePointH;
    CGRect rect = CGRectMake(frameX, frameY, frameW, frameH);
    
    UIBezierPath *framePath = [UIBezierPath bezierPathWithRect:rect];
    CAShapeLayer *layer = [CAShapeLayer layer];
    
    float unitW = frameW/6;
    float unitH = frameH/4;
    //绘制7条竖线
    for (int i=0; i<7; i++)
    {
        CGPoint startPoint = CGPointMake(frameX + unitW * i, frameY);
        CGPoint endPoint   = CGPointMake(frameX + unitW * i, frameY + frameH);
        [framePath moveToPoint:startPoint];
        [framePath addLineToPoint:endPoint];
    }
    //绘制5条横线
    for (int i=0; i<5; i++)
    {
        CGPoint startPoint = CGPointMake(frameX, frameY + unitH * i);
        CGPoint endPoint   = CGPointMake(frameX + frameW, frameY + unitH * i);
        [framePath moveToPoint:startPoint];
        [framePath addLineToPoint:endPoint];
    }
    //设置图层的属性
    layer.path = framePath.CGPath;
    layer.lineWidth = 0.5f;
    layer.strokeColor = [UIColor colorWithRed:220.f/255.f green:220.f/255.f blue:220.f/255.f alpha:1.f].CGColor;
    layer.fillColor = [UIColor clearColor].CGColor;
    
    [self.layer addSublayer:layer];

}

/**
 绘制x轴时间点
 */
- (void)drawTimePointLayer
{
    //坐标点数组
    NSArray *timePointArr = @[@"06:01", @"10:00", @"14:00", @"18:00", @"22:00", @"02:00", @"06:00"];
    NSDictionary *attribute = @{NSFontAttributeName:[UIFont systemFontOfSize:9.f]};
    CGRect strRect = [self rectOfNSString:@"00:00" attribute:attribute];
    float strW = CGRectGetWidth(strRect);
    float strH = CGRectGetHeight(strRect);
    
    float unitW = CGRectGetWidth(self.frame) / 6;
    //循环绘制坐标点
    for (int idx = 0; idx < timePointArr.count; idx++)
    {
        CATextLayer *textLayer = nil;
        
        if (idx == timePointArr.count-1)
        {//最后一个
            CGRect rect = CGRectMake(idx * unitW - strW, CGRectGetHeight(self.frame)-timePointH, strW, strH);
            textLayer = [CATextLayer getTextLayerWithString:timePointArr[idx] textColor:[UIColor blackColor] fontSize:9.f backgroundColor:[UIColor clearColor] frame:rect];
        }else if(idx == 0)
        {//第一个
            CGRect rect = CGRectMake(idx * unitW, CGRectGetHeight(self.frame)-timePointH, strW, strH);
            textLayer = [CATextLayer getTextLayerWithString:timePointArr[idx] textColor:[UIColor blackColor] fontSize:9.f backgroundColor:[UIColor clearColor] frame:rect];
        }else
        {//中间
            CGRect rect = CGRectMake(idx * unitW - strW/2, CGRectGetHeight(self.frame)-timePointH, strW, strH);
            textLayer = [CATextLayer getTextLayerWithString:timePointArr[idx] textColor:[UIColor blackColor] fontSize:9.f backgroundColor:[UIColor clearColor] frame:rect];
        }
        
        [self.layer addSublayer:textLayer];
    }
}

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


/**
 绘制均线

 @param pointArr 坐标点模型数组
 */
- (void)drawAvgLineWithPointArr:(NSArray *)pointArr
{
    CAShapeLayer *avgLineLayer = [CAShapeLayer layer];
    
    UIBezierPath *avgLinePath = [UIBezierPath bezierPath];
    YKTimeLinePointModel *firstModel = pointArr.firstObject;
    [avgLinePath moveToPoint:firstModel.avgPoint];
    
    for (int i=1; i<pointArr.count; i++)
    {
        YKTimeLinePointModel *model = pointArr[i];
        [avgLinePath addLineToPoint:model.avgPoint];
    }
    avgLineLayer.path = avgLinePath.CGPath;
    avgLineLayer.lineWidth = 2.f;
    avgLineLayer.strokeColor = [UIColor colorWithRed:255.f/255.f green:215.f/255.f blue:0.f/255.f alpha:1.f].CGColor;
    avgLineLayer.fillColor = [UIColor clearColor].CGColor;
    
    [self.layer addSublayer:avgLineLayer];
}

/**
 绘制分时线和背景区域
 */
- (void)drawTimeLine
{
    [self covertToPoint];
    
    CAShapeLayer *lineLayer = [CAShapeLayer layer];
    CAShapeLayer *fillLayer = [CAShapeLayer layer];
    UIBezierPath *timeLinePath = [UIBezierPath bezierPath];
    
    //绘制分时线
    YKTimeLinePointModel *firstModel = self.pointArr.firstObject;
    [timeLinePath moveToPoint:firstModel.linePoint];
    for (int i=1; i<self.pointArr.count; i++)
    {
        YKTimeLinePointModel *model = self.pointArr[i];
        [timeLinePath addLineToPoint:model.linePoint];
    }
    lineLayer.path = timeLinePath.CGPath;
    lineLayer.lineWidth = 0.4f;
    lineLayer.strokeColor = [UIColor colorWithRed:100.f/255.f green:149.f/255.f blue:237.f/255.f alpha:1.f].CGColor;
    lineLayer.fillColor = [UIColor clearColor].CGColor;
    
    //绘制背景区域
    YKTimeLinePointModel *lastModel = [self.pointArr lastObject];
    [timeLinePath addLineToPoint:CGPointMake(lastModel.linePoint.x, CGRectGetHeight(self.frame) - timePointH)];
    [timeLinePath addLineToPoint:CGPointMake(firstModel.linePoint.x, CGRectGetHeight(self.frame)- timePointH)];
    fillLayer.path = timeLinePath.CGPath;
    fillLayer.fillColor = [UIColor colorWithRed:135.f/255.f green:206.f/255.f blue:250.f/255.f alpha:0.5f].CGColor;
    fillLayer.strokeColor = [UIColor clearColor].CGColor;
    fillLayer.zPosition -= 1;
    
    [self.layer addSublayer:lineLayer];
    [self.layer addSublayer:fillLayer];
    
    //绘制均线
    [self drawAvgLineWithPointArr:self.pointArr];
    
    //绘制呼吸灯
    [self drawBreathingLightWithPoint:lastModel.linePoint];
}

/**
 转换坐标点
 */
- (void)covertToPoint
{
    CGFloat unitW = CGRectGetWidth(self.frame) / 1440;
    CGFloat unitValue = (self.maxValue - self.minValue) / (CGRectGetHeight(self.frame) - timePointH);
    
    [self.pointArr removeAllObjects];
    //遍历数据模型
    [self.timeCharModelArr enumerateObjectsUsingBlock:^(YKTimeChartModel * _Nonnull model, NSUInteger idx, BOOL * _Nonnull stop) {
        
        CGFloat x = idx * unitW;
        //生成分时线坐标点
        CGPoint linePoint = CGPointMake(x, ABS(CGRectGetMaxY(self.frame) - timePointH) - (model.clp - self.minValue)/ unitValue);
        //生成均线坐标点
        CGPoint avgPoint = CGPointMake(x, ABS(CGRectGetMaxY(self.frame) - timePointH) - (model.avp - self.minValue)/ unitValue);
        
        YKTimeLinePointModel *pointModel = [YKTimeLinePointModel new];
        pointModel.linePoint = linePoint;
        pointModel.avgPoint = avgPoint;
        [self.pointArr addObject:pointModel];
    }];
}

/**
 寻找极限值
 */
- (void)findMaxMinValue
{
    double avpMax = [[[self.timeCharModelArr valueForKeyPath:@"avp"] valueForKeyPath:@"@max.doubleValue"] doubleValue];
    double avpMin = [[[self.timeCharModelArr valueForKeyPath:@"avp"] valueForKeyPath:@"@min.doubleValue"] doubleValue];
    double clpMax = [[[self.timeCharModelArr valueForKeyPath:@"clp"] valueForKeyPath:@"@max.doubleValue"] doubleValue];
    double clpMin = [[[self.timeCharModelArr valueForKeyPath:@"clp"] valueForKeyPath:@"@min.doubleValue"] doubleValue];
    double maxValue = fmax(avpMax, clpMax);
    double minValue = fmin(avpMin, clpMin);
    
    float gapValue = 0.01f;
    if (ABS(maxValue - self.yc) >= ABS(self.yc - minValue))
    {
        maxValue = maxValue - self.yc + gapValue + self.yc;
        minValue = self.yc - (maxValue - self.yc);
        
    } else
    {
        minValue = self.yc - (self.yc - minValue + gapValue);
        maxValue = self.yc + (self.yc - minValue);
    }
    
    self.maxValue = maxValue;
    self.minValue = minValue;
}

/**
 绘制价格区间
 */
- (void)drawPriceRange
{
    //生成单位单价  和 单位高
    double unitPrice = (self.maxValue - self.minValue) / 4.f;
    double unitH = (CGRectGetHeight(self.frame) - timePointH) / 4.f;
    
    //求得价格和百分比的rect
    NSDictionary *attribute = @{NSFontAttributeName:[UIFont systemFontOfSize:9.f]};
    CGRect priceRect = [self rectOfNSString:[NSString stringWithFormat:@"%.4f", self.yc] attribute:attribute];
    CGRect perRect   = [self rectOfNSString:@"-00.00%" attribute:attribute];
    
    //循环绘制5行数据
    //左边是价格  右边是百分比
    for (int idx = 0; idx < 5; idx++)
    {
        float height = 0.f;
        if (idx == 4)
        {
            height = idx * unitH - CGRectGetHeight(priceRect);
        } else
        {
            height = idx * unitH;
        }
        CGRect leftRect = CGRectMake(0,
                                     height,
                                     CGRectGetWidth(priceRect),
                                     CGRectGetHeight(priceRect));
        CGRect rightRect = CGRectMake(CGRectGetMaxX(self.frame)-CGRectGetWidth(perRect)-14,
                                      height,
                                      CGRectGetWidth(perRect),
                                      CGRectGetHeight(perRect));
        //计算价格和百分比
        NSString *leftStr = [NSString stringWithFormat:@"%.2f", self.maxValue - idx * unitPrice];
        NSString *rightStr = [NSString stringWithFormat:@"%.2f%%", (self.maxValue - idx * unitPrice - self.yc)/self.yc];
        
        CATextLayer *leftLayer = [CATextLayer getTextLayerWithString:leftStr
                                                           textColor:[UIColor blackColor]
                                                            fontSize:9.f
                                                     backgroundColor:[UIColor clearColor]
                                                               frame:leftRect];
        CATextLayer *rightLayer = [CATextLayer getTextLayerWithString:rightStr
                                                            textColor:[UIColor blackColor]
                                                             fontSize:9.f
                                                      backgroundColor:[UIColor clearColor]
                                                                frame:rightRect];
        
        [self.layer addSublayer:leftLayer];
        [self.layer addSublayer:rightLayer];
    }
}

/**
 绘制呼吸灯
 */
- (void)drawBreathingLightWithPoint:(CGPoint)point
{
    CALayer *layer = [CALayer layer];
    //设置任意位置
    layer.frame = CGRectMake(point.x, point.y, 3, 3);
    //设置呼吸灯的颜色
    layer.backgroundColor = [UIColor blueColor].CGColor;
    //设置好半径
    layer.cornerRadius = 1.5;
    //给当前图层添加动画组
    [layer addAnimation:[self createBreathingLightAnimationWithTime:2] forKey:nil];
    
    [self.layer addSublayer:layer];
}


/**
 生成动画

 @param time 动画单词持续时间
 @return 返回动画组
 */
- (CAAnimationGroup *)createBreathingLightAnimationWithTime:(double)time
{
    //实例化CABasicAnimation
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    //从1开始
    scaleAnimation.fromValue = @1;
    //到3.5
    scaleAnimation.toValue = @3.5;
    //结束后不执行逆动画
    scaleAnimation.autoreverses = NO;
    //无限循环
    scaleAnimation.repeatCount = HUGE_VALF;
    //一次执行time秒
    scaleAnimation.duration = time;
    //结束后从渲染树删除，变回初始状态
    scaleAnimation.removedOnCompletion = YES;
    scaleAnimation.fillMode = kCAFillModeForwards;
    
    CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.fromValue = @1.0;
    opacityAnimation.toValue = @0;
    opacityAnimation.autoreverses = NO;
    opacityAnimation.repeatCount = HUGE_VALF;
    opacityAnimation.duration = time;
    opacityAnimation.removedOnCompletion = YES;
    opacityAnimation.fillMode = kCAFillModeForwards;
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.duration = time;
    group.autoreverses = NO;
    group.animations = @[scaleAnimation, opacityAnimation];
    group.repeatCount = HUGE_VALF;
    //这里也应该设置removedOnCompletion和fillMode属性，以具体情况而定
    
    return group;
}


#pragma mark - lazy

- (CAShapeLayer *)ticksLayer
{
    if (!_ticksLayer)
    {
        _ticksLayer = [CAShapeLayer layer];
    }
    
    return _ticksLayer;
}

- (NSMutableArray *)pointArr
{
    if (!_pointArr)
    {
        _pointArr = [NSMutableArray array];
    }
    
    return _pointArr;
}

@end
