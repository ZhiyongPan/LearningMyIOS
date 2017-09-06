//
//  PZYUIViewAnimationState.h
//  TestProject
//
//  Created by pzy on 2017/9/5.
//  Copyright © 2017年 pzy. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^StateStartBlock)();
typedef void(^StateCompletionBlock)(BOOL);

@interface PZYUIViewAnimationState : NSObject<CAAnimationDelegate>

@property (nonatomic, copy) StateStartBlock start;
@property (nonatomic, copy) StateCompletionBlock completion;

+ (instancetype)animationStateWithBeginning:(StateStartBlock)start completion:(StateCompletionBlock)completion;

@end
