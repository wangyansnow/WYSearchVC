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
#import "WYMusicCategoryCell.h"
#import "WYMusicCell.h"
#import "WYMusicModel.h"
#import "WYMusicSelectedCell.h"

#define RGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16)) / 255.0 green:((float)((rgbValue & 0xFF00) >> 8)) / 255.0 blue:((float)(rgbValue & 0xFF)) / 255.0 alpha:1.0]
#define RGBALPHA(rgbValue,a) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16)) / 255.0 green:((float)((rgbValue & 0xFF00) >> 8)) / 255.0 blue:((float)(rgbValue & 0xFF)) / 255.0 alpha:(a)]

#define kNavBackH (self.view.bounds.size.height == 812 ? 164 : 140)
//CGFloat const kNavBackH = 140; ///< 搜索导航高度

@interface WYMusicCategoryVC ()<UITableViewDataSource, UITableViewDelegate, WYMusicCellDelegate, WYMusicSelectedCellDelegate>

@property (nonatomic, strong) WYCustomSearchVC *searchVC;
@property (nonatomic, weak) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray<WYMusicModel *> *dataSource;
@property (nonatomic, strong) WYMusicModel *currentModel;

@property (nonatomic, assign) CFRunLoopObserverRef observerRef;

@end

@implementation WYMusicCategoryVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    for (int i = 0; i< 20; i++){
        [self.dataSource addObject:[WYMusicModel new]];
    }
    
    [self setupUI];
    
    
}

- (void)setupUI {
    self.view.backgroundColor = [UIColor lightGrayColor];
    self.title = @"Music";
    
    [self prepareHeaderBackView];
    [self prepareTableView];
    [self prepareSearchVC];
    [self prepareNavItem];
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
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleDone target:self action:@selector(backItemClick)];
}

- (void)backItemClick {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)localBtnClick {
    NSLog(@"%s", __func__);
}

- (void)prepareHeaderBackView {
    UIImageView *backView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"musiclist_background_img"]];
    CGFloat h = self.view.bounds.size.height == 812 ? 156 : 132;
    backView.frame = CGRectMake(0, 0, self.view.bounds.size.width, h);
    backView.backgroundColor = RGB(0xFFD500);
    [self.view addSubview:backView];
}

- (void)prepareSearchVC {
    WYMusicSearchResultVC *resultVC = [WYMusicSearchResultVC new];
    self.searchVC = [[WYCustomSearchVC alloc] initWithSearchResultsController:resultVC];
    [self.searchVC.view addSubview:resultVC.view];
    
    // 1.Use resultVC to update the search results
    self.searchVC.searchResultsUpdater = resultVC;
    self.searchVC.searchBar.delegate = resultVC;
    self.searchVC.delegate = resultVC;
    
    // 1.设置placeholder
    self.searchVC.searchBar.placeholder = @"Search music/author name.";
    
    // 2.设置searchBar的背景透明
    [self.searchVC.searchBar setBackgroundImage:[UIImage new]];
    self.searchVC.searchBar.searchBarStyle = UISearchBarStyleMinimal;
    
    // 3.设置搜索框文字的偏移
    self.searchVC.searchBar.searchTextPositionAdjustment = UIOffsetMake(3, 0);
    
    // 4.设置搜索框图标的偏移
    CGFloat offsetX = (self.view.bounds.size.width - 200 - 32) / 2;
    [self.searchVC.searchBar setPositionAdjustment:UIOffsetMake(offsetX, 0) forSearchBarIcon:UISearchBarIconSearch];

    // 5.取消按钮和文本框光标颜色
    self.searchVC.searchBar.tintColor = [UIColor blackColor];
    
    // 6.设置搜索文本框背景图片 [圆形的文本框只需要设置一张圆角图片就可以了]
    [self.searchVC.searchBar setSearchFieldBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor] size:CGSizeMake(self.view.bounds.size.width - 32, 36) isRound:YES] forState:UIControlStateNormal];
    // 7.设置搜索按钮
    UIImage *searchImg = [[UIImage imageNamed:@"cheez_search_icn"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [self.searchVC.searchBar setImage:searchImg forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
    
    [self.searchVC.searchBar sizeToFit];
    
    // 2.Install the search bar
    if ([self.navigationItem respondsToSelector:@selector(setSearchController:)]) {
        // 2.1 For iOS 11 and later, wo place the search bar in the navigation bar
        if (@available(iOS 11.0, *)) {
            self.navigationItem.searchController = self.searchVC;
            // 2.2 Set the search bar visible all the time
            self.navigationItem.hidesSearchBarWhenScrolling = NO;
        }

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
        UIView *v = [[UIView alloc] initWithFrame:self.searchVC.searchBar.bounds];
        v.frame = CGRectMake(v.frame.origin.x, 64, v.frame.size.width, v.frame.size.height);
        [v addSubview:self.searchVC.searchBar];
        
        [self.view addSubview:v];
    }
    
    // 3.It is usually good to set the presentation context
    self.definesPresentationContext = YES;
    
    // 8.拿到搜索文本框
    UITextField *searchField = [self.searchVC.searchBar valueForKey:@"_searchField"];
    // 9.设置取消按钮文字
    [self.searchVC.searchBar setValue:@"Custom Cancel" forKey:@"_cancelButtonText"];
    
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
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    tableView.backgroundColor = [UIColor whiteColor];
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:tableView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(18, 18)];
    CAShapeLayer *mask = [CAShapeLayer layer];
    mask.path = path.CGPath;
    view.layer.mask = mask;
    
    [view addSubview:tableView];
    [self.view addSubview:view];
    [self registerCell];
}

- (void)registerCell {
    [self.tableView registerClass:[WYMusicCategoryCell class] forCellReuseIdentifier:WYMusicCategoryCellReuseId];
    [self.tableView registerNib:[UINib nibWithNibName:WYMusicCellReuseId bundle:nil] forCellReuseIdentifier:WYMusicCellReuseId];
    [self.tableView registerNib:[UINib nibWithNibName:WYMusicSelectedCellReuseId bundle:nil] forCellReuseIdentifier:WYMusicSelectedCellReuseId];
}

#pragma mark - UITableViewDataSource && UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        WYMusicCategoryCell *cell = [tableView dequeueReusableCellWithIdentifier:WYMusicCategoryCellReuseId];
        return cell;
    }
    
    WYMusicModel *model = self.dataSource[indexPath.row];
    model.sequence = indexPath.row;
    WYMusicCell *cell = [tableView dequeueReusableCellWithIdentifier:model.cellId];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = model;
    cell.delegate = self;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 166;
    }
    
    return self.dataSource[indexPath.row].cellH;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) return;

    WYMusicModel *model = self.dataSource[indexPath.row];
    
    if (model.isSelected) { // 点击了已经选中的cell
        NSLog(@"handle selected cell");
        return;
    }
    
    if (indexPath.row == self.dataSource.count - 1) { // 最后一行
        self.currentModel = model;
        return;
    }
    
    // 刷新下一行
    self.currentModel = model;
}

- (void)setCurrentModel:(WYMusicModel *)currentModel {
    // 选中的是同一个
    if (_currentModel != nil && [currentModel isEqual:_currentModel]) { // 取消选中
        currentModel.isOpen = NO;
        [self reloadIndex:currentModel.sequence canScroll:YES];
        _currentModel = nil;
        return;
    }
    
    if (_currentModel) { // 取消上一个选中
        _currentModel.isOpen = NO;
        NSInteger sequence = MAX(_currentModel.sequence, currentModel.sequence);
        [self reloadIndex:sequence canScroll:NO];
    }
    
    currentModel.isOpen = YES;
    [self reloadIndex:currentModel.sequence canScroll:YES];
    
    _currentModel = currentModel;
}

- (void)reloadIndex:(NSInteger)index canScroll:(BOOL)canScroll {
    
    if (index == self.dataSource.count - 1) { //最后一行
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index - 1 inSection:0];
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        if (canScroll) {
            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        }
        return;
    }
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow: 0 inSection:0];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}


#pragma mark - WYMusicCellDelegate
- (void)musicCellClickUseBtn:(WYMusicCell *)cell {
    cell.model.isSelected = YES;
    _currentModel = nil;
    [self.tableView reloadData];
    
    [self.navigationController pushViewController:[UIViewController new] animated:YES];
}

#pragma mark - WYMusicSelectedCellDelegate
- (void)musicSelectedCellClickCancelBtn:(WYMusicSelectedCell *)cell {
    cell.model.isSelected = NO;
    cell.model.isOpen = NO;
    
    _currentModel = nil;
    [self.tableView reloadData];
}

#pragma mark - 懒加载
- (NSMutableArray<WYMusicModel *> *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray arrayWithCapacity:21];
        [_dataSource addObject:[WYMusicModel new]];
    }
    return _dataSource;
}

#pragma mark - dealloc
- (void)dealloc {
    if (self.observerRef) {
        CFRunLoopRemoveObserver(CFRunLoopGetMain(), self.observerRef, kCFRunLoopDefaultMode);
    }
    
    NSLog(@"♻️ Dealloc %@", NSStringFromClass([self class]));
}

@end
