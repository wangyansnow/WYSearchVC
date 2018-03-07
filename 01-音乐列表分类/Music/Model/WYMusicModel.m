//
//  WYMusicModel.m
//  01-音乐列表分类
//
//  Created by 王俨 on 2018/3/7.
//  Copyright © 2018年 https://github.com/wangyansnow. All rights reserved.
//

#import "WYMusicModel.h"
#import "WYMusicSelectedCell.h"
#import "WYMusicCell.h"

@implementation WYMusicModel

- (NSString *)cellId {
    if (self.isSelected) {
        return WYMusicSelectedCellReuseId;
    } else {
        return WYMusicCellReuseId;
    }
}

- (CGFloat)cellH {
    if (self.isSelected) return 68;
    if (self.isOpen) return 203;
    return 76;
}

@end
