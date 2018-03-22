//
//  YKCAShapeLayer+YKBorderLayer.m
//  YKKline
//
//  Created by nethanhan on 2018/3/7.
//  Copyright © 2018年 nethanhan. All rights reserved.
//

#import "YKCAShapeLayer+YKBorderLayer.h"
#import <UIKit/UIBezierPath.h>
#import <UIKit/UIScreen.h>

@implementation YKCAShapeLayer (YKBorderLayer)

+ (YKCAShapeLayer *)getRectLayerWithRect:(CGRect)frameRect
                                dataRect:(CGRect)dataRect
                                 dataStr:(NSString *)dataStr
                                fontSize:(CGFloat)fontSize
                               textColor:(UIColor *)textColor
                               backColor:(UIColor *)backColor
{
    YKCAShapeLayer *layer = [YKCAShapeLayer layer];
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:frameRect];
    layer.path = path.CGPath;
    layer.strokeColor = textColor.CGColor;
    layer.fillColor = backColor.CGColor;
    
    CATextLayer *textLayer = [CATextLayer layer];
    textLayer.frame = dataRect;
    textLayer.string = dataStr;
    textLayer.fontSize = fontSize;
    textLayer.foregroundColor = textColor.CGColor;
    textLayer.backgroundColor = [UIColor clearColor].CGColor;
    textLayer.alignmentMode = kCAAlignmentCenter;
    textLayer.contentsScale = [UIScreen mainScreen].scale;
    
    [layer addSublayer:textLayer];
    
    return layer;
    
}

@end
