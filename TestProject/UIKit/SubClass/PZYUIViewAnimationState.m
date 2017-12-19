//
//  PZYUIViewAnimationState.m
//  TestProject
//
//  Created by pzy on 2017/9/5.
//  Copyright © 2017年 pzy. All rights reserved.
//

#import "PZYUIViewAnimationState.h"

@implementation PZYUIViewAnimationState

+ (instancetype)animationStateWithBeginning:(StateStartBlock)start completion:(StateCompletionBlock)completion
{
    PZYUIViewAnimationState *state = [[PZYUIViewAnimationState alloc] init];
    state.start = start;
    state.completion = completion;
    return state;
}

#pragma mark CAAnimationDelegate

- (void)animationDidStart:(CAAnimation *)anim
{
    NSLog(@"PZYUIViewAnimationState animationDidStart");
    if (self.start) {
        self.start();
    }
    self.start = nil;
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    NSLog(@"PZYUIViewAnimationState animationDidStop");
    if (self.completion) {
        self.completion(flag);
    }
    self.completion = nil;
}

@end
