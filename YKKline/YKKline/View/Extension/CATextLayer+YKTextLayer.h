//
//  CATextLayer+YKTextLayer.h
//  YKKline
//
//  Created by nethanhan on 2017/6/5.
//  Copyright © 2017年 nethanhan. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIColor.h>

@interface CATextLayer (YKTextLayer)

/**
 绘制文字
 
 @param text 字符串
 @param textColor 文字颜色
 @param bgColor 背景颜色
 @param frame 文字frame
 @return 返回textLayer
 */
+ (CATextLayer *)getTextLayerWithString:(NSString *)text
                              textColor:(UIColor *)textColor
                               fontSize:(NSInteger)fontSize
                        backgroundColor:(UIColor *)bgColor
                                  frame:(CGRect)frame;

@end
