//
//  WYMusicSearchResultVC.m
//  01-音乐列表分类
//
//  Created by 王俨 on 2018/3/6.
//  Copyright © 2018年 https://github.com/wangyansnow. All rights reserved.
//

#import "WYMusicSearchResultVC.h"

@interface WYMusicSearchResultVC ()

@end

@implementation WYMusicSearchResultVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
}

- (void)setupUI {
    self.view.backgroundColor = [UIColor brownColor];
}

#pragma mark - UISearchResultsUpdating
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    NSLog(@"update search result = %@", searchController.searchBar.text);
    
}

#pragma mark - UISearchBarDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSLog(@"%s", __func__);
}

#pragma mark - UISearchControllerDelegate
- (void)willPresentSearchController:(UISearchController *)searchController {
    
    searchController.view.alpha = 1.0;
    [searchController.searchBar setPositionAdjustment:UIOffsetMake(0, 0) forSearchBarIcon:UISearchBarIconSearch];
}

- (void)willDismissSearchController:(UISearchController *)searchController {
    
    CGFloat offsetX = (self.view.bounds.size.width - 200 - 32) / 2;
    [searchController.searchBar setPositionAdjustment:UIOffsetMake(offsetX, 0) forSearchBarIcon:UISearchBarIconSearch];
    
    [UIView animateWithDuration:0.25 animations:^{
        searchController.view.alpha = 0;
    }];
}

@end
