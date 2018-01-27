//
//  TestAutoreleasePoolObject.m
//  TestProject
//
//  Created by 潘志勇 on 2018/1/26.
//  Copyright © 2018年 pzy. All rights reserved.
//

#import "TestAutoreleasePoolObject.h"

@interface TestAutoreleasePoolObject ()

@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *lastName;

@end

@implementation TestAutoreleasePoolObject

- (void)dealloc
{
    NSLog(@"TestAutoreleasePoolObject dealloc %@", _name);
}

+ (instancetype)testAutoreleasePoolObjectWithName:(NSString *)name
{
    TestAutoreleasePoolObject *obj = [TestAutoreleasePoolObject new];
    obj.name = name;
    obj.image = [UIImage imageNamed:@"test_image_1"];
    return obj;
}

- (instancetype)initWithName:(NSString *)name
{
    if (self = [super init]) {
        _name = name;
    }
    return self;
}

- (NSString *)fullName {
    NSString *string = [[NSString alloc] initWithFormat:@"%@ %@",
                         self.firstName, self.lastName];
    return string;
}

@end
