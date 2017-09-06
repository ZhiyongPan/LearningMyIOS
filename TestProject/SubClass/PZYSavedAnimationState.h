//
//  PZYSavedAnimationState.h
//  TestProject
//
//  Created by pzy on 2017/9/5.
//  Copyright © 2017年 pzy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PZYSavedAnimationState : NSObject

@property (nonatomic, strong) CALayer *layer;

@property (nonatomic, strong) NSString *keyPath;

@property (nonatomic, strong) id oldValue;

+ (instancetype)savedStateWithLayer:(CALayer *)layer
                            keyPath:(NSString *)keyPath;

@end
