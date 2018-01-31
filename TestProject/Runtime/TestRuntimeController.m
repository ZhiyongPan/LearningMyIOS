//
//  TestRuntimeController.m
//  TestProject
//
//  Created by 潘志勇 on 2018/1/29.
//  Copyright © 2018年 pzy. All rights reserved.
//

#import "TestRuntimeController.h"
#import "NSObject+PZYKVO.h"
#import "TestVariableParameterObject.h"

@interface TestKVOInfo : NSObject

@property (nonatomic, strong) NSString *name;

@end

@implementation TestKVOInfo

@end

@interface TestRuntimeController ()

@property (nonatomic, strong) TestKVOInfo *info;

@end

@implementation TestRuntimeController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.info = [[TestKVOInfo alloc] init];
    self.info.name = @"oldName";
    [self addTestKVOButton];
    [self addTestVariableParametersButton];
}

- (void)addTestKVOButton
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"KVO" forState:UIControlStateNormal];
    button.backgroundColor = [UIColor redColor];
    button.frame = CGRectMake(0, 100, ButtonWidth, 30.0);
    [button addTarget:self action:@selector(testKVO) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)testKVO
{
    [self.info PZY_addObserver:self forKeyPath:@"name" withBlock:^(id observedObject, NSString * observeKey, id oldValue, id newValue){
        NSLog(@"testKVO oldValue is %@, newValue is %@",oldValue, newValue);
    }];
    self.info.name = @"newName";
}

- (void)addTestVariableParametersButton
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"VariableParameters" forState:UIControlStateNormal];
    button.backgroundColor = [UIColor redColor];
    button.frame = CGRectMake(RightButtonFrameX, 100, ButtonWidth, 30.0);
    [button addTarget:self action:@selector(testVariableParameters) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)testVariableParameters
{
    TestVariableParameterObject *obj = [TestVariableParameterObject objectWithParas:@"zhiyong", @"pan", @"guangzhou", nil];
    NSLog(@"VariableParameters obj is %@",obj);
}

@end
