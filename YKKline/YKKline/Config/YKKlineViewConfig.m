//
//  YKKlineViewConfig.m
//  YKKline
//
//  Created by nethanhan on 2017/6/4.
//  Copyright © 2017年 nethanhan. All rights reserved.
//

#import "YKKlineViewConfig.h"

static int candleCount = 60;

@implementation YKKlineViewConfig

+ (float)kLineMainViewHeightScale
{
    return 0.6;
}

+ (float)kLineAccessoryViewHeightScale
{
    return 0.37;
}

+ (float)kLineDateHeightScale
{
    return 0.03;
}

+ (int)kLineCandleCount
{
    return candleCount;
}

+ (void)setKlineCandleCount:(int)count
{
    candleCount = count;
}

@end
