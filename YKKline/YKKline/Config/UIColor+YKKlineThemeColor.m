//
//  UIColor+YKKlineThemeColor.m
//  YKKline
//
//  Created by nethanhan on 2017/6/4.
//  Copyright © 2017年 nethanhan. All rights reserved.
//

#import "UIColor+YKKlineThemeColor.h"

@implementation UIColor (YKKlineThemeColor)

+ (UIColor *)kLineBackGroundColor
{
    return ColorWithRGB(250, 250, 250, 1);
}

+ (UIColor *)kLineBorderColor
{
    return Color(222, 222, 222);
}

+ (UIColor *)kLineCandleRedColor
{
    return ColorWithHex(0xff4848);
}

+ (UIColor *)kLineCandleGreenColor
{
    return ColorWithHex(0x00c053);
}

@end
