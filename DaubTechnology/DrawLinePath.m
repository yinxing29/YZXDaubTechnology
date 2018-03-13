//
//  DrawLinePath.m
//  DaubTechnology
//
//  Created by 尹星 on 2018/3/13.
//  Copyright © 2018年 尹星. All rights reserved.
//

#import "DrawLinePath.h"

@implementation DrawLinePath

+ (instancetype)drawLinePathWithStartPoint:(CGPoint)startPoint
{
    DrawLinePath *path = [[self alloc] init];
    path.lineCapStyle  = kCGLineCapRound;
    path.lineJoinStyle = kCGLineCapRound;
    [path moveToPoint:startPoint];
    return path;
}

@end
