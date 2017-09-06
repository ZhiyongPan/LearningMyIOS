//
//  CoreAnimationViewController.m
//  TestProject
//
//  Created by pzy on 2017/8/25.
//  Copyright © 2017年 pzy. All rights reserved.
//

#import "CoreAnimationViewController.h"
#import "AnimateTypesViewController.h"
#import "PZYView.h"
#import "UIView+CustomBlockAnimation.h"

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)

typedef NS_ENUM(NSInteger, SubViewTag){
    SubViewTagBasicAndKeyFrame  =  0>>1,
    SubViewTagGroup1            =  0>>2,
    SubViewTagGroup2            =  0>>3,
    SubViewTagPZYView           =  0>>4
};

@interface CoreAnimationViewController ()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIImageView *group_image1;
@property (nonatomic, strong) UIImageView *group_image2;

@property (nonatomic, strong) PZYView *pzyView;

@end

@implementation CoreAnimationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self addButtons];
//    [self addAnimationView];
    
//    [self addGroupAnimationViews];
    
    [self addPZYView];
    
    NSLog(@"CoreAnimationViewController viewDidLoad");
}

- (void)addButtons
{
    [self addBasicAnimationStartButton];
    [self addKeyFrameAnimationStartButton];
    [self addAnimationGroupStartButton];
    
    [self addViewControllerTransitionStartButton];
    
    [self addTestPZYViewStartButton];
}

#pragma mark add buttons

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

- (void)addAnimationGroupStartButton
{
    UIButton *button = [[UIButton alloc] init];
    button.frame = CGRectMake(220.0, 500.0, 80.0, 30.0);
    [button setTitle:@"group" forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont systemFontOfSize:16.0]];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    button.backgroundColor = [UIColor blueColor];
    [button addTarget:self action:@selector(beginGroupAnimation:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:button];
}

- (void)addViewControllerTransitionStartButton
{
    UIButton *button = [[UIButton alloc] init];
    button.frame = CGRectMake(320.0, 500.0, 80.0, 30.0);
    [button setTitle:@"VCTransition" forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont systemFontOfSize:16.0]];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    button.backgroundColor = [UIColor greenColor];
    [button addTarget:self action:@selector(beginVCTransition:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:button];
}

- (void)addTestPZYViewStartButton
{
    UIButton *button = [[UIButton alloc] init];
    button.frame = CGRectMake(20.0, 560.0, 80.0, 30.0);
    [button setTitle:@"PZYView" forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont systemFontOfSize:16.0]];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    button.backgroundColor = [UIColor greenColor];
    [button addTarget:self action:@selector(beginPZYViewButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:button];
}

#pragma mark add views

- (void)addAnimationView
{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(20.0, 150.0, 120.0, 100.0)];
    imageView.image = [UIImage imageNamed:@"Horse"];
    imageView.tag = SubViewTagBasicAndKeyFrame;
    self.imageView = imageView;
    [self.view addSubview:imageView];
}

- (void)addGroupAnimationViews
{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-130)/2.0, 150.0, 130.0, 130.0)];
    imageView.image = [UIImage imageNamed:@"group_image1"];
    imageView.tag = SubViewTagGroup1;
//    imageView.hidden = YES;
    self.group_image1 = imageView;
    [self.view addSubview:imageView];
    
    UIImageView *imageView2 = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-130)/2.0, 150.0, 130.0, 130.0)];
    imageView2.image = [UIImage imageNamed:@"group_image2"];
    imageView2.tag = SubViewTagGroup2;
    //    imageView.hidden = YES;
    self.group_image2 = imageView2;
    [self.view addSubview:imageView2];
}

- (void)addPZYView
{
    PZYView *view = [[PZYView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-130)/2.0, 150.0, 130.0, 130.0)];
    view.backgroundColor = [UIColor grayColor];
    view.tag = SubViewTagPZYView;
    self.pzyView = view;
    
    [self.view addSubview:view];
}

//- (void)removeSubviewExclude:(SubViewTag)tag
//{
//    UIView *view = nil;
//    for (int i = 0; i < 4; i++) {
//        int subTag = 0>>i;
//        if (tag != subTag) {
//            view = [self.view viewWithTag:tag];
//            [view removeFromSuperview];
//        }
//    }
//}

#pragma mark actions

- (void)beginCoreAnimation:(id)sender
{
    CABasicAnimation *animation = [CABasicAnimation animation];
    animation.keyPath = @"position.x";
    animation.fromValue = @80.0;
    animation.toValue = @200.0;
    animation.duration = 2.0;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
//    animation.timingFunction = [CAMediaTimingFunction functionWithControlPoints:0.3 :0 :0.9 :0.7];
    
    [self.imageView.layer.modelLayer addAnimation:animation forKey:@"Basic"];
    
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
    
    id action = [self.imageView actionForLayer:self.imageView.layer forKey:@"position"];
    NSLog(@"hihi");
    [UIView animateWithDuration:3.0 animations:^{
        id action2 = [self.imageView actionForLayer:self.imageView.layer forKey:@"position"];
        NSLog(@"haha");
    }];;
}

- (void)beginGroupAnimation:(id)sender
{
    CABasicAnimation *zPosition = [CABasicAnimation animation];
    zPosition.keyPath = @"zPosition";
    zPosition.fromValue = @-1;
    zPosition.toValue = @1;
    zPosition.duration = 1.2;
//
    CAKeyframeAnimation *rotation = [CAKeyframeAnimation animation];
    rotation.keyPath = @"transform.rotation";
    rotation.values = @[ @0, @0.14, @0 ];
    rotation.duration = 1.2;
    rotation.timingFunctions = @[
                                 [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                 [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]
                                 ];
    
    CAKeyframeAnimation *position = [CAKeyframeAnimation animation];
    position.keyPath = @"position";
    position.values = @[
                        [NSValue valueWithCGPoint:CGPointZero],
                        [NSValue valueWithCGPoint:CGPointMake(70, -20)],
                        [NSValue valueWithCGPoint:CGPointZero]
                        ];
    position.timingFunctions = @[
                                 [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                 [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]
                                 ];
    position.additive = YES;
    position.duration = 1.2;
    
    CAAnimationGroup *group = [[CAAnimationGroup alloc] init];
    group.animations = @[zPosition,rotation, position];
    group.duration = 1.2;
//    group.beginTime = 0.5;
    
    
    
//
    
    CABasicAnimation *zPosition2 = [CABasicAnimation animation];
    zPosition2.keyPath = @"zPosition";
    zPosition2.fromValue = @1;
    zPosition2.toValue = @-1;
    zPosition2.duration = 1.2;
    //
    CAKeyframeAnimation *rotation2 = [CAKeyframeAnimation animation];
    rotation2.keyPath = @"transform.rotation";
    rotation2.values = @[ @0, @-0.14, @0 ];
    rotation2.duration = 1.2;
    rotation2.timingFunctions = @[
                                 [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                 [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]
                                 ];
    
    CAKeyframeAnimation *position2 = [CAKeyframeAnimation animation];
    position2.keyPath = @"position";
    position2.values = @[
                        [NSValue valueWithCGPoint:CGPointZero],
                        [NSValue valueWithCGPoint:CGPointMake(-70, -20)],
                        [NSValue valueWithCGPoint:CGPointZero]
                        ];
    position2.timingFunctions = @[
                                 [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                 [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]
                                 ];
    position2.additive = YES;
    position2.duration = 1.2;
    
    CAAnimationGroup *group2 = [[CAAnimationGroup alloc] init];
    group2.animations = @[zPosition2,rotation2, position2];
    group2.duration = 1.2;
    //    group.beginTime = 0.5;
    
    [self.group_image1.layer.modelLayer addAnimation:group forKey:@"shuffle"];
    
    [self.group_image2.layer.modelLayer addAnimation:group2 forKey:@"shuffle"];
    
    self.group_image1.layer.zPosition = 1;
    
    self.group_image2.layer.zPosition = -1;
}

- (void)beginVCTransition:(id)sender
{
    AnimateTypesViewController *animateTypesViewController = [[AnimateTypesViewController alloc] init];
    
    [self.navigationController pushViewController:animateTypesViewController animated:YES];
}

- (void)beginPZYViewButton:(id)sender
{
//    CABasicAnimation *animation = [CABasicAnimation animation];
//    animation.keyPath = @"position.x";
//    animation.fromValue = @80.0;
//    animation.toValue = @200.0;
//    animation.duration = 2.0;
//    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
//    
//    [self.pzyView.layer addAnimation:animation forKey:@"Basic"];
    [UIView PZY_popAnimationWithDuration:5.0 animations:^{
        
        self.pzyView.transform = CGAffineTransformMakeRotation(M_PI_2);
        
    }];
}

@end
