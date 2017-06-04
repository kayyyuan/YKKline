//
//  YKKlineViewConfig.h
//  YKKline
//
//  Created by nethanhan on 2017/6/4.
//  Copyright © 2017年 nethanhan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YKKlineViewConfig : NSObject

//获取屏幕 宽度、高度
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
//以iphone6屏幕为基准的宽高比例
#define ADAPTERSCALE  [[UIScreen mainScreen] bounds].size.width/375


+ (float)kLineMainViewHeightScale;

+ (float)kLineAccessoryViewHeightScale;

+ (float)kLineDateHeightScale;

@end
