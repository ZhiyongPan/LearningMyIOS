//
//  TestNSOperationController.m
//  TestProject
//
//  Created by 潘志勇 on 2018/3/1.
//  Copyright © 2018年 pzy. All rights reserved.
//

#import "TestNSOperationController.h"

@interface TestNSOperationController ()

@end

@implementation TestNSOperationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    AddButton(YES, 1, @"Sync");
    AddButton(NO, 1, @"Async");
    AddButton(YES, 2, @"TestDependency");
    AddButton(NO, 2, @"TestCancel");
    AddButton(YES, 3, @"Suspend");
}

- (void)onSyncButtonClicked
{
    NSLog(@"onSyncButtonClicked -------- %@", [NSThread currentThread]);
    NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(operationMethod) object:nil];
    [operation start];
}

- (void)onAsyncButtonClicked
{
    NSLog(@"onAsyncButtonClicked -------- %@", [NSThread currentThread]);
    //只有将operation放到一个NSOperationQueue中，才会异步执行操作。
    NSOperationQueue *operationQueue = [[NSOperationQueue alloc] init];
    NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(operationMethod) object:@"这是一个参数"];
    [operationQueue addOperation:operation];
}

- (void)operationMethod
{
    NSLog(@"operationMethod -------- %@", [NSThread currentThread]);
}

- (void)onTestDependencyButtonClicked
{
    NSOperationQueue *operationQueue = [[NSOperationQueue alloc] init];
    NSInvocationOperation *operationA = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(operationMethodA) object:@"这是一个参数"];
    NSInvocationOperation *operationB = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(operationMethodB) object:@"这是一个参数"];
    [operationB addDependency:operationA];
    [operationQueue addOperation:operationA];
    [operationQueue addOperation:operationB];
}

- (void)operationMethodA
{
    [NSThread sleepForTimeInterval:3];
    NSLog(@"operationMethodA -------- %@", [NSThread currentThread]);
}

- (void)operationMethodB
{
    NSLog(@"operationMethodB -------- %@", [NSThread currentThread]);
}

- (void)onTestCancelButtonClicked
{
    //注：这样写时不会立即取消正在执行的任务的，想要立即取消现有任务，似乎必须用自定义的NSOperation子类并且重写main方法--TODO
    NSOperationQueue *operationQueue = [[NSOperationQueue alloc] init];
    NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(operationMethodC) object:nil];
    [operationQueue addOperation:operation];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [operation cancel];
    });
}

- (void)operationMethodC
{
//    [NSThread sleepForTimeInterval:5];
//    NSLog(@"operationMethodC -------- %@", [NSThread currentThread]);
    while (true) {
        sleep(1.0);
        NSLog(@"operationMethodC");
    }
}

- (void)onSuspendButtonClicked
{
    //suspend不能停止正在执行的任务，因此像下面这样写时没用的
    NSOperationQueue *operationQueue = [[NSOperationQueue alloc] init];
    NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(operationMethodC) object:nil];
    [operationQueue addOperation:operation];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSLog(@"suspend");
        operationQueue.suspended = YES;
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSLog(@"resume");
        operationQueue.suspended = NO;
    });
    
}

@end
