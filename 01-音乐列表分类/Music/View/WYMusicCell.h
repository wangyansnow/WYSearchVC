//
//  WYMusicCell.h
//  01-音乐列表分类
//
//  Created by 王俨 on 2018/3/7.
//  Copyright © 2018年 https://github.com/wangyansnow. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WYMusicModel.h"

extern NSString *const WYMusicCellReuseId;

@class WYMusicCell;
@protocol WYMusicCellDelegate<NSObject>

@required

- (void)musicCellClickUseBtn:(WYMusicCell *)cell;

@end

@interface WYMusicCell : UITableViewCell

@property (nonatomic, strong) WYMusicModel *model;
@property (nonatomic, weak) id<WYMusicCellDelegate> delegate;

- (void)animate:(BOOL)isOpen;

@end
