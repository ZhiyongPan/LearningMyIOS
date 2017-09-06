//
//  UIView+CustomBlockAnimation.h
//  TestProject
//
//  Created by pzy on 2017/9/5.
//  Copyright © 2017年 pzy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (CustomBlockAnimation)

+ (void)PZY_popAnimationWithDuration:(NSTimeInterval)duration
                          animations:(void (^)(void))animations;

@end
