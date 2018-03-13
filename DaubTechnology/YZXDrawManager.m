//
//  YZXDrawManager.m
//  DaubTechnology
//
//  Created by 尹星 on 2018/3/13.
//  Copyright © 2018年 尹星. All rights reserved.
//

#import "YZXDrawManager.h"

@implementation YZXDrawManager

+ (instancetype)defaultManager
{
    static YZXDrawManager *manager = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        manager = [[self alloc] init];
        manager.lineWidth = 2.0;
        manager.lineColor = [UIColor blackColor];
        manager.lineType = YZXDrawDefaultLine;
        manager.lineContentsImage = [UIImage imageNamed:@"delete_draft"];
    });
    return manager;
}

#pragma mark - setter
- (void)setLineWidth:(CGFloat)lineWidth
{
    _lineWidth = lineWidth;
}

- (void)setLineColor:(UIColor *)lineColor
{
    _lineColor = lineColor;
}

- (void)setLineContentsImage:(UIImage *)lineContentsImage
{
    _lineContentsImage = lineContentsImage;
}

#pragma mark - ------------------------------------------------------------------------------------


@end
