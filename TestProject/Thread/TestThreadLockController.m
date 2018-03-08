//
//  TestThreadLockController.m
//  TestProject
//
//  Created by 潘志勇 on 2018/3/7.
//  Copyright © 2018年 pzy. All rights reserved.
//

#import "TestThreadLockController.h"
//#import <objc/objc-sync.h>

@interface TestThreadLockController ()

@end

@implementation TestThreadLockController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    AddButton(YES, 1, @"OSSpinLock");
    AddButton(NO, 1, @"SemaPhore");
    AddButton(YES, 2, @"Pthread_mutex");
    AddButton(NO, 2, @"NSLock");
    AddButton(YES, 3, @"NSCondition");
    AddButton(NO, 3, @"Synchronized");
    AddButton(YES, 4, @"Atomic");
}

- (void)onOSSpinLockButtonClicked
{
    /*  自旋锁可能会造成优先级反转的问题，所以如果不是百分百确认要获取这个锁的线程的优先级都一样的话最好不要用自旋锁  */
}

- (void)onSemaPhoreButtonClicked
{
    
}

- (void)onPthread_mutexButtonClicked
{
    
}

- (void)onNSLockButtonClicked
{
    
}

- (void)onNSConditionButtonClicked
{
    
}

- (void)onSynchronizedButtonClicked
{
    //http://yulingtianxia.com/blog/2015/11/01/More-than-you-want-to-know-about-synchronized/
    //    objc_sync_enter(self);
    //    objc_sync_exit(self);
}

- (void)onAtomicButtonClicked
{
    //Atomic 有两个作用，一个是让属性的setter和getter操作都变成原子性的。第二个是设置Memory Barrier
}

@end
