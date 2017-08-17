//
//  Mediator.h
//  TestProject
//
//  Created by pzy on 2017/8/14.
//  Copyright © 2017年 pzy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Mediator : NSObject

@property (nonatomic, weak) UINavigationController *navigationController;

+ (instancetype)sharedObject;

- (void)setupWithNavigationController:(UINavigationController *)navigationContrller;

+ (UIViewController *)viewControllerWithName:(NSString *)name params:(NSDictionary *)params;

@end
