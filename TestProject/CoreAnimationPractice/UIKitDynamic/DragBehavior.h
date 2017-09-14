//
//  DragBehavior.h
//  TestProject
//
//  Created by pzy on 2017/9/14.
//  Copyright © 2017年 pzy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DragBehavior : UIDynamicBehavior

@property (nonatomic) CGPoint targetPoint;
@property (nonatomic) CGPoint velocity;

- (instancetype)initWithItem:(id <UIDynamicItem>)item;

@end
