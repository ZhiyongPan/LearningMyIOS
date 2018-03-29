
//
//  TestUIKitController.m
//  TestProject
//
//  Created by 潘志勇 on 2018/3/29.
//  Copyright © 2018年 pzy. All rights reserved.
//

#import "TestUIKitController.h"
#import "TestViewAndLayerController.h"

@interface TestUIKitController ()

@end

@implementation TestUIKitController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    AddButton(YES, 1, @"ViewAndLayer");
}

- (void)onViewAndLayerButtonClicked
{
    TestViewAndLayerController *controller = [[TestViewAndLayerController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
}

@end
