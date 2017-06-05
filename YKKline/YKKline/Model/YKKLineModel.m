//
//  YKKLineModel.m
//  kLineDemo
//
//  Created by nethanhan on 2017/5/26.
//  Copyright © 2017年 nethanhan. All rights reserved.
//

#import "YKKLineModel.h"

@implementation YKKLineModel

+ (YKKLineModel *)kLineModelWithOpen:(float)open close:(float)close high:(float)high low:(float)low timeStamp:(long)timeStamp
{
    YKKLineModel *model = [YKKLineModel new];
    model.open = open;
    model.close = close;
    model.high = high;
    model.low = low;
    model.timeStamp = timeStamp;
    
    return model;
}

@end
