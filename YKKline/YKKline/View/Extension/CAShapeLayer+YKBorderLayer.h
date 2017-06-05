//
//  CAShapeLayer+YKBorderLayer.h
//  YKKline
//
//  Created by nethanhan on 2017/6/5.
//  Copyright © 2017年 nethanhan. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIColor.h>

@interface CAShapeLayer (YKBorderLayer)

+ (CAShapeLayer *)getRectLayerWithRect:(CGRect)frameRect
                              dataRect:(CGRect)dataRect
                               dataStr:(NSString *)dataStr
                              fontSize:(CGFloat)fontSize
                             textColor:(UIColor *)textColor
                             backColor:(UIColor *)backColor;

@end
