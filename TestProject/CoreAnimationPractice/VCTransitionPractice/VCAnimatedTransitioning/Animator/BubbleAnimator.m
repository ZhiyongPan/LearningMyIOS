//
//  BubbleAnimator.m
//  TestProject
//
//  Created by pzy on 2017/8/31.
//  Copyright © 2017年 pzy. All rights reserved.
//

#import "BubbleAnimator.h"

@implementation BubbleAnimator

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 0.5f;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView *containerView = [transitionContext containerView];
    
    UIView *fromView = nil;
    UIView *toView = nil;
    if ([transitionContext respondsToSelector:@selector(viewForKey:)]) {
        fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
        toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    } else {
        fromView = fromVC.view;
        toView = toVC.view;
    }
    
    UIView *bubbleView = [[UIView alloc] init];
    bubbleView.backgroundColor = toView.backgroundColor; // [UIColor purpleColor];
    CGSize toViewSize = toView.frame.size;
    CGFloat x = fmax(_bubbleCenter.x, toViewSize.width);
    CGFloat y = fmax(_bubbleCenter.y, toViewSize.height);
    CGFloat radius = sqrt(x * x + y * y);
    bubbleView.frame = CGRectMake(0, 0, radius * 2, radius * 2);
    bubbleView.layer.cornerRadius = CGRectGetHeight(bubbleView.frame) / 2;
    bubbleView.transform = CGAffineTransformMakeScale(0.001, 0.001);
    bubbleView.center = _bubbleCenter;
    [containerView addSubview:bubbleView];
    
    // toView要跟随bubbleView一起做动画
    toView.frame = [transitionContext finalFrameForViewController:toVC];
    CGPoint toViewFinalCenter = toView.center;
    toView.transform = CGAffineTransformMakeScale(0.001, 0.001);
    toView.center = _bubbleCenter;
    toView.alpha = 0.0;
    [containerView addSubview:toView];
    
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    
    [UIView animateWithDuration:duration animations:^{
        bubbleView.transform = CGAffineTransformIdentity;
        
        toView.transform = CGAffineTransformIdentity;
        toView.alpha = 1.0f;
        toView.center = toViewFinalCenter;
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }];
}

@end
