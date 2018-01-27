//
//  TestMemoryController.m
//  TestProject
//
//  Created by 潘志勇 on 2018/1/26.
//  Copyright © 2018年 pzy. All rights reserved.
//

#import "TestMemoryController.h"
#import "TestAutoreleasePoolObject.h"

@interface TestMemoryController ()

@end

@implementation TestMemoryController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self addTestButton];
}

- (void)addTestButton
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"Test" forState:UIControlStateNormal];
    button.backgroundColor = [UIColor redColor];
    button.frame = CGRectMake(SCREEN_WIDTH / 3.0, 100, SCREEN_WIDTH / 3.0, 30.0);
    [button addTarget:self action:@selector(testAutoreleasePool) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)testAutoreleasePool
{
    
    
//    [self testMuchObjInMainThread];
//    return;
    
    NSThread *thread = [[NSThread alloc] initWithTarget:self selector:@selector(testAutoreleasePoolInSecondryThread) object:nil];
    [thread start];
   
    return;
    
    
    @autoreleasepool {
        
        [self printTestObject];
        NSLog(@"testAutoreleasePool");
    }
    NSLog(@"autoreleasePool end");
    @autoreleasepool {
    TestAutoreleasePoolObject *obj = [self testRetureObj];
    NSLog(@"testRetureObj is %@", obj);
    __autoreleasing TestAutoreleasePoolObject *obj2 = [TestAutoreleasePoolObject testAutoreleasePoolObjectWithName:@"testRetureObj2"];
    TestAutoreleasePoolObject *obj3 = [[TestAutoreleasePoolObject alloc] initWithName:@"testRetureObj3"];
    TestAutoreleasePoolObject *obj4 = [[TestAutoreleasePoolObject alloc] initWithName:@"testRetureObj4"];
    __autoreleasing TestAutoreleasePoolObject *obj5 = [TestAutoreleasePoolObject testAutoreleasePoolObjectWithName:@"testRetureObj5"];
        if (obj2 && obj3 && obj4 && obj5) {
            
        }
    }
    
    __autoreleasing TestAutoreleasePoolObject *obj6 = [TestAutoreleasePoolObject testAutoreleasePoolObjectWithName:@"testRetureObj6"];
    TestAutoreleasePoolObject *obj7 = [TestAutoreleasePoolObject testAutoreleasePoolObjectWithName:@"testRetureObj7"];
    if (obj6 && obj7) {
        
    }
    NSLog(@"testAutoreleasePool end");
}

//测试在主线程中大量生成对象，添加了__autoreleasing之后，对象被放到总AutoreleasePool中，在runloop结束前释放，使用@autoreleasepool就会在出了作用域前释放
- (void)testMuchObjInMainThread
{
    for (int i = 0; i < 10000; i ++) {
        @autoreleasepool {
            __autoreleasing TestAutoreleasePoolObject *testObj = [TestAutoreleasePoolObject testAutoreleasePoolObjectWithName:[NSString stringWithFormat:@"testObj %d", i]];
            NSLog(@"%@", testObj.name);
        }
    }
}

//测试在子线程中大量生成对象，添加了__autoreleasing之后，对象被放到总AutoreleasePool中，在runloop结束前释放，使用@autoreleasepool就会在出了作用域前释放
- (void)testAutoreleasePoolInSecondryThread
{
    for (int i = 0; i < 10000; i ++) {
//        @autoreleasepool {
            __autoreleasing TestAutoreleasePoolObject *testObj = [TestAutoreleasePoolObject testAutoreleasePoolObjectWithName:[NSString stringWithFormat:@"testObj %d", i]];
            NSLog(@"%@", testObj.name);
//        }
    }
    
    sleep(5);
}

- (void)printTestObject
{
    TestAutoreleasePoolObject *obj1 = [[TestAutoreleasePoolObject alloc] initWithName:@"obj1"];
    TestAutoreleasePoolObject *obj2 = [TestAutoreleasePoolObject testAutoreleasePoolObjectWithName:@"obj2"];
    
    __autoreleasing TestAutoreleasePoolObject *obj3 = [[TestAutoreleasePoolObject alloc] initWithName:@"obj3"];
    __autoreleasing TestAutoreleasePoolObject *obj4 = [TestAutoreleasePoolObject testAutoreleasePoolObjectWithName:@"obj4"];
    
    NSLog(@"obj1 is %@, obj2 is %@",obj1.name, obj2.name);
    NSLog(@"obj3 is %@, obj4 is %@",obj3.name, obj4.name);
}

- (TestAutoreleasePoolObject *)testRetureObj
{
    TestAutoreleasePoolObject *obj = [TestAutoreleasePoolObject testAutoreleasePoolObjectWithName:@"testRetureObj"];
    return obj;
}

@end
