//
//  TestHomePageViewController.m
//  TestProject
//
//  Created by pzy on 2017/8/14.
//  Copyright © 2017年 pzy. All rights reserved.
//

#import "TestHomePageViewController.h"
#import "CoreAnimationViewController.h"

@interface TestHomePageViewController ()

@end

@implementation TestHomePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addStartButton];
}

- (void)addStartButton
{
    UIButton *button = [[UIButton alloc] init];
    button.frame = CGRectMake(100.0, 100.0, 80.0, 30.0);
    [button setTitle:@"kaishi" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    button.backgroundColor = [UIColor yellowColor];
    [button addTarget:self action:@selector(pushToAnimationViewController) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:button];
}

- (void)pushToAnimationViewController
{
    CoreAnimationViewController *animationViewController = [[CoreAnimationViewController alloc] init];
    [self.navigationController pushViewController:animationViewController animated:YES];
}
@end
