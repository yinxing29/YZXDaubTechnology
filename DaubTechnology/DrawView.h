//
//  DrawView.h
//  DaubTechnology
//
//  Created by 尹星 on 2018/3/13.
//  Copyright © 2018年 尹星. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DrawView : UIView

/**
 线条数组
 */
@property (nonatomic, strong) NSMutableArray       *drawLines;

/**
 撤销的线条数组
 */
@property (nonatomic, strong) NSMutableArray       *revocationLines;

/**
 清空线条
 */
- (void)deleteLines;

/**
 撤销线条
 */
- (void)revocationLine;

/**
 回复线条
 */
- (void)recoverLine;

@end
