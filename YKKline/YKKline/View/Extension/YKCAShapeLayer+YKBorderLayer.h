//
//  YKCAShapeLayer+YKBorderLayer.h
//  YKKline
//
//  Created by nethanhan on 2018/3/7.
//  Copyright © 2018年 nethanhan. All rights reserved.
//

#import "YKCAShapeLayer.h"
#import <UIKit/UIColor.h>
#import <CoreGraphics/CGBase.h>

@interface YKCAShapeLayer (YKBorderLayer)

+ (YKCAShapeLayer *)getRectLayerWithRect:(CGRect)frameRect
                                dataRect:(CGRect)dataRect
                                 dataStr:(NSString *)dataStr
                                fontSize:(CGFloat)fontSize
                               textColor:(UIColor *)textColor
                               backColor:(UIColor *)backColor;

@end
