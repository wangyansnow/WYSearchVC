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
    
}

- (IBAction)loadMusicBtnClick:(UIButton *)sender {
    WYMusicCategoryVC *musicVC = [WYMusicCategoryVC new];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:musicVC];
    
    [self presentViewController:nav animated:YES completion:nil];
//    [self.navigationController pushViewController:[WYMusicCategoryVC new] animated:YES];
    
}

@end
