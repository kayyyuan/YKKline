//
//  YKKLineModel.h
//  kLineDemo
//
//  Created by nethanhan on 2017/5/26.
//  Copyright © 2017年 nethanhan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YKKLineModel : NSObject

@property (nonatomic, assign) long timeStamp;
@property (nonatomic, assign) float open;
@property (nonatomic, assign) float close;
@property (nonatomic, assign) float high;
@property (nonatomic, assign) float low;

+ (YKKLineModel *)kLineModelWithOpen:(float)open close:(float)close high:(float)high low:(float)low timeStamp:(long)timeStamp;

@end
