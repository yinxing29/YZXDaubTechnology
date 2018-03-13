//
//  ViewController.m
//  DaubTechnology
//
//  Created by 尹星 on 2018/3/13.
//  Copyright © 2018年 尹星. All rights reserved.
//

#import "ViewController.h"
#import "YZXDrawHeader.h"

@interface ViewController ()

@property (nonatomic, strong) YZXDrawManager       *drawManager;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self p_createData];
    [self p_createView];
}

- (void)p_createData
{
    self.drawManager.lineWidth = 10.0;
    self.drawManager.lineColor = [UIColor blueColor];
    self.drawManager.lineContentsImage = [UIImage imageNamed:@"delete_draft"];
}

- (void)p_createView
{
    
}

- (IBAction)sefmentedControlPressed:(UISegmentedControl *)sender {
    if (sender.selectedSegmentIndex == 0) {
        self.drawManager.lineType = YZXDrawDefaultLine;
    }else {
        self.drawManager.lineType = YZXDrawImageLine;
    }
}

- (IBAction)buttonPressed:(UIButton *)sender {
    DrawingViewController *drawingVC = [[DrawingViewController alloc] init];
    [self presentViewController:drawingVC animated:YES completion:nil];
}

#pragma mark - 懒加载
- (YZXDrawManager *)drawManager
{
    if (!_drawManager) {
        _drawManager = [YZXDrawManager defaultManager];
    }
    return _drawManager;
}

#pragma mark - ------------------------------------------------------------------------------------

@end
