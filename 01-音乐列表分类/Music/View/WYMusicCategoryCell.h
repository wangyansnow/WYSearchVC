//
//  WYMusicCategoryCell.h
//  01-音乐列表分类
//
//  Created by 王俨 on 2018/3/7.
//  Copyright © 2018年 https://github.com/wangyansnow. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *const WYMusicCategoryCellReuseId;

@interface WYMusicCategoryCell : UITableViewCell

@property (nonatomic, strong) NSArray *dataSource;

@end
