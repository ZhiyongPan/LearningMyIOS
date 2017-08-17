//
//  Mediator.m
//  TestProject
//
//  Created by pzy on 2017/8/14.
//  Copyright © 2017年 pzy. All rights reserved.
//

#import "Mediator.h"

#import <objc/runtime.h>

@interface Mediator () <UINavigationControllerDelegate>



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

#pragma mark - Public

- (void)setupWithNavigationController:(UINavigationController *)navigationContrller
{
    self.navigationController = navigationContrller;
    self.navigationController.delegate = self;
}

- (void)canSwitchController
{
    
}

//+ (UIViewController *)viewControllerWithName:(NSString *)name params:(NSDictionary *)params
//{
//    if ([name hasPrefix:@"k"]) {
//        name = [name substringFromIndex:1];
//    }
//    
//    Class clz = NSClassFromString(name);
//    if (!clz) {
//        return nil;
//    }
//    
//    SEL selector = NSSelectorFromString(@"viewController");
//    
//    if (![clz respondsToSelector:selector]) {
//        return nil;
//    }
//    
//    UIViewController *viewController = nil;
//    [viewController performSelector:selector];
//    
//    for (NSString *propertyName in params.allKeys) {
//        id propertyValue = params[propertyName];
//    }
//    
//}
//
//+ (BOOL)isValidWithPropertyName:(NSString *)name value:(id)value inClass:(Class)clz
//{
//    objc_property_t property = class_getProperty(clz, [name UTF8String]);
//    if (property == NULL) {
//        return NO;
//    }
//    
//    unsigned int attrCount = 0;
//    objc_property_attribute_t *attrs = property_copyAttributeList(property, attrCount);
//    if (attrCount == 0) {
//        return NO;
//    }
//    
//    
//}

@end
