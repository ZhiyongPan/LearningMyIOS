//
//  NSObject+PZYKVO.h
//  TestProject
//
//  Created by 潘志勇 on 2018/1/29.
//  Copyright © 2018年 pzy. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^PZYObserverBlock)(id observedObject, NSString * observeKey, id oldValue, id newValue);

@interface NSObject (PZYKVO)

- (void)PZY_addObserver:(NSObject *)object forKeyPath:(nonnull NSString *)keyPath withBlock:(PZYObserverBlock)block;

- (void)PZY_removeObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath;

@end
