//
//  ViewController.m
//  TestProject
//
//  Created by pzy on 2017/6/28.
//  Copyright © 2017年 pzy. All rights reserved.
//

#import "ViewController.h"
#import "TestSet.h"




@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSMutableArray *testArray = [self setTestArray:3];
    NSMutableArray *testArray2 = [self setTestArray:4];
    
    NSOrderedSet *set = [NSOrderedSet orderedSetWithArray:[testArray arrayByAddingObjectsFromArray:testArray2]];
    NSArray *array = [set array];
    id object = set[1];
    [self printArray:array];
    NSLog(@"%@",array);
    
    
}



- (NSMutableArray *)setTestArray:(int)mod
{
    NSMutableArray *testArray = [[NSMutableArray alloc] init];
    for(int i = 0;i < 10;i++){
        TestSet *testSet = [[TestSet alloc] init];
        testSet.sid = i%mod;
//        testSet.str = [NSString stringWithFormat:@"test%i-%i",mod,i];
        testSet.str = @"test";
        [testArray addObject:testSet];
    }
    return testArray;
}

- (void)printArray:(NSArray *)array
{
    for (int i = 0; i < array.count; i++) {
        TestSet *testSet = array[i];
        NSLog(@"sid------%i-------%@",testSet.sid,testSet.str);
    }
}

@end
