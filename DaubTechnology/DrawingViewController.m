//
//  DrawingViewController.m
//  DaubTechnology
//
//  Created by 尹星 on 2018/3/13.
//  Copyright © 2018年 尹星. All rights reserved.
//

#import "DrawingViewController.h"
#import "DrawingBoardView.h"
#import "YZXDrawManager.h"

@interface DrawingViewController ()

@property (nonatomic, strong) DrawingBoardView       *drawingBoardView;

@end

@implementation DrawingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self p_createView];
}

- (void)p_createView
{
    [self.view addSubview:self.drawingBoardView];
}

- (DrawingBoardView *)drawingBoardView
{
    if (!_drawingBoardView) {
        _drawingBoardView = [[DrawingBoardView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)
                                                     viewController:self];
        _drawingBoardView.backgroundColor = [UIColor yellowColor];
    }
    return _drawingBoardView;
}

@end
