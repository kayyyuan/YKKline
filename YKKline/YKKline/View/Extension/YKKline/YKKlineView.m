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
#import "YKKLineModel.h"
#import "YKCandlePointModel.h"
#import "YKCAShapeLayer+YKCandleLayer.h"
#import "YKCATextLayer+YKTextLayer.h"
#import "YKCAShapeLayer+YKBorderLayer.h"
#import "YKCATextLayer.h"


@interface YKKlineView ()

/**主图rect*/
@property (nonatomic, assign) CGRect mainRect;
/**副图rect*/
@property (nonatomic, assign) CGRect accessoryRect;
/**日期rect*/
@property (nonatomic, assign) CGRect dateRect;

/**当前主图类型*/
@property (nonatomic, assign) KLineMainType currentMainType;

/**主图最大值*/
@property (nonatomic, assign) float mainMaxValue;
/**主图最小值*/
@property (nonatomic, assign) float mainMinValue;
/**副图最大值*/
@property (nonatomic, assign) float accessoryMaxValue;
/**副图最小值*/
@property (nonatomic, assign) float accessoryMinValue;
/**开始索引*/
@property (nonatomic, assign) int startIndex;
/**结束索引*/
@property (nonatomic, assign) int endIndex;

/**当前主图显示的数据的坐标*/
@property (nonatomic, strong) NSMutableArray *displayPointArr;

/**主图图层*/
@property (nonatomic, strong) CAShapeLayer *mainLayer;
/**长按十字叉图层*/
@property (nonatomic, strong) CAShapeLayer *crossViewLayer;


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

- (void)setKLineModelArr:(NSArray *)kLineModelArr
{
    _kLineModelArr = kLineModelArr;
    
    //设置起始索引
    _startIndex = (int)kLineModelArr.count - [YKKlineViewConfig kLineCandleCount] - 1;
    _endIndex = (int)kLineModelArr.count;
}

- (void)drawWithMainType:(KLineMainType)mainType mainIndicatorType:(KLineMainIndicatorType)mainIndicatorType accessoryIndicatorType:(KLineAccessoryIndicatorType)accessoryIndicatorType
{
    //保存主图类型
    _currentMainType = mainType;
    
    //求出主图最大最小值
    _mainMinValue = (float)INT32_MAX;
    _mainMaxValue = (float)INT32_MIN;
    
    //求出副图最大最小值
    _accessoryMinValue = (float)INT32_MAX;
    _accessoryMaxValue = (float)INT32_MIN;
    
    for (int idx=_startIndex; idx<_endIndex; idx++)
    {
        YKKLineModel *model = self.kLineModelArr[idx];
        if (_mainMinValue > model.low)
        {
            _mainMinValue = model.low;
        }
        if (_mainMaxValue < model.high)
        {
            _mainMaxValue = model.high;
        }
    }
    
    switch (mainIndicatorType) {
        case KLineMainIndicatorMA:
        {
            for (int idx=_startIndex; idx<_endIndex; idx++)
            {
                YKKLineModel *model = self.kLineModelArr[idx];
                
                float tempMax = [self getMaxValue:[NSNumber numberWithFloat:model.MA_MA1], [NSNumber numberWithFloat:model.MA_MA2], [NSNumber numberWithFloat:model.MA_MA3],nil];
                float tempMin = [self getMinValue:[NSNumber numberWithFloat:model.MA_MA1], [NSNumber numberWithFloat:model.MA_MA2], [NSNumber numberWithFloat:model.MA_MA3],nil];
                if (_mainMinValue > tempMin)
                {
                    _mainMinValue = tempMin;
                }
                if (_mainMaxValue < tempMax)
                {
                    _mainMaxValue = tempMax;
                }
            }
        }
            break;
        case KLineMainIndicatorBOLL:
            break;
        case KLineMainIndicatorQIANKUN:
        {
            for (int idx=_startIndex; idx<_endIndex; idx++)
            {
                YKKLineModel *model = self.kLineModelArr[idx];
                
                float tempMax = [self getMaxValue:[NSNumber numberWithFloat:model.QK_DUO], [NSNumber numberWithFloat:model.QK_KONG], [NSNumber numberWithFloat:model.QK_KUN1], [NSNumber numberWithFloat:model.QK_KUN2], [NSNumber numberWithFloat:model.QK_QIAN1], [NSNumber numberWithFloat:model.QK_QIAN2], nil];
                float tempMin = [self getMinValue:[NSNumber numberWithFloat:model.QK_DUO], [NSNumber numberWithFloat:model.QK_KONG], [NSNumber numberWithFloat:model.QK_KUN1], [NSNumber numberWithFloat:model.QK_KUN2], [NSNumber numberWithFloat:model.QK_QIAN1], [NSNumber numberWithFloat:model.QK_QIAN2], nil];
                if (_mainMinValue > tempMin)
                {
                    _mainMinValue = tempMin;
                }
                if (_mainMaxValue < tempMax)
                {
                    _mainMaxValue = tempMax;
                }
            }
        }
            break;
        default:
            break;
    }
    
    switch (accessoryIndicatorType) {
        case KLineAccessoryIndicatorKDJ:
        {
            for (int idx=_startIndex; idx<_endIndex; idx++)
            {
                YKKLineModel *model = self.kLineModelArr[idx];
                
                float tempMax = [self getMaxValue:[NSNumber numberWithFloat:model.KDJ_K], [NSNumber numberWithFloat:model.KDJ_D], [NSNumber numberWithFloat:model.KDJ_J],nil];
                float tempMin = [self getMinValue:[NSNumber numberWithFloat:model.KDJ_K], [NSNumber numberWithFloat:model.KDJ_D], [NSNumber numberWithFloat:model.KDJ_J],nil];
                if (_accessoryMinValue > tempMin)
                {
                    _accessoryMinValue = tempMin;
                }
                if (_accessoryMaxValue < tempMax)
                {
                    _accessoryMaxValue = tempMax;
                }
            }
        }
            break;
        case KLineAccessoryIndicatorMACD:
            break;
        case KLineAccessoryIndicatorJUJI:
        {
            for (int idx=_startIndex; idx<_endIndex; idx++)
            {
                YKKLineModel *model = self.kLineModelArr[idx];
                
                float tempMax = [self getMaxValue:[NSNumber numberWithFloat:model.JJ_DUO], [NSNumber numberWithFloat:model.JJ_DUO1], [NSNumber numberWithFloat:model.JJ_KONG],[NSNumber numberWithFloat:model.JJ_KONG1], [NSNumber numberWithFloat:model.JJ_KUAI], [NSNumber numberWithFloat:model.JJ_MAN],nil];
                float tempMin = [self getMinValue:[NSNumber numberWithFloat:model.JJ_DUO], [NSNumber numberWithFloat:model.JJ_DUO1], [NSNumber numberWithFloat:model.JJ_KONG],[NSNumber numberWithFloat:model.JJ_KONG1], [NSNumber numberWithFloat:model.JJ_KUAI], [NSNumber numberWithFloat:model.JJ_MAN],nil];
                if (_accessoryMinValue > tempMin)
                {
                    _accessoryMinValue = tempMin;
                }
                if (_accessoryMaxValue < tempMax)
                {
                    _accessoryMaxValue = tempMax;
                }
            }
        }
            break;
        default:
            break;
    }
    
    float unitValue = (_mainMaxValue - _mainMinValue) / CGRectGetHeight(_mainRect);
    
    //转换主图开高收低的坐标点
    [self coverCandlePointWithUnitValue:unitValue];
    
    switch (mainType)
    {
        case KLineMainCandle:
        {
            //绘制蜡烛
            [self drawCandleWithPointModelArr:self.displayPointArr];
        }
            break;
        case KLineMainOHLC:
        {
            //绘制OHLC
            [self drawOHLCWithPointModelArr:self.displayPointArr];
        }
            break;
        default:
            break;
    }
    
    //绘制左侧价格
    [self drawLeftValue];
    //绘制底部日期
    [self drawBottomDateValue];
    
    [self.layer addSublayer:self.mainLayer];
}

/**
 绘制左侧价格
 */
- (void)drawLeftValue
{
    float unitPrice = (_mainMaxValue - _mainMinValue) / 4.f;
    float unitH = CGRectGetHeight(_mainRect) / 4.f;
    
    //求得价格rect
    NSDictionary *attribute = @{NSFontAttributeName:[UIFont systemFontOfSize:9.f]};
    CGRect priceRect = [self rectOfNSString:[NSString stringWithFormat:@"%.2f", _mainMaxValue] attribute:attribute];
    
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
        CGRect rect = CGRectMake(CGRectGetMinX(_mainRect),
                                 CGRectGetMinY(_mainRect) + height,
                                 CGRectGetWidth(priceRect),
                                 CGRectGetHeight(priceRect));
        //计算价格
        NSString *str = [NSString stringWithFormat:@"%.2f", _mainMaxValue - idx * unitPrice];
        YKCATextLayer *layer = [YKCATextLayer getTextLayerWithString:str
                                                       textColor:[UIColor blackColor]
                                                        fontSize:9.f
                                                 backgroundColor:[UIColor clearColor]
                                                           frame:rect];
        
        [self.mainLayer addSublayer:layer];
    }
}

/**
 绘制日期
 */
- (void)drawBottomDateValue
{
    NSMutableArray *kLineDateArr = [NSMutableArray array];
    
    int unitCount = [YKKlineViewConfig kLineCandleCount] / 4;
    for (int idx=0; idx<5; idx++)
    {
        YKKLineModel *model = self.kLineModelArr[_startIndex + idx * unitCount];
        
        NSDate *detaildate = [NSDate dateWithTimeIntervalSince1970:model.timeStamp];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"YYYY-MM-dd"];
        NSString *dateStr = [dateFormatter stringFromDate:detaildate];
        
        [kLineDateArr addObject:dateStr];
    }
    
    NSDictionary *attribute = @{NSFontAttributeName:[UIFont systemFontOfSize:9.f]};
    CGRect strRect = [self rectOfNSString:@"0000-00-00" attribute:attribute];
    float strW = CGRectGetWidth(strRect);
    float strH = CGRectGetHeight(strRect);
    
    float unitW = CGRectGetWidth(_mainRect) / 4;
    
    //循环绘制坐标点
    for (int idx = 0; idx < kLineDateArr.count; idx++)
    {
        YKCATextLayer *textLayer = nil;
        
        if (idx == kLineDateArr.count-1)
        {//最后一个
            CGRect rect = CGRectMake(idx * unitW - strW, CGRectGetMaxY(_mainRect), strW, strH);
            textLayer = [YKCATextLayer getTextLayerWithString:kLineDateArr[idx] textColor:[UIColor blackColor] fontSize:9.f backgroundColor:[UIColor clearColor] frame:rect];
        }else if(idx == 0)
        {//第一个
            CGRect rect = CGRectMake(idx * unitW, CGRectGetMaxY(_mainRect), strW, strH);
            textLayer = [YKCATextLayer getTextLayerWithString:kLineDateArr[idx] textColor:[UIColor blackColor] fontSize:9.f backgroundColor:[UIColor clearColor] frame:rect];
        }else
        {//中间
            CGRect rect = CGRectMake(idx * unitW - strW/2, CGRectGetMaxY(_mainRect), strW, strH);
            textLayer = [YKCATextLayer getTextLayerWithString:kLineDateArr[idx] textColor:[UIColor blackColor] fontSize:9.f backgroundColor:[UIColor clearColor] frame:rect];
        }
        
        [self.mainLayer addSublayer:textLayer];
    }
}

/**
 绘制蜡烛线
 
 @param pointModelArr 坐标点模型数组
 */
- (void)drawCandleWithPointModelArr:(NSArray *)pointModelArr
{
    //每根蜡烛的宽度
    float candleW = CGRectGetWidth(_mainRect) / [YKKlineViewConfig kLineCandleCount];
    
    for (int idx = 0; idx< [YKKlineViewConfig kLineCandleCount]; idx++)
    {
        YKCandlePointModel *model = pointModelArr[idx];
        YKCAShapeLayer *layer = [YKCAShapeLayer getCandleLayerWithPointModel:model candleW:candleW];
        
        [self.mainLayer addSublayer:layer];
    }
}

/**
 绘制OHLC线
 
 @param pointModelArr 坐标点模型数组
 */
- (void)drawOHLCWithPointModelArr:(NSArray *)pointModelArr
{
    //每根OHLC的宽度
    float candleW = CGRectGetWidth(_mainRect) / [YKKlineViewConfig kLineCandleCount];
    
    for (int idx = 0; idx< [YKKlineViewConfig kLineCandleCount]; idx++)
    {
        YKCandlePointModel *model = pointModelArr[idx];
        YKCAShapeLayer *layer = [YKCAShapeLayer getOHLCLayerWithPointModel:model candleW:candleW];
        
        [self.mainLayer addSublayer:layer];
    }
}

- (void)drawMainIndicatorWith:(KLineMainIndicatorType)mainIndicator
{
    
}

/**
 转换蜡烛图坐标点
 
 @param unitValue 单位值
 */
- (void)coverCandlePointWithUnitValue:(float)unitValue
{
    [self.displayPointArr removeAllObjects];
    
    float candleW = CGRectGetWidth(_mainRect) / [YKKlineViewConfig kLineCandleCount];
    
    for (int idx = _startIndex; idx<_endIndex; idx++)
    {
        YKKLineModel *model = self.kLineModelArr[idx];
        float x = CGRectGetMinX(_mainRect) + candleW * (idx - (_startIndex - 0));
        
        CGPoint hPoint = CGPointMake(x + candleW/2,
                                     ABS(CGRectGetMaxY(_mainRect) - (model.high  - _mainMinValue)/unitValue));
        CGPoint lPoint = CGPointMake(x + candleW/2,
                                     ABS(CGRectGetMaxY(_mainRect) - (model.low   - _mainMinValue)/unitValue));
        CGPoint oPoint = CGPointMake(x + candleW/2,
                                     ABS(CGRectGetMaxY(_mainRect) - (model.open  - _mainMinValue)/unitValue));
        CGPoint cPoint = CGPointMake(x + candleW/2,
                                     ABS(CGRectGetMaxY(_mainRect) - (model.close - _mainMinValue)/unitValue));
        [self.displayPointArr addObject:[YKCandlePointModel candlePointModelWithOpoint:oPoint
                                                                            Hpoint:hPoint
                                                                            Lpoint:lPoint
                                                                            Cpoint:cPoint]];
    }
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

/**
 清理图层
 */
- (void)clearLayer
{
    [self.mainLayer.sublayers makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
    [self.mainLayer removeFromSuperlayer];
}

/**
 向右拖拽
 
 @param offsetcount 拖拽的偏移量
 */
- (void)dragRightOffsetcount:(int)offsetcount
{
    if (_startIndex - offsetcount < 0)
    {
        return;
    }
    [self clearLayer];
    _startIndex -= offsetcount;
    _endIndex -= offsetcount;
    
    [self drawWithMainType:self.currentMainType mainIndicatorType:KLineMainIndicatorMA accessoryIndicatorType:KLineAccessoryIndicatorKDJ];
}

/**
 向左拖拽
 
 @param offsetcount 拖拽的偏移量
 */
- (void)dragLeftOffsetcount:(int)offsetcount
{
    if (_endIndex + offsetcount > self.kLineModelArr.count)
    {
        return;
    }
    [self clearLayer];
    _startIndex += offsetcount;
    _endIndex += offsetcount;
    
    [self drawWithMainType:self.currentMainType mainIndicatorType:KLineMainIndicatorMA accessoryIndicatorType:KLineAccessoryIndicatorKDJ];
}

/**
 清理十字叉图层
 */
- (void)clearCrossViewLayer
{
    [self.crossViewLayer.sublayers makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
    [self.crossViewLayer removeFromSuperlayer];
}

- (void)drawCrossViewWithX:(float)x
{
    [self clearCrossViewLayer];
    
    //根据坐标计算索引
    float unitW = CGRectGetWidth(_mainRect) / [YKKlineViewConfig kLineCandleCount];
    int index = (int)(x / unitW);
    if (index >= self.kLineModelArr.count)
    {
        index = (int)self.kLineModelArr.count - 1;
    }
    YKKLineModel *model = self.kLineModelArr[index + _startIndex];
    YKCandlePointModel *pointModel = self.displayPointArr[index];
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    //竖线
    [path moveToPoint:CGPointMake(pointModel.cPoint.x, CGRectGetMinY(_mainRect))];
    [path addLineToPoint:CGPointMake(pointModel.cPoint.x, CGRectGetMaxY(_mainRect))];
    
    //横线
    [path moveToPoint:CGPointMake(CGRectGetMinX(_mainRect), pointModel.cPoint.y)];
    [path addLineToPoint:CGPointMake(CGRectGetMaxX(_mainRect), pointModel.cPoint.y)];
    //设置横竖线的属性
    self.crossViewLayer.path = path.CGPath;
    self.crossViewLayer.lineWidth = 1.f;
    self.crossViewLayer.strokeColor = [UIColor blackColor].CGColor;
    self.crossViewLayer.fillColor = [UIColor clearColor].CGColor;
    //取出数据模型
    NSDictionary *attribute = @{NSFontAttributeName:[UIFont systemFontOfSize:9.f]};
    //计算各种rect
    NSDate *detaildate = [NSDate dateWithTimeIntervalSince1970:model.timeStamp];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd"];
    NSString *timeStr = [dateFormatter stringFromDate:detaildate];
    NSString *priceStr = [NSString stringWithFormat:@"%.2f", model.close];
    CGRect timeStrRect = [self rectOfNSString:timeStr attribute:attribute];
    CGRect priceStrRect = [self rectOfNSString:priceStr attribute:attribute];
    
    CGRect maskTimeRect = CGRectMake(pointModel.cPoint.x - CGRectGetWidth(timeStrRect)/2-5.f,
                                     CGRectGetMaxY(_mainRect),
                                     CGRectGetWidth(timeStrRect)+10.f,
                                     CGRectGetHeight(timeStrRect) + 5.f);
    CGRect maskPriceRect = CGRectMake(CGRectGetMinX(_mainRect),
                                      pointModel.cPoint.y - CGRectGetHeight(priceStrRect)/2-2.5f,
                                      CGRectGetWidth(priceStrRect)+10.f,
                                      CGRectGetHeight(priceStrRect)+5.f);
    
    CGRect timeRect = CGRectMake(CGRectGetMinX(maskTimeRect)+5.f, CGRectGetMinY(maskTimeRect)+2.5f, CGRectGetWidth(timeStrRect), CGRectGetHeight(timeStrRect));
    CGRect priceRect = CGRectMake(CGRectGetMinX(maskPriceRect)+5.f, CGRectGetMinY(maskPriceRect)+2.5f, CGRectGetWidth(priceStrRect), CGRectGetHeight(priceStrRect));
    //生成时间方块图层
    YKCAShapeLayer *timeLayer = [YKCAShapeLayer getRectLayerWithRect:maskTimeRect dataRect:timeRect dataStr:timeStr fontSize:9.f textColor:[UIColor whiteColor] backColor:[UIColor blackColor]];
    //生成价格方块图层
    YKCAShapeLayer *priceLayer = [YKCAShapeLayer getRectLayerWithRect:maskPriceRect dataRect:priceRect dataStr:priceStr fontSize:9.f textColor:[UIColor whiteColor] backColor:[UIColor blackColor]];
    
    //把3个图层全部添加到十字叉图层中
    [self.crossViewLayer addSublayer:timeLayer];
    [self.crossViewLayer addSublayer:priceLayer];
    
    //再添加到分时图view的图层中
    [self.layer addSublayer:self.crossViewLayer];
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
 返回参数列表中的最大值
 
 @param value 参数列表
 @return 返回最大值
 */
- (float)getMaxValue:(NSNumber *)value, ...NS_REQUIRES_NIL_TERMINATION
{
    //NS_REQUIRES_NIL_TERMINATION, 用于编译时非nil结尾的检查
    float maxValue = (float)INT64_MIN;
    
    va_list args;
    
    va_start(args, value);
    
    if(value)
    {
        NSNumber * valueNum = @0.f;
        if(isnan([value floatValue])) value = @0.f;
        maxValue = [value floatValue];
        while(1)
        {
            valueNum = va_arg(args, NSNumber *);
            if(isnan([valueNum floatValue])) valueNum = @0.f;
            if(valueNum == nil)
            {
                break;
            }else
            {
                if(([valueNum floatValue] > maxValue) && ([valueNum floatValue] > 0.f))
                {
                    maxValue = [valueNum floatValue];
                }
            }
            
        }
    }
    
    va_end(args);
    return maxValue;
}

/**
 返回参数列表中的最小值
 
 @param value 参数列表
 @return 返回最小值
 */
- (float)getMinValue:(NSNumber *)value, ...NS_REQUIRES_NIL_TERMINATION
{
    //NS_REQUIRES_NIL_TERMINATION, 用于编译时非nil结尾的检查
    float minValue = (float)INT64_MAX;
    
    va_list args;
    
    va_start(args, value);
    
    
    if(value)
    {
        NSNumber * valueNum = @0.f;
        if(isnan([value floatValue])) value = @0.f;
        minValue = [value floatValue];
        while(1)
        {
            valueNum = va_arg(args, NSNumber *);
            if(isnan([valueNum floatValue])) valueNum = @0.f;
            if(valueNum == nil)
            {
                break;
            }else
            {
                if(([valueNum floatValue] < minValue) && ([valueNum floatValue] > 0.f))
                {
                    minValue = [valueNum floatValue];
                }
            }
        }
    }
    
    va_end(args);
    return minValue;
}

- (CAShapeLayer *)crossViewLayer
{
    if (!_crossViewLayer)
    {
        _crossViewLayer = [CAShapeLayer layer];
    }
    
    return _crossViewLayer;
}

- (CAShapeLayer *)mainLayer
{
    if (!_mainLayer) {
        _mainLayer = [YKCAShapeLayer layer];
    }
    
    return _mainLayer;
}

- (NSMutableArray *)displayPointArr
{
    if (!_displayPointArr)
    {
        _displayPointArr = [NSMutableArray array];
    }
    
    return _displayPointArr;
}

@end
