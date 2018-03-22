//
//  UIColor+YKKlineThemeColor.h
//  YKKline
//
//  Created by nethanhan on 2017/6/4.
//  Copyright © 2017年 nethanhan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (YKKlineThemeColor)

#define ColorWithRGB(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define Color(r,g,b) ColorWithRGB(r,g,b,1.0f)
#define ColorWithHex(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

+ (UIColor *)kLineBackGroundColor;
+ (UIColor *)kLineBorderColor;
+ (UIColor *)kLineCandleRedColor;
+ (UIColor *)kLineCandleGreenColor;

@end
