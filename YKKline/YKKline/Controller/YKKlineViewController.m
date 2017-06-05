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
#import "YKOriginalModel.h"

@interface YKKlineViewController ()

@property (nonatomic, strong) YKKlineView *kLineView;

@end

@implementation YKKlineViewController

static float kLineGlobalOffset = 0.f;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    YKKlineView *kLineView = [[YKKlineView alloc] initWithFrame:CGRectMake(14,22,CGRectGetWidth(self.view.frame)-28,CGRectGetHeight(self.view.frame) - 22 - 14)];
    kLineView.backgroundColor = [UIColor kLineBackGroundColor];
    _kLineView = kLineView;
    
    [self.view addSubview:_kLineView];
    
    _kLineView.kLineModelArr = [YKOriginalModel getKLineModelArr];
    [self kLineViewAddGesture];
    
    [_kLineView drawWithMainType:KLineMainOHLC];
    
}

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
