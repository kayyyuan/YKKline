//
//  CAShapeLayer+YKOHLCLayer.h
//  YKKline
//
//  Created by nethanhan on 2017/6/5.
//  Copyright © 2017年 nethanhan. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "YKCandlePointModel.h"

@interface CAShapeLayer (YKOHLCLayer)

/**
 生成OHLC
 
 @param model 蜡烛坐标模型
 @return 返回图层
 */
+ (CAShapeLayer *)getOHLCLayerWithPointModel:(YKCandlePointModel *)model candleW:(double)candleW;


@end
