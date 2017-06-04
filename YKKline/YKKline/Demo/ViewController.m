//
//  ViewController.m
//  YKKline
//
//  Created by nethanhan on 2017/6/4.
//  Copyright © 2017年 nethanhan. All rights reserved.
//

#import "ViewController.h"
#import "YKKlineViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    YKKlineViewController *kLineVc = [[YKKlineViewController alloc] init];
    kLineVc.view.frame = self.view.bounds;
    [self addChildViewController:kLineVc];
    [self.view addSubview:kLineVc.view];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
