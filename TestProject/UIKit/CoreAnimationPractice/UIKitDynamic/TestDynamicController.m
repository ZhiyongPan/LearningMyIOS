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
    self.paneState = PaneStateClosed;
    self.dragableController = [[DragableController alloc] init];
    self.dragableController.view.layer.cornerRadius = 8.0;
    self.dragableController.delegate = self;
    [self addChildViewController:self.dragableController];
    self.dragableController.view.frame = CGRectMake(0, SCREEN_HEIGHT * 0.5, SCREEN_WIDTH, SCREEN_HEIGHT*0.8);
    [self.view addSubview:self.dragableController.view];
    [self.dragableController didMoveToParentViewController:self];
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
    return self.paneState == PaneStateClosed > 0 ? CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT * 1) : CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2 + 50);
}

#pragma mark DragableVCDelegate

- (void)dragableVCBeganDragging:(DragableController *)dragableVC
{
    [self.animator removeAllBehaviors];
}

- (void)dragableVC:(DragableController *)dragableVC dragingEndedWithVelocity:(CGPoint)velocity
{
    PaneState targetState = velocity.y >= 0 ? PaneStateClosed : PaneStateOpen;
    self.paneState = targetState;
    [self animateWithVelocity:velocity];
}

@end
