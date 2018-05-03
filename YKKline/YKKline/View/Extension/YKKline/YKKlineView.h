//
//  YKKlineView.h
//  YKKline
//
//  Created by nethanhan on 2017/6/4.
//  Copyright © 2017年 nethanhan. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 k线主图类型
 
 - KLineMainCandle: 蜡烛
 - KLineMainOHLC: OHLC
 */
typedef NS_ENUM(NSUInteger, KLineMainType) {
    KLineMainCandle = 1000,
    KLineMainOHLC,
};

/**
 k线主图指标类型

 - KLineMainIndicatorMA: MA指标
 - KLineMainIndicatorBOLL: BOLL指标
 - KLineMainIndicatorQIANKUN: QIANKUN指标
 */
typedef NS_ENUM(NSUInteger, KLineMainIndicatorType){
    KLineMainIndicatorMA = 1000,
    KLineMainIndicatorBOLL,
    KLineMainIndicatorQIANKUN
};

/**
 k线副图指标类型

 - KLineAccessoryIndicatorMACD: MACD指标
 - KLineAccessoryIndicatorKDJ: KDJ指标
 - KLineAccessoryIndicatorJUJI: JUJI指标
 */
typedef NS_ENUM(NSUInteger, KLineAccessoryIndicatorType){
    KLineAccessoryIndicatorMACD = 1000,
    KLineAccessoryIndicatorKDJ,
    KLineAccessoryIndicatorJUJI
};

@interface YKKlineView : UIView

/**
 k线数据模型
 */
@property (nonatomic, strong) NSArray *kLineModelArr;

/**
 绘制K线

 @param mainType 主图类型
 @param mainIndicatorType 主图指标
 @param accessoryIndicatorType 副图指标
 */
- (void)drawWithMainType:(KLineMainType)mainType mainIndicatorType:(KLineMainIndicatorType)mainIndicatorType accessoryIndicatorType:(KLineAccessoryIndicatorType)accessoryIndicatorType;

/**
 向右拖拽
 
 @param offsetcount 拖拽的偏移量
 */
- (void)dragRightOffsetcount:(int)offsetcount;

/**
 向左拖拽
 
 @param offsetcount 拖拽的偏移量
 */
- (void)dragLeftOffsetcount:(int)offsetcount;

- (void)drawCrossViewWithX:(float)x;

- (void)clearCrossViewLayer;

@end
