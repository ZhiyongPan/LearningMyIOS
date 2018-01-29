//
//  PZYObserverInfo.m
//  TestProject
//
//  Created by 潘志勇 on 2018/1/29.
//  Copyright © 2018年 pzy. All rights reserved.
//

#import "PZYObserverInfo.h"

@implementation PZYObserverInfo

- (instancetype)initWithObserver:(NSObject *)observer keyPath:(NSString *)keyPath block:(PZYObserverBlock)block
{
    if (self = [super init]) {
        _observer = observer;
        _key = keyPath;
        _block = block;
    }
    return self;
}

@end
