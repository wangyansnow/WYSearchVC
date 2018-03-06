//
//  WYMusicCategoryVC.m
//  01-音乐列表分类
//
//  Created by 王俨 on 2018/3/6.
//  Copyright © 2018年 https://github.com/wangyansnow. All rights reserved.
//

#import "WYMusicCategoryVC.h"
#import "WYMusicSearchResultVC.h"
#import "WYCustomSearchVC.h"
#import <objc/message.h>
#import "UIImage+Color.h"

@interface WYMusicCategoryVC ()<UISearchResultsUpdating, UISearchBarDelegate, UISearchControllerDelegate, UIViewControllerTransitioningDelegate>

@property (nonatomic, strong) WYCustomSearchVC *searchVC;
@property (nonatomic, weak) UITableView *tableView;

@property (nonatomic, assign) CFRunLoopObserverRef observerRef;

@end

@implementation WYMusicCategoryVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
}

- (void)setupUI {
    self.view.backgroundColor = [UIColor lightGrayColor];
    self.title = @"Music";
    
    [self prepareTableView];
    [self prepareSearchVC];
    [self prepareHeaderBackView];
}

- (void)prepareHeaderBackView {
    UIImageView *backView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"musiclist_background_img"]];
    backView.frame = CGRectMake(0, 0, self.view.bounds.size.width, 132);
    [self.view addSubview:backView];
}

- (void)prepareSearchVC {
    WYMusicSearchResultVC *resultVC = [WYMusicSearchResultVC new];
    self.searchVC = [[WYCustomSearchVC alloc] initWithSearchResultsController:resultVC];
    [self.searchVC.view addSubview:resultVC.view];
    
    // 1.Use current view controller to update the search results
    self.searchVC.searchResultsUpdater = self;
    
    self.searchVC.searchBar.placeholder = @"Search music/author name.";
    self.searchVC.searchBar.delegate = self;
    self.searchVC.delegate = self;
    
    [self.searchVC.searchBar setBackgroundImage:[UIImage new]];
    self.searchVC.searchBar.searchBarStyle = UISearchBarStyleMinimal;
    self.searchVC.searchBar.searchTextPositionAdjustment = UIOffsetMake(3, 0);
    [self.searchVC.searchBar setPositionAdjustment:UIOffsetMake(50, 0) forSearchBarIcon:UISearchBarIconSearch];
    
    UITextField *searchField = [self.searchVC.searchBar valueForKey:@"_searchField"];
    searchField.font = [UIFont systemFontOfSize:17];
    
    UIButton *cancelButton = [self.searchVC.searchBar valueForKey:@"_cancelButton"];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        searchField.textColor = [UIColor redColor];
        [searchField setValue:[UIColor redColor]forKeyPath:@"_placeholderLabel.textColor"];
        [cancelButton setTitle:@"Close" forState:UIControlStateNormal];
    });

    self.searchVC.searchBar.tintColor = [UIColor yellowColor]; // 取消按钮和文本框光标颜色
    
    [self.searchVC.searchBar setSearchFieldBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    
    [self.searchVC.searchBar sizeToFit];

    
//    self.searchVC.searchBar setImage:<#(nullable UIImage *)#> forSearchBarIcon:<#(UISearchBarIcon)#> state:<#(UIControlState)#>
    
    
    // 2.Install the search bar
    if ([self.navigationItem respondsToSelector:@selector(setSearchController:)]) {
        // 2.1 For iOS 11 and later, wo place the search bar in the navigation bar
        self.navigationItem.searchController = self.searchVC;
        
        // 2.2 Set the search bar visible all the time
        self.navigationItem.hidesSearchBarWhenScrolling = NO;
        
        
        // 2.3 Hide line view
        __weak typeof(self) weakSelf = self;
        self.observerRef = CFRunLoopObserverCreateWithHandler(kCFAllocatorDefault, kCFRunLoopAllActivities, true, 0, ^(CFRunLoopObserverRef observer, CFRunLoopActivity activity) {
            
            NSLog(@"kCFRunLoopBeforeWaiting");
            BOOL targetView = [weakSelf barGroudView:weakSelf.navigationController.view];
            if (targetView) {
                CFRunLoopRemoveObserver(CFRunLoopGetMain(), observer, kCFRunLoopDefaultMode);
            }
        });
        CFRunLoopAddObserver(CFRunLoopGetMain(), self.observerRef, kCFRunLoopDefaultMode);
        
    } else {
        self.tableView.tableHeaderView = self.searchVC.searchBar;
    }
    
    // 3.It is usually good to set the presentation context
    self.definesPresentationContext = YES;
    
    searchField.textColor = [UIColor redColor];
    [searchField setValue:[UIColor redColor]forKeyPath:@"_placeholderLabel.textColor"];
}

- (BOOL)barGroudView:(UIView *)targetView {
    for (UIView *sView in targetView.subviews) {
        if ([sView isKindOfClass:NSClassFromString(@"_UINavigationControllerPaletteClippingView")]) {
            if (sView.subviews.count > 0 && sView.subviews[0].subviews.count > 0 && sView.subviews[0].subviews[0].subviews.count > 1) {
                sView.subviews[0].subviews[0].subviews[1].hidden = YES;
                return YES;
            }
        }
    }
    
    return NO;
}

- (void)prepareTableView {
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView = tableView;
    
    [self.view addSubview:tableView];
}

#pragma mark - UISearchResultsUpdating
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    NSLog(@"update search result = %@", searchController.searchBar.text);
}

#pragma mark - UISearchBarDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSLog(@"searchBtn click: %d", self.searchVC.isActive);

}

#pragma mark - UISearchControllerDelegate
- (void)willPresentSearchController:(UISearchController *)searchController {
    
    searchController.view.alpha = 1.0;
    [searchController.searchBar setPositionAdjustment:UIOffsetMake(0, 0) forSearchBarIcon:UISearchBarIconSearch];
}

- (void)willDismissSearchController:(UISearchController *)searchController {
    
    [searchController.searchBar setPositionAdjustment:UIOffsetMake(50, 0) forSearchBarIcon:UISearchBarIconSearch];
    
    [UIView animateWithDuration:0.25 animations:^{
        searchController.view.alpha = 0;
    }];
}

#pragma mark - private
/// 只有在将要显示searchVC的时候才能拿到值
- (UIButton *)getSearchCancelBtn {
    if (self.searchVC.searchBar.subviews.count == 0) {
        return nil;
    }
    
    NSArray *subViews = self.searchVC.searchBar.subviews[0].subviews;
    for (UIView *view in subViews) {
        if([view isKindOfClass:NSClassFromString(@"UINavigationButton")]) {
            return (UIButton *)view;
        }
    }

    return nil;
}

#pragma mark - dealloc
- (void)dealloc {
    if (self.observerRef) {
        CFRunLoopRemoveObserver(CFRunLoopGetMain(), self.observerRef, kCFRunLoopDefaultMode);
    }
    
    NSLog(@"♻️ Dealloc %@", NSStringFromClass([self class]));
}

@end
