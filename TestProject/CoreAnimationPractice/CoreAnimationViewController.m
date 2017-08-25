//
//  CoreAnimationViewController.m
//  TestProject
//
//  Created by pzy on 2017/8/25.
//  Copyright © 2017年 pzy. All rights reserved.
//

#import "CoreAnimationViewController.h"

@interface CoreAnimationViewController ()

@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation CoreAnimationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self addButtons];
    [self addAnimationView];
    
//    id modelLayer = [self.imageView.layer modelLayer];
//    id presentationLayer = [self.imageView.layer presentationLayer];
    NSLog(@"CoreAnimationViewController viewDidLoad");
}

- (void)addButtons
{
    [self addBasicAnimationStartButton];
    [self addKeyFrameAnimationStartButton];
}

- (void)addBasicAnimationStartButton
{
    UIButton *button = [[UIButton alloc] init];
    button.frame = CGRectMake(20.0, 500.0, 80.0, 30.0);
    [button setTitle:@"Basic" forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont systemFontOfSize:16.0]];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    button.backgroundColor = [UIColor redColor];
    [button addTarget:self action:@selector(beginCoreAnimation:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:button];
}

- (void)addKeyFrameAnimationStartButton
{
    UIButton *button = [[UIButton alloc] init];
    button.frame = CGRectMake(120.0, 500.0, 80.0, 30.0);
    [button setTitle:@"KeyFrame" forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont systemFontOfSize:16.0]];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    button.backgroundColor = [UIColor yellowColor];
    [button addTarget:self action:@selector(beginKeyFrameAnimation:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:button];
}

- (void)addAnimationView
{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(20.0, 150.0, 120.0, 100.0)];
    imageView.image = [UIImage imageNamed:@"Horse"];
    self.imageView = imageView;
    [self.view addSubview:imageView];
}

- (void)beginCoreAnimation:(id)sender
{
    CABasicAnimation *animation = [CABasicAnimation animation];
    animation.keyPath = @"position.x";
    animation.fromValue = @80.0;
    animation.toValue = @200.0;
    animation.duration = 2.0;
    
    [self.imageView.layer addAnimation:animation forKey:@"Basic"];
}

- (void)beginKeyFrameAnimation:(id)sender
{
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
    animation.keyPath = @"position.x";
    animation.values = @[@0, @30, @-30, @30, @0];
    animation.keyTimes = @[@0, @(1/6.0), @(3/6.0), @(5/6.0), @1];
    animation.duration = 2.0;
    animation.additive = YES;
    
    [self.imageView.layer addAnimation:animation forKey:@"KeyFrame"];
}
@end
