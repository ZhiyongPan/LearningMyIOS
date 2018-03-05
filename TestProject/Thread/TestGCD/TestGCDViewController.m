//
//  TestGCDViewController.m
//  TestProject
//
//  Created by pzy on 2017/7/20.
//  Copyright © 2017年 pzy. All rights reserved.
//

/*!
 dispatch_group
 将一些任务打包成一个group，当成一个组
 这里面有两个最重要的API：1、dispatch_group_notify，这个方法里的Block会在整个group里面的任务都执行完了之后执行，也就是说可以用这个来进行汇总，比如说一个任务需要在前两个任务都执行好了之后再执行，就可以用这个来完成；2、dispatch_wait,这个用来检查group里面的任务执行情况，注意：这个API会阻塞当前线程，也就是执行了这个API之后，当前线程就会只执行group里面的任务，直到API中设置的时间，API中设置的时间是一个dispatch_time，如果这个参数是DISPATCH_TIME_FOREVER，那么当前线程就会阻塞到group里面的任务全部执行完成
 */

/*!
 dispatch_suspend和dispatch_resume
 dispatch_suspend并不能暂停当前的任务，只能暂停开始执行的任务。比如说往一个串行队列中加入两个Block任务，block1和block2,目前正在执行block1，这个时候调用suspend，并不能停止block1,只是会在block1执行完后不会马上执行block2，而是在调用resume之后才会再执行block2
 */

/*
 dispatch_barrier
 它起到一个承上启下的作用，在他之前的任务都在他之前执行，在他之后的任务都在他之后执行
 */

#import "TestGCDViewController.h"

@interface TestGCDViewController ()

@property (nonatomic, assign) BOOL createdQueue;
@property (nonatomic, assign) BOOL gcdSuspend;
@property (nonatomic, assign) dispatch_semaphore_t semaphore;

@end

@implementation TestGCDViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self addTestGroupButton];
    
    [self addGCDStatusButton];
    
    [self addBarrierButton];
    
    [self addSemaphoreButton];
    
    [self addCreateButton];
}

- (void)addTestGroupButton
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"GCD_Group" forState:UIControlStateNormal];
    button.backgroundColor = [UIColor redColor];
    button.frame = CGRectMake(0, 100, ButtonWidth, 30.0);
    [button addTarget:self action:@selector(onGCDGroupButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)onGCDGroupButtonClicked
{
    [self testGCD_Group];
}

- (void)testGCD_Group
{
    NSLog(@"beginTestGCD_Group");
    dispatch_queue_t disqueue =  dispatch_queue_create("com.pzy.GCDStudy", DISPATCH_QUEUE_CONCURRENT);
    dispatch_queue_t disqueue2 =  dispatch_queue_create("com.pzy.GCDStudy2", DISPATCH_QUEUE_CONCURRENT);
    dispatch_group_t disgroup = dispatch_group_create();
    dispatch_group_async(disgroup, disqueue, ^{
        sleep(2);
        NSLog(@"任务一完成");
    });
    dispatch_group_async(disgroup, disqueue2, ^{
        sleep(8);
        NSLog(@"任务二完成");
    });
    dispatch_group_notify(disgroup, disqueue, ^{
        NSLog(@"dispatch_group_notify 执行");
    });
    long result = dispatch_wait(disgroup, dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)));
    NSLog(@"result is %@", @(result));
    NSLog(@"endTestGCD_Group");
}

- (void)addGCDStatusButton
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"Begin" forState:UIControlStateNormal];
    button.backgroundColor = [UIColor redColor];
    button.frame = CGRectMake(RightButtonFrameX, 100, ButtonWidth, 30.0);
    [button addTarget:self action:@selector(onGCDStatusButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)onGCDStatusButtonClicked:(UIButton *)button
{
//    dispatch_queue_t queue = dispatch_queue_create("com.pzy.TestGCDStatusQueue", DISPATCH_QUEUE_CONCURRENT);
//    if (!self.createdQueue) {
//        self.createdQueue = YES;
//        dispatch_async(queue, ^{
//            while (true) {
//                NSLog(@"%@", [NSDate date]);
//            }
//        });
//    } else {
//        if (self.gcdSuspend) {
//            dispatch_resume(queue);
//        } else {
//            dispatch_suspend(queue);
//            self.gcdSuspend = YES;
//        }
//    }
    /** 注：像上面这样是不行的，因为suspend并不能停止执行中的任务 **/
    
    dispatch_queue_t queue = dispatch_queue_create("com.pzy.TestGCDStatusQueue", DISPATCH_QUEUE_SERIAL);
    dispatch_async(queue, ^{
        [NSThread sleepForTimeInterval:5];
        NSLog(@"五秒后打印，队列挂起时已经开始执行，");
    });
    //提交第二个block，也是延时5秒打印
    dispatch_async(queue, ^{
        [NSThread sleepForTimeInterval:5];
        NSLog(@"队列挂起时未执行，需恢复队列后在执行");
    });
    
    NSLog(@"立刻打印~~~~~~~");
    [NSThread sleepForTimeInterval:2];
    //挂起队列
    NSLog(@"2秒后打印，队列挂起");
    dispatch_suspend(queue);
    /** 注：因为这个是一个串行队列，所以是先进先出，先执行第一个block1，再执行block2，所以这个时候调用suspend因为block1还在执行，所以不会停止，当block1的任务执行完后不会执行block2 **/
    //延时10秒
    [NSThread sleepForTimeInterval:10];
    NSLog(@"十秒后打印，开启队列");
    //恢复队列
    dispatch_resume(queue);
    /** 注：这个时候调用了resume之后，才会执行block2 **/
}

- (void)addBarrierButton
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"Barrier" forState:UIControlStateNormal];
    button.backgroundColor = [UIColor redColor];
    button.frame = CGRectMake(0, ButtonFrameY(2), ButtonWidth, ButtonHeight);
    [button addTarget:self action:@selector(onBarrierButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)onBarrierButtonClicked
{
    dispatch_queue_t queue = dispatch_queue_create("com.pzy.TestBarrierQueue", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(queue, ^{
        [NSThread sleepForTimeInterval:3];
        NSLog(@"Write 1");
    });
    dispatch_async(queue, ^{
        [NSThread sleepForTimeInterval:3];
        NSLog(@"Write 2");
    });
    
    dispatch_barrier_async(queue, ^{
        [NSThread sleepForTimeInterval:2];
        NSLog(@"barrier");
    });
    
    dispatch_async(queue, ^{
        [NSThread sleepForTimeInterval:2];
        NSLog(@"Read 1");
    });
    dispatch_async(queue, ^{
        [NSThread sleepForTimeInterval:2];
        NSLog(@"Read 2");
    });
}

- (void)addSemaphoreButton
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"Semaphore_wait" forState:UIControlStateNormal];
    button.backgroundColor = [UIColor redColor];
    button.frame = CGRectMake(RightButtonFrameX, ButtonFrameY(2), ButtonWidth, ButtonHeight);
    [button addTarget:self action:@selector(onSemaphoreButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)onSemaphoreButtonClicked
{
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    self.semaphore = semaphore;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(dispatch_queue_create("com.pzy.TestSemaphore", DISPATCH_QUEUE_CONCURRENT), ^{
        for (int i = 0; i < 9; i++) {
            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
            dispatch_async(queue, ^{
                NSLog(@"onSemphoreButtonClicked %@", @(i));
            });
        }
    });
}

- (void)addCreateButton
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"Semaphore_signal" forState:UIControlStateNormal];
    button.backgroundColor = [UIColor redColor];
    button.frame = CGRectMake(0, ButtonFrameY(3), ButtonWidth, ButtonHeight);
    [button addTarget:self action:@selector(onCreateButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)onCreateButtonClicked
{
    dispatch_semaphore_signal(self.semaphore);
}

@end
