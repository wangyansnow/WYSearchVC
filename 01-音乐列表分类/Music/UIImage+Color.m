//
//  UIImage+color.m
//  nightChat
//
//  Created by 王俨 on 15/9/5.
//  Copyright (c) 2015年 nightGroup. All rights reserved.
//

#import "UIImage+Color.h"

@implementation UIImage (Color)
/// 返回一张颜色图片
+ (UIImage *)imageWithColor:(UIColor *)color {
    return [self imageWithColor:color size:CGSizeMake(100, 100) isRound:NO];
}

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size isRound:(BOOL)isRound {
    CGFloat imageW = size.width;
    CGFloat imageH = size.height;
    // 1.开启基于位图的图形上下文
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(imageW, imageH), NO, 0.0);
    
    if (isRound) {
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, imageW, imageH) cornerRadius:imageH / 2];
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        CGContextAddPath(ctx, path.CGPath);
        CGContextClip(ctx);
    }
    
    // 2.画一个color颜色的矩形框
    [color set];
    UIRectFill(CGRectMake(0, 0, imageW, imageH));
    
    // 3.拿到图片
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    // 4.关闭上下文
    UIGraphicsEndImageContext();
    
    return image;
}

/// 返回一张可以拉伸的图片
+ (instancetype)resizeImageNamed:(NSString *)name {
    UIImage *normal = [UIImage imageNamed:name];
    CGFloat width = normal.size.width * 0.5;
    CGFloat height = normal.size.height * 0.5;
    normal = [normal resizableImageWithCapInsets:UIEdgeInsetsMake(height, width, height, width) resizingMode:UIImageResizingModeTile];
    return normal;
}
@end
