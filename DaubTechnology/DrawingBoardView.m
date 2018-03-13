//
//  DrawingBoardView.m
//  DaubTechnology
//
//  Created by 尹星 on 2018/3/13.
//  Copyright © 2018年 尹星. All rights reserved.
//

#import "DrawingBoardView.h"
#import "ToolBarView.h"
#import "DrawView.h"

@interface DrawingBoardView ()

@property (nonatomic, strong) UIViewController  *VC;

@property (nonatomic, strong) DrawView          *drawView;
@property (nonatomic, strong) ToolBarView       *toolBarView;

@end

@implementation DrawingBoardView

- (instancetype)initWithFrame:(CGRect)frame
               viewController:(UIViewController *)VC
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.VC = VC;
        [self p_createData];
        [self p_createView];
    }
    return self;
}

- (void)p_createData
{
    [self.drawView addObserver:self forKeyPath:@"drawLines" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    [self.drawView addObserver:self forKeyPath:@"revocationLines" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
}

- (void)p_createView
{
    __weak typeof(self) weak_self = self;
    self.toolBarView.eventBlock = ^(ToolBarEventType eventType) {
        switch (eventType) {
            case ToolBarEventCancel:
            {
                [weak_self.VC dismissViewControllerAnimated:YES completion:nil];
            }
                break;
            case ToolBarEventDelete:
            {
                [weak_self.drawView deleteLines];
            }
                break;
            case ToolBarEventRevocation:
            {
                [weak_self.drawView revocationLine];
            }
                break;
            case ToolBarEventRecover:
            {
                [weak_self.drawView recoverLine];
            }
                break;
        }
    };
    
    [self addSubview:self.toolBarView];
    
    [self addSubview:self.drawView];
}

#pragma mark - 观察者
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"revocationLines"]) {
        if (self.drawView.revocationLines.count > 0) {
            [self.toolBarView recoverBtnSetEnabled:YES];
        }else {
            [self.toolBarView recoverBtnSetEnabled:NO];
        }
    }
    
    if ([keyPath isEqualToString:@"drawLines"]) {
        if (self.drawView.drawLines.count > 0) {
            [self.toolBarView deleteBtnSetEnabled:YES];
            [self.toolBarView revocationBtnSetEnabled:YES];
        }else {
            [self.toolBarView deleteBtnSetEnabled:NO];
            [self.toolBarView revocationBtnSetEnabled:NO];
        }
    }
}

#pragma mark - ------------------------------------------------------------------------------------

#pragma mark - 懒加载
- (ToolBarView *)toolBarView
{
    if (!_toolBarView) {
        _toolBarView = [[ToolBarView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 50, self.frame.size.width, 50)];
        _toolBarView.backgroundColor = [UIColor orangeColor];
    }
    return _toolBarView;
}

- (DrawView *)drawView
{
    if (!_drawView) {
        _drawView = [[DrawView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height - 50)];
    }
    return _drawView;
}

#pragma mark - ------------------------------------------------------------------------------------

- (void)dealloc
{
    [self.drawView removeObserver:self forKeyPath:@"drawLines"];
    [self.drawView removeObserver:self forKeyPath:@"revocationLines"];
}

@end
