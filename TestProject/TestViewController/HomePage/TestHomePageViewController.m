//
//  TestHomePageViewController.m
//  TestProject
//
//  Created by pzy on 2017/8/14.
//  Copyright © 2017年 pzy. All rights reserved.
//

#import "TestHomePageViewController.h"
#import "CoreAnimationViewController.h"
#import "PZYLayer.h"

@interface TestHomePageViewController ()

@property (nonatomic, strong) CALayer *layer;

@property (nonatomic, strong) UIView *testView;

@property (nonatomic, strong) PZYLayer *pzyLayer;

@end

@implementation TestHomePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addStartButton];
    
    [self addTestButton];
    
    [self addTestLayer];
    [self addTestView];
}

- (void)addStartButton
{
    UIButton *button = [[UIButton alloc] init];
    button.frame = CGRectMake(100.0, 100.0, 80.0, 30.0);
    [button setTitle:@"开始" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    button.backgroundColor = [UIColor yellowColor];
    [button addTarget:self action:@selector(pushToAnimationViewController) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:button];
}

- (void)addTestButton
{
    UIButton *button = [[UIButton alloc] init];
    button.frame = CGRectMake(220.0, 100.0, 80.0, 30.0);
    [button setTitle:@"Test" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    button.backgroundColor = [UIColor greenColor];
    [button addTarget:self action:@selector(testButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:button];
}

- (void)addTestLayer
{
    CALayer *layer = [[CALayer alloc] init];
    layer.frame = CGRectMake(100, 200, 100, 100);
    layer.backgroundColor = [UIColor grayColor].CGColor;
    self.layer = layer;
    
    [self.view.layer addSublayer:layer];
}

- (void)addTestView
{
    UIView *view = [[UIView alloc] init];
    view.frame = CGRectMake(100, 350, 100, 100);
    view.backgroundColor = [UIColor redColor];
    self.testView = view;
    
    UIView *subView = [[UIView alloc] initWithFrame:CGRectMake(20, 20, 20, 20)];
    subView.backgroundColor = [UIColor blueColor];
    [view addSubview:subView];
    
    [self.view addSubview:view];
}

- (void)pushToAnimationViewController
{
    CoreAnimationViewController *animationViewController = [[CoreAnimationViewController alloc] init];
    [self.navigationController pushViewController:animationViewController animated:YES];
}

- (void)testButtonClicked:(id)sender
{
    /*-------------------------------------CATransaction-----------------------------------*/
    
//    self.layer.frame = CGRectMake(300, 200, 100, 100);
    
    [CATransaction begin];
    [CATransaction setAnimationDuration:5.0];
    self.layer.frame = CGRectMake(300, 200, 100, 100);
    [CATransaction setCompletionBlock:^{                   //动画结束后回调
        NSLog(@"animation completed");
    }];
    [CATransaction commit];
    
    /*--------UIView与CALayer的bounds属性，具体见有道云笔记的《UIView与CALayer的相关属性》----------*/
//    self.testView.bounds = CGRectMake(0, 0, 70, 70);
    
    id<CAAction> animation = [self.layer.delegate actionForLayer:self.layer forKey:@"position"]; //返回nil就会执行隐式动画
    NSLog(@"haha");
}

@end
