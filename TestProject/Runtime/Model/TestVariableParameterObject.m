//
//  TestVariableParameterObject.m
//  TestProject
//
//  Created by 潘志勇 on 2018/1/31.
//  Copyright © 2018年 pzy. All rights reserved.
//

#import "TestVariableParameterObject.h"
#import <objc/runtime.h>

@interface TestVariableParameterObject ()

@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *lastName;
@property (nonatomic, assign) NSInteger age;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, assign) BOOL fat;

@end

@implementation TestVariableParameterObject

//目前只做到了传对象，对于非OC对象(比如BOOL，或者NSInteger)还不知道怎么搞
+ (instancetype)objectWithParas:(NSString *)firstName, ...NS_REQUIRES_NIL_TERMINATION
{
    TestVariableParameterObject *obj = [[TestVariableParameterObject alloc] init];
    if (firstName) {
        va_list args;
        NSString *arg;
        va_start(args, firstName);
        while ((arg = va_arg(args, NSString *))) {
            NSLog(@"objectWithParas");
        }
        va_end(args);
    }
    return obj;
}

@end
