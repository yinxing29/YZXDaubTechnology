//
//  DrawView.m
//  DaubTechnology
//
//  Created by 尹星 on 2018/3/13.
//  Copyright © 2018年 尹星. All rights reserved.
//

#import "DrawView.h"
#import "DrawLinePath.h"
#import "YZXDrawManager.h"

@interface DrawView ()

@property (nonatomic, strong) DrawLinePath       *path;
@property (nonatomic, strong) CAShapeLayer       *lineLayer;
@property (nonatomic, strong) NSMutableArray     *imageLines;

@property (nonatomic, assign) CGPoint            lastMovePoint;

@property (nonatomic, strong) YZXDrawManager       *manager;

@end

@implementation DrawView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor grayColor];
        self.layer.masksToBounds = YES;
        [self p_createView];
    }
    return self;
}

- (void)p_createView
{
    
}

#pragma mark - touches
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    CGPoint startPoint = [self acquireTouchPointWithTouches:touches];
    //如果是图片样式，每个点添加一个contents为图片的layer，然后将其放入一个数组
    if (self.manager.lineType == YZXDrawImageLine) {
        self.lastMovePoint = startPoint;
        return;
    }
    
    if (event.allTouches.count == 1) {
        DrawLinePath *path = [DrawLinePath drawLinePathWithStartPoint:startPoint];
        self.path = path;
        
        CAShapeLayer *lineLayer   = [CAShapeLayer layer];
        lineLayer.path            = path.CGPath;
        lineLayer.backgroundColor = [UIColor clearColor].CGColor;
        lineLayer.fillColor       = [UIColor clearColor].CGColor;
        lineLayer.strokeColor     = self.manager.lineColor.CGColor;
        lineLayer.lineCap         = kCALineCapRound;
        lineLayer.lineJoin        = kCALineJoinRound;
        lineLayer.lineWidth       = self.manager.lineWidth;
        
        [self.layer addSublayer:lineLayer];
        self.lineLayer = lineLayer;
        //使用valueForKey方法获取对应的可变数组才能都监听到数组变化
        [[self mutableArrayValueForKey:@"revocationLines"] removeAllObjects];
        [[self mutableArrayValueForKey:@"drawLines"] addObject:self.lineLayer];
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    CGPoint movePoint = [self acquireTouchPointWithTouches:touches];
    
    if (self.manager.lineType == YZXDrawImageLine) {
        //判断两点之间的距离和图片对角线的关系，防止图片太密集
        if (![self isDrawImageLineWithLastPoint:self.lastMovePoint currentPoint:movePoint andImageSize:self.manager.lineContentsImage.size]) {
            return;
        }
        
        [self addImageWithLineContentsWithPosition:movePoint
                                     lastMovePoint:self.lastMovePoint];
        self.lastMovePoint = movePoint;
        return;
    }
    
    [self.path addLineToPoint:movePoint];
    self.lineLayer.path = self.path.CGPath;
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (self.manager.lineType == YZXDrawImageLine) {
        if (self.imageLines.count > 0) {
            [[self mutableArrayValueForKey:@"revocationLines"] removeAllObjects];
        }
        [[self mutableArrayValueForKey:@"drawLines"] addObject:[self.imageLines copy]];
        [self.imageLines removeAllObjects];
    }
}

#pragma mark - ------------------------------------------------------------------------------------

//判断两点之间的距离和图片对角线的大小
- (BOOL)isDrawImageLineWithLastPoint:(CGPoint)lastPoint
                        currentPoint:(CGPoint)currentPoint
                        andImageSize:(CGSize)imageSize
{
    CGFloat distanceBetweenTwoPoint = sqrt(pow(fabs(currentPoint.x - lastPoint.x), 2) + pow(fabs(currentPoint.y - lastPoint.y), 2));
    CGFloat imageDiagonalLength = sqrt(pow(imageSize.width, 2) + pow(imageSize.height, 2));
    if (distanceBetweenTwoPoint >= imageDiagonalLength / 2.0) {
        return YES;
    }
    return NO;
}

//添加触摸点为中心的图片
- (void)addImageWithLineContentsWithPosition:(CGPoint)position
                               lastMovePoint:(CGPoint)lastMovePoint
{
    UIImage *image            = self.manager.lineContentsImage;
    CAShapeLayer *lineLayer   = [CAShapeLayer layer];
    lineLayer.bounds          = CGRectMake(0, 0, image.size.width, image.size.height);
    lineLayer.position        = position;
    lineLayer.contents        = (__bridge id)image.CGImage;
    lineLayer.affineTransform = CGAffineTransformRotate(CGAffineTransformIdentity, angleBetweenPoints(lastMovePoint, position));
    [self.layer addSublayer:lineLayer];
    [self.imageLines addObject:lineLayer];
}

//计算两点之间与水平线之间的夹角
CGFloat angleBetweenPoints(CGPoint first, CGPoint second) {
    CGFloat height = second.y - first.y;
    CGFloat width = second.x - first.x;
    CGFloat rads = atan(fabs(width / height));
    
    if (height <= 0 && width <= 0) {//以起始点为原点滑动方向指向第二象限
        rads = M_PI - rads;
    }else if (height <= 0 && width > 0) {//以起始点为原点滑动方向指向第一象限
        rads = M_PI + rads;
    }else if (height > 0 && width <= 0) {//以起始点为原点滑动方向指向第三象限
        rads = rads;
    }else {//以起始点为原点滑动方向指向第四象限
        rads = - rads;
    }
    return rads;
}

//获取触摸点
- (CGPoint)acquireTouchPointWithTouches:(NSSet <UITouch *> *)touches
{
    UITouch *touch = [touches anyObject];
    return [touch locationInView:self];
}

- (void)deleteLines
{
    if (self.drawLines.count == 0) {
        return;
    }
    
    switch (self.manager.lineType) {
        case YZXDrawDefaultLine:
        {
            [self.drawLines makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
        }
            break;
            case YZXDrawImageLine:
        {
            for (NSArray *array in self.drawLines) {
                [array makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
            }
        }
            break;
    }
    
    [[self mutableArrayValueForKey:@"drawLines"] removeAllObjects];
    [[self mutableArrayValueForKey:@"revocationLines"] removeAllObjects];
    
}

- (void)revocationLine
{
    if (self.drawLines.count == 0) {
        return;
    }
    
    [[self mutableArrayValueForKey:@"revocationLines"] addObject:self.drawLines.lastObject];
    
    switch (self.manager.lineType) {
        case YZXDrawDefaultLine:
        {
            [self.drawLines.lastObject removeFromSuperlayer];
        }
            break;
        case YZXDrawImageLine:
        {
            [self.drawLines.lastObject makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
        }
            break;
    }
    
    [[self mutableArrayValueForKey:@"drawLines"] removeLastObject];
}

- (void)recoverLine
{
    if (self.revocationLines.count == 0) {
        return;
    }
    
    [[self mutableArrayValueForKey:@"drawLines"] addObject:self.revocationLines.lastObject];
    [[self mutableArrayValueForKey:@"revocationLines"] removeLastObject];
    
    switch (self.manager.lineType) {
        case YZXDrawDefaultLine:
        {
            [self.layer addSublayer:self.drawLines.lastObject];
        }
            break;
        case YZXDrawImageLine:
        {
            for (CAShapeLayer *layer in self.drawLines.lastObject) {
                [self.layer addSublayer:layer];
            }
        }
            break;
    }
}

#pragma mark - 懒加载
- (NSMutableArray *)drawLines
{
    if (!_drawLines) {
        _drawLines = [NSMutableArray array];
    }
    return _drawLines;
}

- (NSMutableArray *)revocationLines
{
    if (!_revocationLines) {
        _revocationLines = [NSMutableArray array];
    }
    return _revocationLines;
}

- (NSMutableArray *)imageLines
{
    if (!_imageLines) {
        _imageLines = [NSMutableArray array];
    }
    return _imageLines;
}

- (YZXDrawManager *)manager
{
    if (!_manager) {
        _manager = [YZXDrawManager defaultManager];
    }
    return _manager;
}

#pragma mark - ------------------------------------------------------------------------------------

@end
