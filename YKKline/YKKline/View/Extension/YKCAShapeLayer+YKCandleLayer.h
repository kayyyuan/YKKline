//
//  YKCAShapeLayer+YKCandleLayer.h
//  YKKline
//
//  Created by nethanhan on 2018/3/7.
//  Copyright © 2018年 nethanhan. All rights reserved.
//

#import "YKCAShapeLayer.h"
#import "YKCandlePointModel.h"

@interface YKCAShapeLayer (YKCandleLayer)

/**
 生成OHLC

 @param model OHLC坐标模型
 @param candleW OHLC宽度
 @return 返回图层
 */
+ (YKCAShapeLayer *)getOHLCLayerWithPointModel:(YKCandlePointModel *)model candleW:(double)candleW;


/**
 生成蜡烛

 @param model 蜡烛坐标模型
 @param candleW 蜡烛宽度
 @return 返回图层
 */
+ (YKCAShapeLayer *)getCandleLayerWithPointModel:(YKCandlePointModel *)model candleW:(double)candleW;

@end
