//
//  CAShapeLayer+YKCandleLayer.h
//  YKKline
//
//  Created by nethanhan on 2017/6/5.
//  Copyright © 2017年 nethanhan. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "YKCandlePointModel.h"

@interface CAShapeLayer (YKCandleLayer)

+ (CAShapeLayer *)getCandleLayerWithPointModel:(YKCandlePointModel *)model candleW:(double)candleW;

@end
