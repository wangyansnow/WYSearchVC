//
//  ViewController.m
//  01-音乐列表分类
//
//  Created by 王俨 on 2018/3/6.
//  Copyright © 2018年 https://github.com/wangyansnow. All rights reserved.
//

#import "ViewController.h"
#import "WYMusicCategoryVC.h"
#import "WYMusicSearchResultVC.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
}

- (IBAction)loadMusicBtnClick:(UIButton *)sender {
    
    [self.navigationController pushViewController:[WYMusicCategoryVC new] animated:YES];
    
}

@end
