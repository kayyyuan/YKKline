//
//  YKCandlePointModel.h
//  KLineCandle
//
//  Created by nethanhan on 2017/5/24.
//  Copyright © 2017年 nethanhan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CGGeometry.h>

@interface YKCandlePointModel : NSObject

@property (nonatomic, assign) CGPoint oPoint;
@property (nonatomic, assign) CGPoint hPoint;
@property (nonatomic, assign) CGPoint lPoint;
@property (nonatomic, assign) CGPoint cPoint;

+ (YKCandlePointModel *)candlePointModelWithOpoint:(CGPoint)oPoint
                                            Hpoint:(CGPoint)hPoint
                                            Lpoint:(CGPoint)lPoint
                                            Cpoint:(CGPoint)cPoint;

@end
