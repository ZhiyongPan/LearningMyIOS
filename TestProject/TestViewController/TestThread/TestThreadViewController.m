//
//  TestThreadViewController.m
//  TestProject
//
//  Created by 潘志勇 on 2018/3/1.
//  Copyright © 2018年 pzy. All rights reserved.
//

#import "TestThreadViewController.h"
#import "TestGCDViewController.h"
#import "TestNSOperationController.h"
#import "TestRunLoopController.h"
#import "TestNSOperationController.h"

@interface TestThreadViewController ()

@end

@implementation TestThreadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addGCDButton];
    
    AddButton(NO, 1, @"RunLoop");
    AddButton(YES, 2, @"NSOperation");
}

- (void)addGCDButton
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"GCD" forState:UIControlStateNormal];
    button.backgroundColor = [UIColor redColor];
    button.frame = CGRectMake(0, 100, ButtonWidth, 30.0);
    [button addTarget:self action:@selector(gotoGCDController) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)gotoGCDController
{
    TestGCDViewController *controller = [[TestGCDViewController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)addNSOperationButton
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"NSOperation" forState:UIControlStateNormal];
    button.backgroundColor = [UIColor redColor];
    button.frame = CGRectMake(RightButtonFrameX, 100, ButtonWidth, 30.0);
    [button addTarget:self action:@selector(gotoNSOperationController) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)gotoNSOperationController
{
    TestNSOperationController *controller = [[TestNSOperationController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)onRunLoopButtonClicked
{
    TestRunLoopController *controller = [[TestRunLoopController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)onNSOperationButtonClicked
{
    TestNSOperationController *controller = [[TestNSOperationController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
}

@end
