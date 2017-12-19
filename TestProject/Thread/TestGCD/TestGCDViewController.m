//
//  TestGCDViewController.m
//  TestProject
//
//  Created by pzy on 2017/7/20.
//  Copyright © 2017年 pzy. All rights reserved.
//

#import "TestGCDViewController.h"

@interface TestGCDViewController ()

@end

@implementation TestGCDViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self testGCD_Group];
}

- (void)testGCD_Group
{
    NSLog(@"beginTestGCD_Group");
    dispatch_queue_t disqueue =  dispatch_queue_create("com.pzy.NetWorkStudy", DISPATCH_QUEUE_CONCURRENT);
    dispatch_group_t disgroup = dispatch_group_create();
    dispatch_group_async(disgroup, disqueue, ^{
        sleep(2);
        NSLog(@"任务一完成");
    });
    dispatch_group_async(disgroup, disqueue, ^{
        sleep(8);
        NSLog(@"任务二完成");
    });
    dispatch_group_notify(disgroup, disqueue, ^{
        NSLog(@"dispatch_group_notify 执行");
    });
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        dispatch_group_wait(disgroup, dispatch_time(DISPATCH_TIME_NOW, 5 * NSEC_PER_SEC));
        NSLog(@"dispatch_group_wait 结束");
    });
}

@end
