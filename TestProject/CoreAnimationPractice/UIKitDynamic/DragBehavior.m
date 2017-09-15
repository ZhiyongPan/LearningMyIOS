//
//  DragBehavior.m
//  TestProject
//
//  Created by pzy on 2017/9/14.
//  Copyright © 2017年 pzy. All rights reserved.
//

#import "DragBehavior.h"
@interface DragBehavior ()

@property (nonatomic, strong) UIAttachmentBehavior *attachmentBehavior;
@property (nonatomic, strong) UIDynamicItemBehavior *dynamicItemBehavior;
@property (nonatomic, strong) id <UIDynamicItem> item;

@end

@implementation DragBehavior

- (instancetype)initWithItem:(id <UIDynamicItem>)item
{
    self = [super init];
    if (self) {
        self.item = item;
        [self setup];
    }
    return self;
}

- (void)setup
{
    UIAttachmentBehavior *attachMentBehavior = [[UIAttachmentBehavior alloc] initWithItem:self.item attachedToAnchor:CGPointZero];
    attachMentBehavior.frequency = 3.5;
    attachMentBehavior.damping = 0.4;
    attachMentBehavior.length = 0;
    [self addChildBehavior:attachMentBehavior];
    self.attachmentBehavior = attachMentBehavior;
    
    UIDynamicItemBehavior *dynamicItemBehavior = [[UIDynamicItemBehavior alloc] initWithItems:@[self.item]];
    dynamicItemBehavior.density = 100;
    dynamicItemBehavior.resistance = 10;
    [self addChildBehavior:dynamicItemBehavior];
    self.dynamicItemBehavior = dynamicItemBehavior;
}

- (void)setTargetPoint:(CGPoint)targetPoint
{
    _targetPoint = targetPoint;
    _attachmentBehavior.anchorPoint = targetPoint;
}

- (void)setVelocity:(CGPoint)velocity
{
    _velocity = velocity;
    CGPoint currentVelocity = [_dynamicItemBehavior linearVelocityForItem:_item];
    CGPoint velocityDelta = CGPointMake(velocity.x - currentVelocity.x, velocity.y - currentVelocity.y);
    [_dynamicItemBehavior addLinearVelocity:velocityDelta forItem:_item];
}

@end
