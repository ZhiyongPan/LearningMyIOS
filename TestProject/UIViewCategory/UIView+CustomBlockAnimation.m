//
//  UIView+CustomBlockAnimation.m
//  TestProject
//
//  Created by pzy on 2017/9/5.
//  Copyright © 2017年 pzy. All rights reserved.
//

#import "UIView+CustomBlockAnimation.h"
#import <objc/runtime.h>
#import "PZYSavedAnimationState.h"

static void *PZY_currentAnimationContext = NULL;
static void *PZY_popAnimationContext     = &PZY_popAnimationContext;
static NSString *PZY_savedPopAnimationStatesCtx = @"array";
static NSString *array = @"123";

@implementation UIView (CustomBlockAnimation)

+ (NSMutableArray *)PZY_savedPopAnimationStates {
    
    NSMutableArray *oldArray = objc_getAssociatedObject(array, &PZY_savedPopAnimationStatesCtx);
    if (!oldArray) {
        
        oldArray = [NSMutableArray array];
        objc_setAssociatedObject(array, &PZY_savedPopAnimationStatesCtx, oldArray, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return oldArray;
}

+ (void)load
{
    SEL originActionForLayerSel = @selector(actionForLayer:forKey:);
    SEL siwizzActionForLayerSel = @selector(customActionForLayer:forKey:);
    
    Method originMethod = class_getInstanceMethod(self, originActionForLayerSel);
    Method siwizzMethod = class_getInstanceMethod(self, siwizzActionForLayerSel);
    
    if (class_addMethod(self, originActionForLayerSel, method_getImplementation(siwizzMethod), method_getTypeEncoding(siwizzMethod))) {
        class_replaceMethod(self, siwizzActionForLayerSel, method_getImplementation(originMethod), method_getTypeEncoding(originMethod));
    } else {
        method_exchangeImplementations(originMethod, siwizzMethod);
    }
}

- (id<CAAction>)customActionForLayer:(CALayer *)layer forKey:(NSString *)key
{
    if (PZY_currentAnimationContext == PZY_popAnimationContext) {
        NSLog(@"PZY_popAnimationContext");
        [[UIView PZY_savedPopAnimationStates] addObject:[PZYSavedAnimationState savedStateWithLayer:layer
                                                                                             keyPath:key]];
    }
    return [self customActionForLayer:layer forKey:key];
}

+ (void)PZY_popAnimationWithDuration:(NSTimeInterval)duration
                         animations:(void (^)(void))animations
{
    PZY_currentAnimationContext = PZY_popAnimationContext;
    
    // 执行动画 (它将触发交换后的 delegate 方法)
    animations();
    
    [[self PZY_savedPopAnimationStates] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        PZYSavedAnimationState *savedState   = (PZYSavedAnimationState *)obj;
        CALayer *layer    = savedState.layer;
        NSString *keyPath = savedState.keyPath;
        id oldValue       = savedState.oldValue;
        id newValue       = [layer valueForKeyPath:keyPath];
        
        CAKeyframeAnimation *anim = [CAKeyframeAnimation animationWithKeyPath:keyPath];
        
        CGFloat easing = 0.2;
        CAMediaTimingFunction *easeIn  = [CAMediaTimingFunction functionWithControlPoints:1.0 :0.0 :(1.0-easing) :1.0];
        CAMediaTimingFunction *easeOut = [CAMediaTimingFunction functionWithControlPoints:easing :0.0 :0.0 :1.0];
        
        anim.duration = duration;
        anim.keyTimes = @[@0, @(0.35), @1];
        anim.values = @[oldValue, newValue, oldValue];
        anim.timingFunctions = @[easeIn, easeOut];
        
        // 不带动画地返回原来的值
        [CATransaction begin];
        [CATransaction setDisableActions:YES];
        [layer setValue:oldValue forKeyPath:keyPath];
        [CATransaction commit];
        
        // 添加 "pop" 动画
        [layer addAnimation:anim forKey:keyPath];
        
    }];
    
    // 扫除工作 (移除所有存储的状态)
    [[self PZY_savedPopAnimationStates] removeAllObjects];
    
    PZY_currentAnimationContext = nil;
}

//+ (NSMutableArray *)PZY_savedAnimationStates
//{
//    static NSMutableArray *mutableArray = nil;
//    if (!mutableArray) {
//        mutableArray = [[NSMutableArray alloc] init];
//    }
//    return mutableArray;
//}
@end
