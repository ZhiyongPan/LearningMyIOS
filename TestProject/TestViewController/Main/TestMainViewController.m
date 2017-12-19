//
//  TestMainViewController.m
//  TestProject
//
//  Created by pzy on 2017/8/14.
//  Copyright © 2017年 pzy. All rights reserved.
//

#import "TestMainViewController.h"
#include <mach/task.h>
#include <mach/thread_act.h>
#include <mach/mach_init.h>
#include <mach/mach_port.h>
#import <pthread.h>

mach_port_t myExceptionPort = 0;

@interface TestMainViewController ()

@end

@implementation TestMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSArray *array = [[NSArray alloc] init];
//    NSInteger count = [array count];
    int count = 0;
    int index = 10 / 0;
    NSLog(@"/0 index is %@", @(index));
}
@end
