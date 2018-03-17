//
//  WYMusicModel.h
//  01-音乐列表分类
//
//  Created by 王俨 on 2018/3/7.
//  Copyright © 2018年 https://github.com/wangyansnow. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WYMusicCell;
@interface WYMusicModel : NSObject

@property (nonatomic, assign) BOOL isSelected;
@property (nonatomic, assign) BOOL isOpen;

@property (nonatomic, copy, readonly) NSString *cellId;
@property (nonatomic, assign) CGFloat cellH;
@property (nonatomic, assign) NSInteger sequence;

@property (nonatomic, weak) WYMusicCell *cell;

@end
