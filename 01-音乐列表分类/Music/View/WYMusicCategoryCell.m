//
//  WYMusicCategoryCell.m
//  01-音乐列表分类
//
//  Created by 王俨 on 2018/3/7.
//  Copyright © 2018年 https://github.com/wangyansnow. All rights reserved.
//

#import "WYMusicCategoryCell.h"
#import "WYCategoryCell.h"

NSString *const WYMusicCategoryCellReuseId = @"WYMusicCategoryCell";

@interface WYMusicCategoryCell()<UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, weak) UICollectionView *collectionView;

@end

@implementation WYMusicCategoryCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self setupUI];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    CGFloat w = [UIScreen mainScreen].bounds.size.width * 0.25;
    CGFloat h = 79;
    layout.itemSize = CGSizeMake(w, h);
    
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    
    UICollectionView *cv = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 158) collectionViewLayout:layout];
    cv.backgroundColor = [UIColor whiteColor];
    cv.delegate = self;
    cv.dataSource = self;
    [cv registerNib:[UINib nibWithNibName:WYCategoryCellReuseId bundle:nil] forCellWithReuseIdentifier:WYCategoryCellReuseId];
    
    self.collectionView = cv;
    [self addSubview:cv];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.separatorInset = UIEdgeInsetsMake(0, 375, 0, 0);
}

#pragma mark - UICollectionViewDataSource && UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 8;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    WYCategoryCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:WYCategoryCellReuseId forIndexPath:indexPath];
    
    return cell;
}

@end
