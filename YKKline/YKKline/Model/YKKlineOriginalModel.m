//
//  YKKlineOriginalModel.m
//  YKKline
//
//  Created by nethanhan on 2017/6/15.
//  Copyright © 2017年 nethanhan. All rights reserved.
//

#import "YKKlineOriginalModel.h"
#import "YYModel.h"
#import "YKIndicatorLib.h"

@implementation YKKlineOriginalModel

+ (NSArray <YKKLineModel *>*)getKLineModelArr
{
    YKKlineOriginalModel *model = [YKKlineOriginalModel yy_modelWithJSON:[YKKlineOriginalModel getJsonFromFile:@"kLine"]];
    
    double price[model.Data.count][4];
    for (int idx=(int)model.Data.count-1; idx>=0; idx--)
    {
        NSArray *idxArr = model.Data[idx];
        price[idx][0] = [idxArr[2] doubleValue];
        price[idx][1] = [idxArr[3] doubleValue];
        price[idx][2] = [idxArr[1] doubleValue];
        price[idx][3] = [idxArr[4] doubleValue];
    }
    
    // 计算MA指标
    double MA_MA1[model.Data.count];
    double MA_MA2[model.Data.count];
    double MA_MA3[model.Data.count];
    YKCalMAIndicator(price, (int)model.Data.count, 5, 10, 20, MA_MA1, MA_MA2, MA_MA3);
    
    // 计算BOLL指标
    double BOLL_BOLL[model.Data.count];
    double BOLL_UB[model.Data.count];
    double BOLL_LB[model.Data.count];
    YKCalBOLLIndicator(price, (int)model.Data.count, 5, BOLL_BOLL, BOLL_UB, BOLL_LB);
    
    // 计算MACD指标
    double MACD_DIF[model.Data.count];
    double MACD_DEA[model.Data.count];
    double MACD_MACD[model.Data.count];
    YKCalMACDIndicator(price, (int)model.Data.count, 12, 26, 9, MACD_DIF, MACD_DEA, MACD_MACD);
    
    // 计算KDJ指标
    double KDJ_K[model.Data.count];
    double KDJ_D[model.Data.count];
    double KDJ_J[model.Data.count];
    YKCalKDJIndicator(price, (int)model.Data.count, 9, 3, 3, KDJ_K, KDJ_D, KDJ_J);
    
    // 计算QIANKUN指标
    double QK_QIAN1[model.Data.count];
    double QK_QIAN2[model.Data.count];
    double QK_KUN1[model.Data.count];
    double QK_KUN2[model.Data.count];
    double QK_DUO[model.Data.count];
    double QK_KONG[model.Data.count];
    YKCalQIANKUNIndicator(price, (int)model.Data.count, QK_QIAN1, QK_QIAN2, QK_KUN1, QK_KUN2, QK_DUO, QK_KONG);
    
    // 计算JUJI指标
    double JJ_KUAI[model.Data.count];
    double JJ_MAN[model.Data.count];
    double JJ_DUO[model.Data.count];
    double JJ_DUO1[model.Data.count];
    double JJ_KONG[model.Data.count];
    double JJ_KONG1[model.Data.count];
    YKCalJUJIIndicator(price, (int)model.Data.count, JJ_KUAI, JJ_MAN, JJ_DUO, JJ_DUO1, JJ_KONG, JJ_KONG1);

    NSMutableArray *kLineArr = [NSMutableArray array];
    for (int idx=(int)model.Data.count-1; idx>=0; idx--)
    {
        NSArray *idxArr = model.Data[idx];
        YKKLineModel *model =[YKKLineModel kLineModelWithOpen:[idxArr[1] floatValue]
                                                        close:[idxArr[4] floatValue]
                                                         high:[idxArr[2] floatValue]
                                                          low:[idxArr[3] floatValue]
                                                    timeStamp:[idxArr[0] longValue]];
        model.MA_MA1 = MA_MA1[idx];
        model.MA_MA2 = MA_MA2[idx];
        model.MA_MA3 = MA_MA3[idx];
        
        model.BOLL_BOLL = BOLL_BOLL[idx];
        model.BOLL_UB = BOLL_UB[idx];
        model.BOLL_lb = BOLL_LB[idx];
        
        model.MACD_MACD = MACD_MACD[idx];
        model.MACD_DEA = MACD_DEA[idx];
        model.MACD_DIF = MACD_DIF[idx];
        
        model.KDJ_K = KDJ_K[idx];
        model.KDJ_D = KDJ_D[idx];
        model.KDJ_J = KDJ_J[idx];
        
        model.QK_QIAN1 = QK_QIAN1[idx];
        model.QK_QIAN2 = QK_QIAN2[idx];
        model.QK_KUN1 = QK_KUN1[idx];
        model.QK_KUN2 = QK_KUN2[idx];
        model.QK_DUO = QK_DUO[idx];
        model.QK_KONG = QK_KONG[idx];
        
        model.JJ_KONG = JJ_KONG[idx];
        model.JJ_KONG1 = JJ_KONG1[idx];
        model.JJ_DUO = JJ_DUO[idx];
        model.JJ_DUO1 = JJ_DUO1[idx];
        model.JJ_KUAI = JJ_KUAI[idx];
        model.JJ_MAN = JJ_MAN[idx];
        
        [kLineArr addObject:model];
    }

    return kLineArr;
}

+ (NSString *)getJsonFromFile:(NSString *)fileName
{
    NSString *pathForJsonFile = [[NSBundle mainBundle] pathForResource:fileName ofType:@"json"];
    NSString *jsonStr = [NSString stringWithContentsOfFile:pathForJsonFile encoding:NSUTF8StringEncoding error:nil];
    return jsonStr;
}

+ (NSArray <YKKLineModel *>*)getKLineModelWithOriginalModel:(YKKlineOriginalModel *)orighinalModel
{
    return nil;
}

@end
