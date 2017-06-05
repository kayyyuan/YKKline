//
//  YKCandlePointModel.m
//  KLineCandle
//
//  Created by nethanhan on 2017/5/24.
//  Copyright © 2017年 nethanhan. All rights reserved.
//

#import "YKCandlePointModel.h"

@implementation YKCandlePointModel

+ (YKCandlePointModel *)candlePointModelWithOpoint:(CGPoint)oPoint
                                            Hpoint:(CGPoint)hPoint
                                            Lpoint:(CGPoint)lPoint
                                            Cpoint:(CGPoint)cPoint
{
    YKCandlePointModel * model = [YKCandlePointModel new];
    model.oPoint = oPoint;
    model.hPoint = hPoint;
    model.lPoint = lPoint;
    model.cPoint = cPoint;
    
    return model;
}

@end
