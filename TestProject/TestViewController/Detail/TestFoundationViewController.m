//
//  TestDetailViewController.m
//  TestProject
//
//  Created by pzy on 2017/8/14.
//  Copyright © 2017年 pzy. All rights reserved.
//

#import "TestFoundationViewController.h"
#import "TestMemoryController.h"

#define RightButtonFrameY (SCREEN_WIDTH/3.0) * 2.0

#define ButtonWidth SCREEN_WIDTH/3.0

@interface TestFoundationViewController ()

@end

@implementation TestFoundationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addMemoryButton];
}

- (void)addMemoryButton
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"Memory" forState:UIControlStateNormal];
    button.backgroundColor = [UIColor redColor];
    button.frame = CGRectMake(0, 100, ButtonWidth, 30.0);
    [button addTarget:self action:@selector(gotoMemoryController) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)gotoMemoryController
{
    TestMemoryController *controller = [[TestMemoryController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
}

@end
