//
//  UIImage+color.h
//  nightChat
//
//  Created by 王俨 on 15/9/5.
//  Copyright (c) 2015年 nightGroup. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Color)
/// 根据颜色返回一张对应的图片
+ (UIImage *)imageWithColor:(UIColor *)color;
/// 返回一张可拉伸的图片
+ (instancetype)resizeImageNamed:(NSString *)name;

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size isRound:(BOOL)isRound;

@end
