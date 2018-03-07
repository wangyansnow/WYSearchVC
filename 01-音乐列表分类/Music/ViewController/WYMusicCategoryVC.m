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
#import "UIImage+Color.h"

#import <objc/message.h>
#import <objc/runtime.h>

#define RGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16)) / 255.0 green:((float)((rgbValue & 0xFF00) >> 8)) / 255.0 blue:((float)(rgbValue & 0xFF)) / 255.0 alpha:1.0]
#define RGBALPHA(rgbValue,a) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16)) / 255.0 green:((float)((rgbValue & 0xFF00) >> 8)) / 255.0 blue:((float)(rgbValue & 0xFF)) / 255.0 alpha:(a)]

CGFloat const kNavBackH = 140; ///< 搜索导航高度

@interface WYMusicCategoryVC ()

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
    
    [self prepareHeaderBackView];
    [self prepareNavItem];
    [self prepareTableView];
    [self prepareSearchVC];
}

- (void)prepareNavItem {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button setImage:[[UIImage imageNamed:@"musiclist_local_icn"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [button setTitle:@"Local" forState:UIControlStateNormal];
    
    button.titleLabel.font = [UIFont boldSystemFontOfSize:14.0];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
    [button addTarget:self action:@selector(localBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    button.frame = CGRectMake(0, 0, 60, 44);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName: [UIFont boldSystemFontOfSize:16]}];
}

- (void)localBtnClick {
    NSLog(@"%s", __func__);
}

- (void)prepareHeaderBackView {
    UIImageView *backView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"musiclist_background_img"]];
    backView.frame = CGRectMake(0, 0, self.view.bounds.size.width, 132);
    backView.backgroundColor = RGB(0xFFD500);
    [self.view addSubview:backView];
}

- (void)prepareSearchVC {
    WYMusicSearchResultVC *resultVC = [WYMusicSearchResultVC new];
    self.searchVC = [[WYCustomSearchVC alloc] initWithSearchResultsController:resultVC];
    [self.searchVC.view addSubview:resultVC.view];
    
    // 1.Use resultVC to update the search results
    self.searchVC.searchResultsUpdater = resultVC;
    
    self.searchVC.searchBar.placeholder = @"Search music/author name.";
    self.searchVC.searchBar.delegate = resultVC;
    self.searchVC.delegate = resultVC;
    
    [self.searchVC.searchBar setBackgroundImage:[UIImage new]];
    self.searchVC.searchBar.searchBarStyle = UISearchBarStyleMinimal;
    self.searchVC.searchBar.searchTextPositionAdjustment = UIOffsetMake(3, 0);
    
    CGFloat offsetX = (self.view.bounds.size.width - 200 - 32) / 2;
    [self.searchVC.searchBar setPositionAdjustment:UIOffsetMake(offsetX, 0) forSearchBarIcon:UISearchBarIconSearch];

    self.searchVC.searchBar.tintColor = [UIColor blackColor]; // 取消按钮和文本框光标颜色
    
    [self.searchVC.searchBar setSearchFieldBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    UIImage *searchImg = [[UIImage imageNamed:@"cheez_search_icn"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [self.searchVC.searchBar setImage:searchImg forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
    
    [self.searchVC.searchBar sizeToFit];
    
    
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
    
    UITextField *searchField = [self.searchVC.searchBar valueForKey:@"_searchField"];
    searchField.font = [UIFont systemFontOfSize:14];
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
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, kNavBackH - 20, self.view.bounds.size.width, self.view.bounds.size.height - kNavBackH + 20)];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:view.bounds style:UITableViewStylePlain];
    self.tableView = tableView;
    tableView.backgroundColor = [UIColor whiteColor];
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:tableView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(18, 18)];
    CAShapeLayer *mask = [CAShapeLayer layer];
    mask.path = path.CGPath;
    view.layer.mask = mask;
    
    [view addSubview:tableView];
    [self.view addSubview:view];
}

#pragma mark - dealloc
- (void)dealloc {
    if (self.observerRef) {
        CFRunLoopRemoveObserver(CFRunLoopGetMain(), self.observerRef, kCFRunLoopDefaultMode);
    }
    
    NSLog(@"♻️ Dealloc %@", NSStringFromClass([self class]));
}

@end
