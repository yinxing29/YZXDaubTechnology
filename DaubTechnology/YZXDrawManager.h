//
//  YZXDrawManager.h
//  DaubTechnology
//
//  Created by 尹星 on 2018/3/13.
//  Copyright © 2018年 尹星. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger ,YZXDrawLineType){
    YZXDrawDefaultLine = 0,//默认线条
    YZXDrawImageLine//图片线条
};

@interface YZXDrawManager : NSObject

+ (instancetype)defaultManager;

@property (nonatomic, assign) CGFloat       lineWidth;
@property (nonatomic, strong) UIColor       *lineColor;
@property (nonatomic, strong) UIImage       *lineContentsImage;
@property (nonatomic, assign) YZXDrawLineType   lineType;

@end
