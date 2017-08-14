//
//  Mediator.m
//  TestProject
//
//  Created by pzy on 2017/8/14.
//  Copyright © 2017年 pzy. All rights reserved.
//

#import "Mediator.h"

@interface Mediator ()



@end

@implementation Mediator

+ (instancetype)sharedObject
{
    static id _sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[self alloc] init];
    });
    return _sharedInstance;
}

- (void)setupWithNavigationController:(UINavigationController *)navigationContrller
{
    self.navigationController = navigationContrller;
    self.navigationController.delegate = self;
}

@end
