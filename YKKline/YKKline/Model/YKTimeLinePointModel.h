//
//  YKTimeLinePointModel.h
//  timeLineDemo
//
//  Created by nethanhan on 2017/5/19.
//  Copyright © 2017年 nethanhan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CGGeometry.h>

@interface YKTimeLinePointModel : NSObject

/**
 分时线坐标点
 */
@property (nonatomic, assign) CGPoint linePoint;

/**
 均线坐标点
 */
@property (nonatomic, assign) CGPoint avgPoint;

@end
