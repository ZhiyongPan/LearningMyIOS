//
//  VCAnimatedTransitioningViewController.m
//  TestProject
//
//  Created by pzy on 2017/8/31.
//  Copyright © 2017年 pzy. All rights reserved.
//

#import "VCAnimatedTransitioningViewController.h"
#import "TransitioningToViewController.h"
#import "BubbleAnimator.h"

@interface VCAnimatedTransitioningViewController ()<UIViewControllerTransitioningDelegate>

@property (nonatomic, strong) UIButton *button;

@end

@implementation VCAnimatedTransitioningViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor grayColor];
    [self configBeginButton];
}

- (void)configBeginButton
{
    UIButton *button = [[UIButton alloc] init];
    button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake((self.view.frame.size.width - 80) / 2,
                              self.view.frame.size.height - 80 - 64,
                              80,
                              80);
    [self.view addSubview:button];
    [button setTitle:@"+" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.backgroundColor = [UIColor purpleColor];
    button.titleLabel.font = [UIFont boldSystemFontOfSize:60];
    
    button.layer.cornerRadius = 40;
    [button addTarget:self action:@selector(beginButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    self.button = button;
}

- (void)beginButtonClicked:(id)sender
{
    TransitioningToViewController *toViewController = [[TransitioningToViewController alloc] init];
    toViewController.transitioningDelegate = self;
    [self presentViewController:toViewController animated:YES completion:nil];
}

#pragma mark UIViewControllerTransitioningDelegate

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    switch (self.concreteTrasitionType) {
        case VCConcreteTransitionTypeBubble:
        {
            BubbleAnimator *bubbleAnimator = [[BubbleAnimator alloc] init];
            bubbleAnimator.bubbleCenter = self.button.center;
            return bubbleAnimator;
            break;
        }
        default:
            break;
    }
    return nil;
}

@end
