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
    [self removeObserver:_model];
    [self addObserver:model];
    
    // TODO: 模型赋值
    self.detailBottomHCons.constant = model.isOpen ? 117 : 0;
    self.useBtn.hidden = !model.isOpen;
    model.cell = self;
    
    _model = model;
}

- (IBAction)useBtnClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(musicCellClickUseBtn:)]) {
        [self.delegate musicCellClickUseBtn:self];
    }
}


#pragma mark - Observer
- (void)addObserver:(WYMusicModel *)model {
    if (!model) return;
    
    [model addObserver:self forKeyPath:@"isOpen" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)removeObserver:(WYMusicModel *)model {
    if (!model) return;
    
    [model removeObserver:self forKeyPath:@"isOpen"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {

    if ([object isEqual:self.model] && [keyPath isEqualToString:@"isOpen"]) {

        BOOL isOpen = [change[NSKeyValueChangeNewKey] boolValue];
        
        [self animate:isOpen];
    } else {
        NSLog(@"not this model");
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
    [self removeObserver:self.model];
    NSLog(@"♻️ Dealloc %@", NSStringFromClass([self class]));
}

@end
