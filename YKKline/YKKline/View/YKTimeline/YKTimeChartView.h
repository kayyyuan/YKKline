//
//  YKTimeChartView.h
//  timeLineDemo
//
//  Created by nethanhan on 2017/5/18.
//  Copyright © 2017年 nethanhan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YKTimeChartModel.h"

@interface YKTimeChartView : UIView

/**
 分时线数据模型数组
 */
@property (nonatomic, strong) NSArray <YKTimeChartModel *> * timeCharModelArr;

/**
 昨日收盘价
 */
@property (nonatomic, assign) double yc;


/**
 绘制
 */
- (void)draw;

/**
 绘制十字叉

 @param point 长按时获取到的坐标点
 */
- (void)drawTicksWithPoint:(CGPoint)point;

/**
 清理长按响应图层
 */
- (void)clearTicks;

@end
