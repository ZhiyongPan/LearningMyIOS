//
//  TestAutoreleasePoolObject.h
//  TestProject
//
//  Created by 潘志勇 on 2018/1/26.
//  Copyright © 2018年 pzy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TestAutoreleasePoolObject : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) UIImage *image;

+ (instancetype)testAutoreleasePoolObjectWithName:(NSString *)name;

- (instancetype)initWithName:(NSString *)name;

@end
