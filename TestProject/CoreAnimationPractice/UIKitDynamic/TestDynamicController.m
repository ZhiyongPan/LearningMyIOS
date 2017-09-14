//
//  TestDynamicController.m
//  TestProject
//
//  Created by pzy on 2017/9/14.
//  Copyright © 2017年 pzy. All rights reserved.
//

#import "TestDynamicController.h"
#import "DragableController.h"
#import "DragBehavior.h"

@interface TestDynamicController ()<DragableVCDelegate>

@property (nonatomic, strong) DragableController *dragableController;

@property (nonatomic) UIDynamicAnimator *animator;

@property (nonatomic) DragBehavior *dragBehavior;

@end

@implementation TestDynamicController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setup];
}

#pragma mark private

- (void)setup
{
    self.dragableController = [[DragableController alloc] init];
    self.dragableController.view.layer.cornerRadius = 8.0;
    [self.view addSubview:self.dragableController.view];
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
}

- (void)animateWithVelocity:(CGPoint)velocity
{
    if (!self.dragBehavior) {
        self.dragBehavior = [[DragBehavior alloc] initWithItem:self.dragableController.view];
    }
    self.dragBehavior.targetPoint = [self targetPoint];
    self.dragBehavior.velocity = velocity;
    
    [self.animator addBehavior:self.dragBehavior];
}

- (CGPoint)targetPoint
{
    CGSize size = self.view.bounds.size;
    return CGPointMake(size.width/2, size.height/2 + 50);
}

#pragma mark DragableVCDelegate

- (void)dragableVCBeganDragging:(DragableController *)dragableVC
{
    [self.animator removeAllBehaviors];
}

- (void)dragableVC:(DragableController *)dragableVC dragingEndedWithVelocity:(CGPoint)velocity
{
    
}

@end
