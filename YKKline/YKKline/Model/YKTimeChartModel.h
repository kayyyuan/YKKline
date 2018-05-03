//
//  YKTimeChartModel.h
//  timeLineDemo
//
//  Created by nethanhan on 2017/5/19.
//  Copyright © 2017年 nethanhan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YKTimeChartModel : NSObject

/**
 分钟
 */
@property (nonatomic, assign) int min;

/**
 平均价
 */
@property (nonatomic, assign) double avp;

/**
 收盘价
 */
@property (nonatomic, assign) double clp;

@end
