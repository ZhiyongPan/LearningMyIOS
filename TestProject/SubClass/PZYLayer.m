//
//  PZYLayer.m
//  TestProject
//
//  Created by pzy on 2017/9/4.
//  Copyright © 2017年 pzy. All rights reserved.
//

#import "PZYLayer.h"
#import "PZYUIViewAnimationState.h"

@implementation PZYLayer

//- (void)setFrame:(CGRect)frame
//{
//    [super setFrame:frame];
//}
//
//- (void)setPosition:(CGPoint)position
//{
//    [super setPosition:position];
//}
//
//- (void)setBounds:(CGRect)bounds
//{
//    [super setBounds:bounds];
//}
//
//- (CGPoint)position
//{
//    return [super position];
//}

- (void)addAnimation:(CAAnimation *)anim forKey:(NSString *)key
{
    anim.delegate = [PZYUIViewAnimationState animationStateWithBeginning:^{
        NSLog(@"animation did begin");
    } completion:^(BOOL finished){
        NSLog(@"animation end");
    }];
    [super addAnimation:anim forKey:key];
    NSLog(@"adding animation: %@", [anim debugDescription]);
}

@end
