//
//  ToolBarView.h
//  DaubTechnology
//
//  Created by 尹星 on 2018/3/13.
//  Copyright © 2018年 尹星. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger ,ToolBarEventType) {
    ToolBarEventCancel = 0,//取消
    ToolBarEventDelete,//删除
    ToolBarEventRevocation,//撤销
    ToolBarEventRecover//下一步R
};

typedef void(^ToolBarEventBlock)(ToolBarEventType eventType);

@interface ToolBarView : UIView

/**
 按钮点击回调block
 */
@property (nonatomic, copy) ToolBarEventBlock         eventBlock;

/**
 用于设置按钮是否可以点击

 @param enable 默认 YES，如果为NO，则按钮无法点击
 */
- (void)cancelBtnSetEnabled:(BOOL)enable;
- (void)deleteBtnSetEnabled:(BOOL)enable;
- (void)revocationBtnSetEnabled:(BOOL)enable;
- (void)recoverBtnSetEnabled:(BOOL)enable;

@end
