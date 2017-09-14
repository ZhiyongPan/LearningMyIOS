//
//  DragableController.m
//  TestProject
//
//  Created by pzy on 2017/9/14.
//  Copyright © 2017年 pzy. All rights reserved.
//

#import "DragableController.h"


@interface DragableController ()


@end

@implementation DragableController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor grayColor];
}

- (void)setupDragableController
{
    UIPanGestureRecognizer *recognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(didPan:)];
    [self.view addGestureRecognizer:recognizer];
}

- (void)didPan:(UIPanGestureRecognizer *)recognizer
{
    CGPoint point = [recognizer translationInView:self.view.superview];
    self.view.center = CGPointMake(self.view.center.x, self.view.center.y + point.y);
    [recognizer setTranslation:CGPointZero inView:self.view.superview];
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        CGPoint velocity = [recognizer velocityInView:self.view.superview];
        velocity.x = 0;//为了不在x方向上移动
        if ([self.delegate respondsToSelector:@selector(dragableVC:dragingEndedWithVelocity:)]) {
            [self.delegate dragableVC:self dragingEndedWithVelocity:velocity];
        } else if ([self.delegate respondsToSelector:@selector(dragableVCBeganDragging:)]) {
            [self.delegate dragableVCBeganDragging:self];
        }
    }
}

@end
