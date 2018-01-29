//
//  PZYObserverInfo.h
//  TestProject
//
//  Created by 潘志勇 on 2018/1/29.
//  Copyright © 2018年 pzy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+PZYKVO.h"

@interface PZYObserverInfo : NSObject

@property (nonatomic, weak) NSObject *observer;
@property (nonatomic, copy) NSString *key;
@property (nonatomic, copy) PZYObserverBlock block;

- (instancetype)initWithObserver:(NSObject *)observer keyPath:(NSString *)keyPath block:(PZYObserverBlock)block;

@end
