//
//  TestAnimationTimeViewController.m
//  TestProject
//
//  Created by pzy on 2017/9/12.
//  Copyright © 2017年 pzy. All rights reserved.
//

#import "TestAnimationTimeViewController.h"

@interface TestAnimationTimeViewController ()

@property (nonatomic, strong) UIView *testView;

@property (nonatomic, strong) CALayer *testLayer;
@end

@implementation TestAnimationTimeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self addTestLayer];
    [self addSlider];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self beginAnimation];
}

- (void)addTestLayer
{
    CALayer *layer = [[CALayer alloc] init];
    layer.frame = CGRectMake((SCREEN_WIDTH - 250) / 2, 150, 250, 40);
    layer.backgroundColor = [UIColor orangeColor].CGColor;
    self.testLayer = layer;
    [self.view.layer addSublayer:layer];
}

- (void)addSlider
{
    // 滑动条slider
    UISlider *slider = [[UISlider alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 250) / 2, 200, 250, 20)];
    slider.minimumValue = 0;// 设置最小值
    slider.maximumValue = 1;// 设置最大值
    slider.value = 0;// 设置初始值
    slider.continuous = YES;// 设置可连续变化
    [slider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];// 针对值变化添加响应方法
    [self.view addSubview:slider];
}

- (void)beginAnimation
{
    CABasicAnimation *animation = [CABasicAnimation animation];
    animation.keyPath = @"backgroundColor";
    animation.fromValue = (id)[UIColor orangeColor].CGColor;
    animation.toValue   = (id)[UIColor blueColor].CGColor;
    animation.duration  = 1.0; // For convenience
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    
    self.testLayer.speed = 0.0; // Pause the animation
    
    [self.testLayer addAnimation:animation
                        forKey:@"backgroundColor"];
}

- (void)sliderValueChanged:(UISlider *)sender
{
    self.testLayer.timeOffset = sender.value;
}

@end
