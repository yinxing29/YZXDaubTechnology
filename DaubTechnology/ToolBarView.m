//
//  ToolBarView.m
//  DaubTechnology
//
//  Created by 尹星 on 2018/3/13.
//  Copyright © 2018年 尹星. All rights reserved.
//

#import "ToolBarView.h"

@interface ToolBarView ()

@property (nonatomic, copy) NSArray         *canEventBtnImagesName;
@property (nonatomic, copy) NSArray         *notEventBtnImagesName;

@property (nonatomic, strong) UIButton       *cancelBtn;
@property (nonatomic, strong) UIButton       *deleteBtn;
@property (nonatomic, strong) UIButton       *revocationBtn;
@property (nonatomic, strong) UIButton       *recoverBtn;

@end

@implementation ToolBarView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blueColor];
        [self p_createView];
    }
    return self;
}

- (void)p_createView
{
    for (int i = 0; i<4; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(i * self.frame.size.width / 4.0, 0, self.frame.size.width / 4.0, self.frame.size.height);
        button.tag = 200 + i;
        [button setImage:[UIImage imageNamed:self.canEventBtnImagesName[i]] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:self.canEventBtnImagesName[i]] forState:UIControlStateSelected];
        [button setImage:[UIImage imageNamed:self.notEventBtnImagesName[i]] forState:UIControlStateDisabled];
        [button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
    }
    
    self.cancelBtn   = (UIButton *)[self viewWithTag:200];
    self.deleteBtn   = (UIButton *)[self viewWithTag:201];
    self.revocationBtn = (UIButton *)[self viewWithTag:202];
    self.recoverBtn = (UIButton *)[self viewWithTag:203];
    
    [self.deleteBtn setEnabled:NO];
    [self.revocationBtn setEnabled:NO];
    [self.recoverBtn setEnabled:NO];
}

- (void)buttonPressed:(UIButton *)sender
{
    switch (sender.tag) {
        case 200:
        {
            if (self.eventBlock) {
                self.eventBlock(ToolBarEventCancel);
            }
        }
            break;
        case 201:
        {
            if (self.eventBlock) {
                self.eventBlock(ToolBarEventDelete);
            }
        }
            break;
        case 202:
        {
            if (self.eventBlock) {
                self.eventBlock(ToolBarEventRevocation);
            }
        }
            break;
        case 203:
        {
            if (self.eventBlock) {
                self.eventBlock(ToolBarEventRecover);
            }
        }
            break;
    }
}

- (void)cancelBtnSetEnabled:(BOOL)enable
{
    [self.cancelBtn setEnabled:enable];
}

- (void)deleteBtnSetEnabled:(BOOL)enable
{
    [self.deleteBtn setEnabled:enable];
}

- (void)revocationBtnSetEnabled:(BOOL)enable
{
    [self.revocationBtn setEnabled:enable];
}

- (void)recoverBtnSetEnabled:(BOOL)enable
{
    [self.recoverBtn setEnabled:enable];
}

#pragma mark - 懒加载
- (NSArray *)canEventBtnImagesName
{
    if (!_canEventBtnImagesName) {
        _canEventBtnImagesName = @[@"close_draft",@"delete_draft",@"undo_draft",@"redo_draft"];
    }
    return _canEventBtnImagesName;
}

- (NSArray *)notEventBtnImagesName
{
    if (!_notEventBtnImagesName) {
        _notEventBtnImagesName = @[@"close_draft_enable",@"delete_draft_enable",@"undo_draft_enable",@"redo_draft_enable"];
    }
    return _notEventBtnImagesName;
}

#pragma mark - ------------------------------------------------------------------------------------


@end
