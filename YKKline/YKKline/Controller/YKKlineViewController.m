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

@interface YKKlineViewController ()

@end

@implementation YKKlineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    YKKlineView *kLineView = [[YKKlineView alloc] initWithFrame:CGRectMake(14,22,CGRectGetWidth(self.view.frame)-28,CGRectGetHeight(self.view.frame) - 22 - 14)];
    kLineView.backgroundColor = [UIColor kLineBackGroundColor];
    
    [self.view addSubview:kLineView];
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
