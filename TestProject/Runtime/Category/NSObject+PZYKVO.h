//
//  NSObject+PZYKVO.h
//  TestProject
//
//  Created by 潘志勇 on 2018/1/29.
//  Copyright © 2018年 pzy. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^PZYObserverBlock)(id observedObject, NSString *keyPath, id oldValue, id newValue);

@interface NSObject (PZYKVO)

- (void)PZY_addObserver:(id)observer forKeyPath:(NSString *)keyPath withBlock:(PZYObserverBlock)block;

@end
