//
//  WYMusicCell.m
//  01-音乐列表分类
//
//  Created by 王俨 on 2018/3/7.
//  Copyright © 2018年 https://github.com/wangyansnow. All rights reserved.
//

#import "WYMusicCell.h"

NSString *const WYMusicCellReuseId = @"WYMusicCell";

@interface WYMusicCell()

@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *useBtn;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *detailBottomHCons;
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *imageViews;

@end

@implementation WYMusicCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setModel:(WYMusicModel *)model {
    
    // TODO: 模型赋值
    self.detailBottomHCons.constant = model.isOpen ? 117 : 0;
    self.useBtn.hidden = !model.isOpen;
    
    if (model.cell) {
        [model removeObserver:model.cell forKeyPath:@"isOpen"];
        model.cell = nil;
    }
    
    [model addObserver:self forKeyPath:@"isOpen" options:NSKeyValueObservingOptionNew context:nil];
    model.cell = self;
    
    _model = model;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"isOpen"]) {
        BOOL isOpen = [change[NSKeyValueChangeNewKey] boolValue];
        [self animate:isOpen];
    }
}

- (IBAction)useBtnClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(musicCellClickUseBtn:)]) {
        [self.delegate musicCellClickUseBtn:self];
    }
}

- (void)animate:(BOOL)isOpen {
    NSLog(@"isOpen = %d", isOpen);
    self.detailBottomHCons.constant = isOpen ? 117 : 0;
    self.useBtn.hidden = !isOpen;
    
    [UIView animateWithDuration:0.25 animations:^{
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        
    }];
}

#pragma mark - dealloc
- (void)dealloc {
    if (_model.cell) {
        [_model removeObserver:_model.cell forKeyPath:@"isOpen"];
        _model.cell = nil;
    }
    NSLog(@"♻️ Dealloc %@", NSStringFromClass([self class]));
}

@end
