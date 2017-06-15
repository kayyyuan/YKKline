//
//  YKTimelineOriginalModel.m
//  YKKline
//
//  Created by nethanhan on 2017/6/15.
//  Copyright © 2017年 nethanhan. All rights reserved.
//

#import "YKTimelineOriginalModel.h"
#import "YYModel.h"

@implementation YKTimelineOriginalModel

/**
 获取分时线模型
 
 @param yc 获取昨日收盘价
 @return 返回分时线模型
 */
+ (NSArray <YKTimeChartModel *>*)getTimeChartModelArrAtYc:(double *)yc
{
    YKTimelineOriginalModel *model = [YKTimelineOriginalModel yy_modelWithJSON:[YKTimelineOriginalModel getJsonFromFile:@"timeLineData"]];
    *yc = model.yClosePrice;
    return [YKTimelineOriginalModel getTimeChartModelArrWithOriginalModel:model];
}

/**
 读取本地json文件
 
 @param fileName 文件名
 @return json字符串
 */
+ (NSString *)getJsonFromFile:(NSString *)fileName
{
    NSString *pathForJsonFile = [[NSBundle mainBundle] pathForResource:fileName ofType:@"json"];
    NSString *jsonStr = [NSString stringWithContentsOfFile:pathForJsonFile encoding:NSUTF8StringEncoding error:nil];
    return jsonStr;
}

/**
 转换原始数据
 
 @param originalModel 原始数据
 @return 返回转换后的数组
 */
+ (NSArray <YKTimeChartModel *>*)getTimeChartModelArrWithOriginalModel:(YKTimelineOriginalModel *)originalModel
{
    NSMutableArray *containerArr = [NSMutableArray array];
    int j=0;
    //因为数据展示周期是24小时，共1440分钟，故创建1440个元素的数组
    for (int i=361; i<=1800; i++)
    {
        if (i>1440)
        {
            j=i-1440;
        }else
        {
            j=i;
        }
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        //分钟
        [dict setValue:@(j) forKey:@"minute"];
        //索引
        [dict setValue:@(i-361) forKey:@"index"];
        //价格
        [dict setValue:@(0) forKey:@"price"];
        //均价
        [dict setValue:@(0) forKey:@"averagePrice"];
        [containerArr addObject:dict];
    }
    
    int count = (int)originalModel.timeChartData.count;
    //循环通过分钟把价格赋入
    for (int idx=0; idx<count; idx++)
    {
        NSArray *idxArr = originalModel.timeChartData[idx];
        //转换时间
        NSTimeInterval time = [idxArr[0] longValue];
        NSDate *detaildate = [NSDate dateWithTimeIntervalSince1970:time];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"HH:mm"];
        NSString *dateStr = [dateFormatter stringFromDate:detaildate];
        //截取到时和分钟
        NSRange range = [dateStr rangeOfString:@":"];
        NSInteger left =  [[dateStr substringToIndex:range.location] integerValue];
        NSInteger right = [[dateStr substringFromIndex:range.location+1] integerValue];
        //转换为分钟数
        NSInteger min = left*60+right;
        
        if ((min<1440) && (min>=360))
        {//当是6点以后的话，分钟数是360-1440
            NSMutableDictionary *dic = containerArr[min-360];
            [dic setValue:@([idxArr[1] doubleValue]) forKey:@"price"];
            [dic setValue:@([idxArr[2] doubleValue]) forKey:@"averagePrice"];
            
        } else
        {//当是6点以前的话，分钟数是0-360
            NSMutableDictionary *dic = containerArr[min+1080];
            [dic setValue:@([idxArr[1] doubleValue]) forKey:@"price"];
            [dic setValue:@([idxArr[2] doubleValue]) forKey:@"averagePrice"];
            
        }
    }
    
    //当其中有0时，补数据
    NSMutableArray *temp = [NSMutableArray array];
    NSMutableDictionary *tmp = containerArr[0];
    if ([[tmp objectForKey:@"price"] integerValue] == 0)
    {
        [tmp setValue:[NSNumber numberWithDouble:originalModel.yClosePrice] forKey:@"price"];
        [tmp setValue:[NSNumber numberWithDouble:originalModel.yClosePrice] forKey:@"averagePrice"];
    }
    int flag = 0;
    for (int i = (int)containerArr.count-1; i >= 0; i--)
    {
        NSDictionary *dict = containerArr[i];
        if ([[dict objectForKey:@"price"] intValue] != 0)
        {
            flag = i;
            break;
        }
    }
    //循环赋值
    for (int i=0; i<=flag; i++)
    {
        NSMutableDictionary *dic_i = containerArr[i];
        if ([[dic_i objectForKey:@"price"] intValue] == 0)
        {
            for (int j=i-1; j>=0; j--)
            {
                NSMutableDictionary *dic_j = containerArr[j];
                if ([[dic_j objectForKey:@"price"] intValue] != 0)
                {
                    [dic_i setValue:[dic_j objectForKey:@"price"] forKey:@"price"];
                    [dic_i setValue:[dic_j objectForKey:@"averagePrice"] forKey:@"averagePrice"];
                    break;
                }
            }
        }
        YKTimeChartModel *model = [YKTimeChartModel new];
        model.min = [[dic_i objectForKey:@"minute"] intValue];
        model.avp = [[dic_i objectForKey:@"averagePrice"] doubleValue];
        model.clp = [[dic_i objectForKey:@"price"] doubleValue];
        
        [temp addObject:model];
    }
    
    return temp;
}

@end
