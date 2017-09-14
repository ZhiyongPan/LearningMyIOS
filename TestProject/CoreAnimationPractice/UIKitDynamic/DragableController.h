//
//  DragableController.h
//  TestProject
//
//  Created by pzy on 2017/9/14.
//  Copyright © 2017年 pzy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DragableController;


@protocol DragableVCDelegate <NSObject>

- (void)dragableVC:(DragableController *)dragableVC dragingEndedWithVelocity:(CGPoint)velocity;
- (void)dragableVCBeganDragging:(DragableController *)dragableVC;

@end

@interface DragableController : UIViewController

@property (nonatomic, weak) id <DragableVCDelegate> delegate;

@end
