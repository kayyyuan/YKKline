//
//  YKIndicatorLib.h
//  YKKline
//
//  Created by nethanhan on 2017/6/5.
//  Copyright © 2017年 nethanhan. All rights reserved.
//

#ifndef YKIndicatorLib_h
#define YKIndicatorLib_h

#include <stdio.h>

/**
 生成MA指标
 
 @param value OHLC二维数组
 @param length 数组长度
 @param m1 参数m1
 @param m2 参数m2
 @param m3 参数m3
 @param ma1 参数m1存放的数组
 @param ma2 参数m2存放的数组
 @param ma3 参数m3存放的数组
 */
void calMAIndicator(double value[][4],
                    int length,
                    int m1,
                    int m2,
                    int m3,
                    double ma1[],
                    double ma2[],
                    double ma3[]);

/**
 生成BOLL指标
 
 @param value HLOC二维数组
 @param length 数组长度
 @param m 参数m
 @param boll 存储boll值的数组
 @param ub 存储ub值的数组
 @param lb 存储lb值的数组
 */
void calBOLLIndicator(double value[][4],
                      int length,
                      int m,
                      double boll[],
                      double ub[],
                      double lb[]);

/**
 生成MACD指标
 
 @param value hloc二维数组
 @param length 数组长度
 @param SHORT 参数short
 @param LONG 参数long
 @param MID 参数mid
 @param dif 存储dif值的数组
 @param dea 存储dea值的数组
 @param macd 存储macd值的数组
 */
void calMACDIndicator(double value[][4],
                      int length,
                      int SHORT,
                      int LONG,
                      int MID,
                      double dif[],
                      double dea[],
                      double macd[]);

/**
 生成KDJ指标
 
 @param value HLOC二维数组
 @param length 数组长度
 @param n 参数n
 @param m1 参数m1
 @param m2 参数m2
 @param kdjK 存放k值的数组
 @param kdjD 存放d值的数组
 @param kdjJ 存放j值的数组
 */
void calKDJIndicator(double value[][4],
                     int length,
                     int n,
                     int m1,
                     int m2,
                     double kdjK[],
                     double kdjD[],
                     double kdjJ[]);

/**
 生成RSI指标
 
 @param value HLOC二维数组
 @param length 数组长度
 @param n1 参数n1
 @param n2 参数n2
 @param n3 参数n3
 @param RSI1 存储周期n1的数组
 @param RSI2 存储周期n2的数组
 @param RSI3 存储周期n3的数组
 */
void calRSIIndicator(double value[][4],
                     int length,
                     int n1,
                     int n2,
                     int n3,
                     double RSI1[],
                     double RSI2[],
                     double RSI3[]);

/**
 生成BIAS指标
 
 @param value HLOC二维数组
 @param length 数组长度
 @param n1 参数n1
 @param n2 参数n2
 @param n3 参数n3
 @param BIAS1 存储周期n1的数组
 @param BIAS2 存储周期n2的数组
 @param BIAS3 存储周期n3的数组
 */
void calBIASIndicator(double value[][4],
                      int length,
                      int n1,
                      int n2,
                      int n3,
                      double BIAS1[],
                      double BIAS2[],
                      double BIAS3[]);

#endif /* YKIndicatorLib_h */
