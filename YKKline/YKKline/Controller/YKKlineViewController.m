//
//  YKKlineViewController.m
//  YKKline
//
//  Created by nethanhan on 2017/6/4.
//  Copyright © 2017年 nethanhan. All rights reserved.
//

#import "YKKlineViewController.h"
#import "YKKlineView.h"
#import "UIColor+YKKlineThemeColor.h"
#import "YKKlineOriginalModel.h"
#import "YKTimeChartView.h"
#import "YKTimelineOriginalModel.h"
#import "YKSegmentView.h"

@interface YKKlineViewController ()

@property (nonatomic, strong) YKKlineView *kLineView;
@property (nonatomic, strong) YKTimeChartView *timeChartView;
@property (nonatomic, strong) YKSegmentView *segmentView;

@end

@implementation YKKlineViewController

static float kLineGlobalOffset = 0.f;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    [self addTimeLineView];

    [self addKLineView];

    [self addSegmentView];
}

/**
 添加K线视图
 */
- (void)addKLineView
{
    YKKlineView *kLineView = [[YKKlineView alloc] initWithFrame:CGRectMake(14,22+50,CGRectGetWidth(self.view.frame)-28,CGRectGetHeight(self.view.frame) - 22 - 14 - 50)];
    
    kLineView.backgroundColor = [UIColor kLineBackGroundColor];
    _kLineView = kLineView;
    
    [self.view addSubview:_kLineView];
    
    _kLineView.kLineModelArr = [YKKlineOriginalModel getKLineModelArr];
    [self kLineViewAddGesture];
    
    [_kLineView drawWithMainType:KLineMainCandle];
}

/**
 添加分类选择视图
 */
- (void)addSegmentView
{
    _segmentView = [[YKSegmentView alloc] initWithFrame:CGRectMake(14, 22, CGRectGetWidth(self.view.frame)-28, 40)];
    
    [self.view addSubview:_segmentView];
}

/**
 添加分时线视图
 */
- (void)addTimeLineView
{
    double yc = 0.f;
    NSArray *arr = [YKTimelineOriginalModel getTimeChartModelArrAtYc:&yc];
    
    CGRect rect = CGRectMake(14, 22+50, CGRectGetWidth(self.view.frame)-28, CGRectGetHeight(self.view.frame) - 22 - 14 - 50);
    _timeChartView = [[YKTimeChartView alloc] initWithFrame:rect];
    _timeChartView.yc = yc;
    _timeChartView.timeCharModelArr = arr;
    
    [self.view addSubview:_timeChartView];
    
    [_timeChartView draw];
    
    [self TimeLineViewAddGesture];
}

#pragma mark - 分时线手势响应

- (void)TimeLineViewAddGesture
{
    //添加长按手势
    UILongPressGestureRecognizer *longGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(timeChartLongGestureAction:)];
    longGesture.minimumPressDuration = 0.5f;
    longGesture.numberOfTouchesRequired = 1;
    [_timeChartView addGestureRecognizer:longGesture];
}

- (void)timeChartLongGestureAction:(UILongPressGestureRecognizer *)longGesture
{
    if (longGesture.state == UIGestureRecognizerStateBegan || longGesture.state == UIGestureRecognizerStateChanged)
    {//第一次长按获取 或者 长按然后变化坐标点
        
        //获取坐标
        CGPoint point = [longGesture locationInView:_timeChartView];
        
        float x = 0.f;
        float y = 0.f;
        //判断临界情况
        if (point.x < 0)
        {
            x = 0.f;
        }else if (point.x > CGRectGetWidth(_timeChartView.frame))
        {
            x = CGRectGetWidth(_timeChartView.frame);
        }else
        {
            x = point.x;
        }
        if (point.y < 0)
        {
            y = 0.f;
        }else if (point.y > (CGRectGetHeight(_timeChartView.frame) - 20.f))
        {
            y = CGRectGetHeight(_timeChartView.frame) - 20.f;
        }else
        {
            y = point.y;
        }
        
        //开始绘制十字叉
        [_timeChartView drawTicksWithPoint:CGPointMake(x, y)];
        
    } else
    {//事件取消
        
        //当抬起头后，清理十字叉
        [_timeChartView clearTicks];
    }
}

#pragma mark - k线手势响应

- (void)kLineViewAddGesture
{
    //添加左右拖动手势
    UIPanGestureRecognizer *panG = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureAction:)];
    [_kLineView addGestureRecognizer:panG];
    
    //添加长按手势
    UILongPressGestureRecognizer *longG = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(kLineLongGestureAction:)];
    longG.minimumPressDuration = 0.5f;
    longG.numberOfTouchesRequired = 1;
    [_kLineView addGestureRecognizer:longG];
}

/**
 K线响应长按手势
 
 @param longGesture 手势对象
 */
- (void)kLineLongGestureAction:(UILongPressGestureRecognizer *)longGesture
{
    if (longGesture.state == UIGestureRecognizerStateBegan || longGesture.state == UIGestureRecognizerStateChanged)
    {
        CGPoint point = [longGesture locationInView:_kLineView];
        
        float x = 0.f;
        if (point.x < 0.f)
        {
            x = 0.f;
        }else if (point.x > CGRectGetWidth(_kLineView.frame))
        {
            x = CGRectGetWidth(_kLineView.frame)-1;
        }else
        {
            x = point.x;
        }
        //当长按滑动时，每滑动一次话会重新刷新十字叉
        [_kLineView drawCrossViewWithX:x];
    }else
    {
        //当手指抬起时，及时把十字叉取消掉
        [_kLineView clearCrossViewLayer];
    }
}

/**
 响应拖动手势
 
 @param panGesture 手势对象
 */
- (void)panGestureAction:(UIPanGestureRecognizer *)panGesture
{
    CGPoint point = [panGesture translationInView:_kLineView];
    float offset =  point.x - kLineGlobalOffset;
    if (panGesture.state == UIGestureRecognizerStateChanged && ABS(offset) > 3)
    {
        if (offset > 0)
        {
            if (ABS(offset) > 20)
            {
                [_kLineView dragRightOffsetcount:5];
                
            } else if(ABS(offset) > 6)
            {
                [_kLineView dragRightOffsetcount:2];
                
            } else
            {
                [_kLineView dragRightOffsetcount:1];
            }
        }else
        {
            if (ABS(offset) > 20)
            {
                [_kLineView dragLeftOffsetcount:5];
                
            } else if(ABS(offset) > 6)
            {
                [_kLineView dragLeftOffsetcount:2];
                
            } else
            {
                [_kLineView dragLeftOffsetcount:1];
            }
        }
        kLineGlobalOffset = point.x;
    }
    
    if (panGesture.state == UIGestureRecognizerStateEnded ||
        panGesture.state == UIGestureRecognizerStateCancelled ||
        panGesture.state == UIGestureRecognizerStateFailed)
    {
        kLineGlobalOffset= 0.f;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
