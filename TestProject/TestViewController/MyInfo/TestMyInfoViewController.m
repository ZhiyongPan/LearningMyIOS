//
//  TestMyInfoViewController.m
//  TestProject
//
//  Created by pzy on 2017/8/14.
//  Copyright © 2017年 pzy. All rights reserved.
//

#import "TestMyInfoViewController.h"

@interface TestMyInfoViewController ()

@end

@implementation TestMyInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self testTread];
}

- (void)testTread
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        @autoreleasepool {
            NSObject *obj = [[NSObject alloc] init];
            NSObject *obj2 = [self getObj2];
            NSLog(@"obj is %@, obj2 is %@", obj, obj2);
//        }
    });
}

- (NSObject *)getObj2
{
    NSObject *obj2 = [[NSObject alloc] init];
    return obj2;
}

@end
