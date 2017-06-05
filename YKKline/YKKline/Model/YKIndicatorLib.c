//
//  YKIndicatorLib.c
//  YKKline
//
//  Created by nethanhan on 2017/6/5.
//  Copyright © 2017年 nethanhan. All rights reserved.
//

#include "YKIndicatorLib.h"
#include "YKIndicatorBaseLib.h"
#include <math.h>

#pragma mark - BOLL

/**
 计算std值

 @param close 收盘价数组
 @param length 数组长度
 @param m 参数m
 @param std 存储std值的数组
 */
void calBollStd(double close[], int length, int m, double std[])
{
    for (int idx=0; idx<length; idx++)
    {
        std[idx] = calStd(close, m, length, idx);
    }
}

/**
 计算ub值

 @param std std数组
 @param boll boll数组
 @param length 数组长度
 @param ub 存储ub值的数组
 */
void calUb(double std[], double boll[], int length, double ub[])
{
    for (int idx=0; idx<length; idx++)
    {
        ub[idx] = boll[idx] + 2 * std[idx];
    }
}

/**
 计算lb值

 @param std std数组
 @param boll boll数组
 @param length 数组长度
 @param lb 存储lb值的数组
 */
void calLb(double std[], double boll[], int length, double lb[])
{
    for (int idx=0; idx<length; idx++)
    {
        lb[idx] = boll[idx] - 2 * std[idx];
    }
}

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
                      double lb[])
{
    /*
     指标公式
     BOLL:MA(CLOSE,M);
     UB:BOLL+2*STD(CLOSE,M);
     LB:BOLL-2*STD(CLOSE,M);
     */
    double close[length];
    for (int idx=0; idx<length; idx++)
    {
        close[idx] = value[idx][3];
    }
    
    calMa(close, length, m, boll);
    double std[length];
    calBollStd(close, length, m, std);
    calUb(std, boll, length, ub);
    calLb(std, boll, length, lb);
}

#pragma mark - MA

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
                    double ma3[])
{
    /*
     指标公式
     MA1:MA(CLOSE,M1);
     MA2:MA(CLOSE,M2);
     MA3:MA(CLOSE,M3);
     */
    double close[length];
    for (int idx=0; idx<length; idx++)
    {
        close[idx] = value[idx][3];
    }
    
    calMa(close, length, m1, ma1);
    calMa(close, length, m2, ma2);
    calMa(close, length, m3, ma3);
}

#pragma mark - MACD

/**
 计算macd指标中的dif值

 @param close 收盘价数组
 @param length 数组长度
 @param dif 存储dif值的数组
 @param SHORT 参数short值
 @param LONG 参数long值
 */
void calDif(double close[],
            int length,
            double dif[],
            int SHORT,
            int LONG)
{
    double shortEma[length];
    double longEma[length];
    
    calEma(close, length, SHORT, shortEma);
    calEma(close, length, LONG, longEma);
    
    for (int idx=0; idx<length; idx++)
    {
        dif[idx] = shortEma[idx] - longEma[idx];
    }
}

/**
 计算macd指标中的dea值

 @param dif dif数组
 @param dea dea数组
 @param length 数组长度
 @param MID 参数mid值
 */
void calDea(double dif[],
            double dea[],
            int length,
            int MID)
{
    calEma(dif, length, MID, dea);
}

/**
 计算macd指标中的macd值

 @param dif dif数组
 @param dea dea数组
 @param length 数组长度
 @param macd 存储macd值的数组
 */
void calMacd(double dif[],
             double dea[],
             int length,
             double macd[])
{
    for (int idx=0; idx<length; idx++)
    {
        macd[idx] = (dif[idx] - dea[idx]) * 2.f;
    }
}

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
                      double macd[])
{
    /*
     指标公式
     DIF:EMA(CLOSE,SHORT)-EMA(CLOSE,LONG);
     DEA:EMA(DIF,MID);
     MACD:(DIF-DEA)*2,COLORSTICK;
     */
    double close[length];
    for (int idx=0; idx<length; idx++)
    {
        close[idx] = value[idx][3];
    }
    
    calDif(close, length, dif, SHORT, LONG);
    calDea(dif, dea, length, MID);
    calMacd(dif, dea, length, macd);
}

#pragma mark - KDJ

/**
 计算KDJ中的rsv值

 @param value HLOC二维数组
 @param length 数组长度
 @param n 参数n
 @param rsv 存放rsv值的数组
 */
void calRsv(double value[][4], int length, int n, double rsv[])
{
    double llv = 0;
    double hhv = 0;
    for (int idx=0; idx<length; idx++)
    {
        llv = calLlv(value, length, n, idx, 1);
        hhv = calHhv(value, length, n, idx, 0);
        rsv[idx] = (value[idx][3] - llv)/ (hhv - llv) * 100;
    }
}

/**
 计算KDJ中的k值

 @param rsv rsv值数组
 @param length 数组长度
 @param m1 参数m1
 @param kdjK 存放k值的数组
 */
void calKdjK(double rsv[], int length, int m1, double kdjK[])
{
    calSma(rsv, length, m1, 1, kdjK);
}

/**
 计算KDJ中的d值

 @param kdjK k值数组
 @param length 数组长度
 @param m2 参数m2
 @param kdjD 存放d值的数组
 */
void calKdjD(double kdjK[], int length, int m2, double kdjD[])
{
    calSma(kdjK, length, m2, 1, kdjD);
}


/**
 计算KDJ中的j值

 @param kdjK k值数组
 @param kdjD d值数组
 @param length 数组长度
 @param kdjJ 存放j值的数组
 */
void calKdjJ(double kdjK[], double kdjD[], int length, double kdjJ[])
{
    for (int idx=0; idx<length; idx++)
    {
        kdjJ[idx] = 3 * kdjK[idx] - 2 * kdjD[idx];
    }
}

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
                     double kdjJ[])
{
    /*
     指标公式
     RSV:=(CLOSE-LLV(LOW,N))/(HHV(HIGH,N)-LLV(LOW,N))*100;
     K:SMA(RSV,M1,1);
     D:SMA(K,M2,1);
     J:3*K-2*D;
     */
    double rsv[length];
    calRsv(value, length, n, rsv);
    calKdjK(rsv, length, m1, kdjK);
    calKdjD(kdjK, length, m2, kdjD);
    calKdjJ(kdjK, kdjD, length, kdjJ);
}

#pragma mark - RSI

/**
 计算RSI中的rsi值

 @param close 收盘价数组
 @param length 数组长度
 @param n 参数n
 @param rsi 存储rsi值的数组
 */
void calRsi(double close[], int length, int n, double rsi[])
{
    double maxArr[length];
    double absArr[length];
    
    for (int idx=0; idx<length; idx++)
    {
        maxArr[idx] = fmax(close[idx] - calRef(close, length, idx, 1), 0);
        absArr[idx] = fabs(close[idx] - calRef(close, length, idx, 1));
    }
    
    double maxSma[length];
    double absSma[length];
    calSma(maxArr, length, n, 1, maxSma);
    calSma(absArr, length, n, 1, absSma);
    
    for (int idx=0; idx<length; idx++)
    {
        rsi[idx] = maxSma[idx] / absSma[idx] * 100;
    }
}

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
                     double RSI3[])
{
    /*
     指标公式
     LC:=REF(CLOSE,1);
     RSI1:SMA(MAX(CLOSE-LC,0),N1,1)/SMA(ABS(CLOSE-LC),N1,1)*100;
     RSI2:SMA(MAX(CLOSE-LC,0),N2,1)/SMA(ABS(CLOSE-LC),N2,1)*100;
     RSI3:SMA(MAX(CLOSE-LC,0),N3,1)/SMA(ABS(CLOSE-LC),N3,1)*100;
     */
    double close[length];
    for (int idx=0; idx<length; idx++)
    {
        close[idx] = value[idx][3];
    }
    
    calRsi(close, length, n1, RSI1);
    calRsi(close, length, n2, RSI2);
    calRsi(close, length, n3, RSI3);
}

#pragma mark - BIAS

/**
 计算BIAS中的bias值

 @param close 收盘价数组
 @param length 数组长度
 @param n 周期参数n
 @param bias 存放bias值的数组
 */
void calBias(double close[],
             int length,
             int n,
             double bias[])
{
    double closeMa[length];
    calMa(close, length, n, closeMa);
    
    for (int idx=0; idx<length; idx++)
    {
        bias[idx] = (close[idx] - closeMa[idx]) / closeMa[idx] * 100;
    }
}

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
                      double BIAS3[])
{
    /*
     指标公式
     BIAS1 :(CLOSE-MA(CLOSE,N1))/MA(CLOSE,N1)*100;
     BIAS2 :(CLOSE-MA(CLOSE,N2))/MA(CLOSE,N2)*100;
     BIAS3 :(CLOSE-MA(CLOSE,N3))/MA(CLOSE,N3)*100;
     */
    double close[length];
    for (int idx=0; idx<length; idx++)
    {
        close[idx] = value[idx][3];
    }
    
    calBias(close, length, n1, BIAS1);
    calBias(close, length, n2, BIAS2);
    calBias(close, length, n3, BIAS3);
}




