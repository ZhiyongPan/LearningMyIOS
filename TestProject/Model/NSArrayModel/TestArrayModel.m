//
//  TestArrayModel.m
//  TestProject
//
//  Created by pzy on 2017/7/25.
//  Copyright © 2017年 pzy. All rights reserved.
//

#import "TestArrayModel.h"

@implementation TestArrayModel

//- (NSString *)description
//{
//    return @"sdsd";
//}

- (instancetype)initWithMyID:(NSString *)myID name:(NSString *)name
{
    return [self initWithMyID:myID name:name age:0];
}

- (instancetype)initWithMyID:(NSString *)myID name:(NSString *)name age:(NSInteger)age
{
    self = [super init];
    if (self) {
        self.myID = myID;
        self.name = name;
        self.age = age;
        self.array = @[@"tt", @"yy", @"uu"];
    }
    return self;
}

- (NSComparisonResult)compareModel:(TestArrayModel *)model
{
    NSComparisonResult result = [self.myID compare:model.myID];
    if (result == NSOrderedSame) {
        result = [[NSNumber numberWithInteger:self.age] compare:[NSNumber numberWithInteger:model.age]];
    }
    return result;
}

- (void)makePerformSelectorWithArr:(NSString *)arr
{
    self.name = [self.name stringByAppendingString:arr];
}

- (id)objectAtIndexedSubscript:(NSUInteger)idx
{
    return self.array[idx];
}
@end
