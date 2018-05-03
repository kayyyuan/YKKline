//
//  YKKLineModel.h
//  kLineDemo
//
//  Created by nethanhan on 2017/5/26.
//  Copyright © 2017年 nethanhan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YKKLineModel : NSObject

// 时间戳
@property (nonatomic, assign) long timeStamp;

// OHLC
@property (nonatomic, assign) float open;
@property (nonatomic, assign) float close;
@property (nonatomic, assign) float high;
@property (nonatomic, assign) float low;

// MA
@property (nonatomic, assign) float MA_MA1;
@property (nonatomic, assign) float MA_MA2;
@property (nonatomic, assign) float MA_MA3;

// BOLL
@property (nonatomic, assign) float BOLL_BOLL;
@property (nonatomic, assign) float BOLL_UB;
@property (nonatomic, assign) float BOLL_lb;

// QIANKUN
@property (nonatomic, assign) float QK_QIAN1;
@property (nonatomic, assign) float QK_QIAN2;
@property (nonatomic, assign) float QK_KUN1;
@property (nonatomic, assign) float QK_KUN2;
@property (nonatomic, assign) float QK_DUO;
@property (nonatomic, assign) float QK_KONG;

// MACD
@property (nonatomic, assign) float MACD_DIF;
@property (nonatomic, assign) float MACD_DEA;
@property (nonatomic, assign) float MACD_MACD;

// KDJ
@property (nonatomic, assign) float KDJ_K;
@property (nonatomic, assign) float KDJ_D;
@property (nonatomic, assign) float KDJ_J;

// JUJI
@property (nonatomic, assign) float JJ_KUAI;
@property (nonatomic, assign) float JJ_MAN;
@property (nonatomic, assign) float JJ_DUO;
@property (nonatomic, assign) float JJ_DUO1;
@property (nonatomic, assign) float JJ_KONG;
@property (nonatomic, assign) float JJ_KONG1;



+ (YKKLineModel *)kLineModelWithOpen:(float)open
                               close:(float)close
                                high:(float)high
                                 low:(float)low
                           timeStamp:(long)timeStamp;

@end
