//
//  TestArrayModel.h
//  TestProject
//
//  Created by pzy on 2017/7/25.
//  Copyright © 2017年 pzy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TestArrayModel : NSObject

@property (nonatomic, strong) NSString *myID;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) NSInteger age;
@property (nonatomic, strong) NSArray *array;


- (instancetype)initWithMyID:(NSString *)myID name:(NSString *)name;
- (instancetype)initWithMyID:(NSString *)myID name:(NSString *)name age:(NSInteger)age;

- (NSComparisonResult)compareModel:(TestArrayModel *)model;

- (void)makePerformSelectorWithArr:(NSString *)arr;

- (id)objectAtIndexedSubscript:(NSUInteger)idx;
@end
