//
//  YKOriginalModel.m
//  kLineDemo
//
//  Created by nethanhan on 2017/5/26.
//  Copyright © 2017年 nethanhan. All rights reserved.
//

#import "YKOriginalModel.h"
#import "YYModel.h"

@implementation YKOriginalModel

+ (NSArray <YKKLineModel *>*)getKLineModelArr
{
    YKOriginalModel *model = [YKOriginalModel yy_modelWithJSON:[YKOriginalModel getJsonFromFile:@"kLine"]];
    
    NSMutableArray *kLineArr = [NSMutableArray array];
    for (int idx=(int)model.Data.count-1; idx>=0; idx--)
    {
        NSArray *idxArr = model.Data[idx];
        [kLineArr addObject:[YKKLineModel kLineModelWithOpen:[idxArr[1] doubleValue]
                                                       close:[idxArr[4] doubleValue]
                                                        high:[idxArr[2] doubleValue]
                                                         low:[idxArr[3] doubleValue]
                                                   timeStamp:[idxArr[0] longValue]]];
    }
    
    return kLineArr;
}

+ (NSString *)getJsonFromFile:(NSString *)fileName
{
    NSString *pathForJsonFile = [[NSBundle mainBundle] pathForResource:fileName ofType:@"json"];
    NSString *jsonStr = [NSString stringWithContentsOfFile:pathForJsonFile encoding:NSUTF8StringEncoding error:nil];
    return jsonStr;
}

+ (NSArray <YKKLineModel *>*)getKLineModelWithOriginalModel:(YKOriginalModel *)orighinalModel
{
    return nil;
}

@end
