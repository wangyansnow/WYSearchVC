//
//  WYMusicSelectedCell.m
//  01-音乐列表分类
//
//  Created by 王俨 on 2018/3/7.
//  Copyright © 2018年 https://github.com/wangyansnow. All rights reserved.
//

#import "WYMusicSelectedCell.h"

NSString *const WYMusicSelectedCellReuseId = @"WYMusicSelectedCell";

@interface WYMusicSelectedCell()

@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;


@end

@implementation WYMusicSelectedCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (IBAction)cancelBtnClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(musicSelectedCellClickCancelBtn:)]) {
        [self.delegate musicSelectedCellClickCancelBtn:self];
    }
}

@end
