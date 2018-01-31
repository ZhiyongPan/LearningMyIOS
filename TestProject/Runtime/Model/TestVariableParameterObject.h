//
//  TestVariableParameterObject.h
//  TestProject
//
//  Created by 潘志勇 on 2018/1/31.
//  Copyright © 2018年 pzy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TestVariableParameterObject : NSObject

+ (instancetype)objectWithParas:(NSString *)firstName, ...NS_REQUIRES_NIL_TERMINATION;

@end
