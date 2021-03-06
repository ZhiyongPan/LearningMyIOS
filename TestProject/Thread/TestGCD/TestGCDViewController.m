//
//  TestGCDViewController.m
//  TestProject
//
//  Created by pzy on 2017/7/20.
//  Copyright © 2017年 pzy. All rights reserved.
//

/*
 GCD底部维护着一个线程池，不管是Serial Queue还是Concurrent Queue，他们的任务其实都是由这个线程池来管理的，并不是每个Queue管理着一个线程池。
 在Queue中执行任务其实是在他的target Queue中执行的，在创建Queue的时候，不管是Serial Queue还是Concurrent Queue，内部都会调用_dispatch_get_root_queue()方法来获取target Queue，其实就只不过是从 root queue 列表里找一个相应优先级的 root queue，自定义的Queue更像是root Queue的“代理”。其实root Queue其实就是Global Queue，GCD底层目前有15个Global Queue，其中1与主线程相关，定义在init.c; 2、3是内部管理Queue用的，定义在Queue.c; 4、15分别有不同的优先级以及是否是overcommit（带 overcommit 参数的表示该 queue 在执行 block 时，无论系统多忙都会新开一个线程）也是定义在queue.c，其中4、5有点搞不懂是干嘛的。
 既然所有的Queue都共有一个线程池，那么怎么来判断是否要并发呢？这个就是由Queue本身的dq_width字段来决定了，dq_width属性的值就是能够并发执行的最大任务数，concurrent queue的值为DISPATCH_QUEUE_WIDTH_MAX（#define DISPATCH_QUEUE_WIDTH_MAX UINT16_MAX），serial queue的值为1。
*/

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

/*
 dispatch_benchmark
 计算一段代码执行花费的平均时间，在性能测试时很实用
 */

/*
 dispatch_source
 dispatch_source是用来监听一系列时间的接口，常见的有：
 *  DISPATCH_SOURCE_TYPE_DATA_ADD:        n/a
 *  DISPATCH_SOURCE_TYPE_DATA_OR:        n/a
 *  DISPATCH_SOURCE_TYPE_MACH_SEND:      mach port (mach_port_t)
 *  DISPATCH_SOURCE_TYPE_MACH_RECV:      mach port (mach_port_t)
 *  DISPATCH_SOURCE_TYPE_MEMORYPRESSURE  n/a
 *  DISPATCH_SOURCE_TYPE_PROC:            process identifier (pid_t)  //用来监视进程
 *  DISPATCH_SOURCE_TYPE_READ:            file descriptor (int)
 *  DISPATCH_SOURCE_TYPE_SIGNAL:          signal number (int)
 *  DISPATCH_SOURCE_TYPE_TIMER:          n/a
 *  DISPATCH_SOURCE_TYPE_VNODE:          file descriptor (int)    //------用来监视文件变动的事件，例如文件被写入或删除
 *  DISPATCH_SOURCE_TYPE_WRITE:          file descriptor (int)
 其中DISPATCH_SOURCE_TYPE_TIMER可以用来创建计时器
 */

/*
 dispatch的底层实现方式
 dispatch_async异步,dispatch_async会判断相关队列时什么队列，如果是并发队列，就使用链表来存储提交的任务block，然后在底层线程池中一次取出block来执行。如果是串行队列，则转到dispatch_barrier_async_f执行。
 dispatch_sync同步，同步的话不管是什么队列都会在当前线程执行，在执行的时候会使用信号量来保证每次只有一个任务被执行
 */

/*
 
 */

#import "TestGCDViewController.h"
#import<libkern/OSAtomic.h>

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
    
    [self addBenchmarkButton];
    
    [self addSourceTimerButton];
    
    AddButton(NO, 4, @"TestDeadLock");
    AddButton(YES, 5, @"QoS");
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

- (void)addBenchmarkButton
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"Benchmark" forState:UIControlStateNormal];
    button.backgroundColor = [UIColor redColor];
    button.frame = CGRectMake(RightButtonFrameX, ButtonFrameY(3), ButtonWidth, ButtonHeight);
    [button addTarget:self action:@selector(onBenchmarkButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)onBenchmarkButtonClicked
{
    //计算把1000个对象加到array里面费时，计算10000遍求平均时间
    size_t const size = 1000;
    uint64_t dispatch_benchmark(size_t count, void (^block)(void));
    NSLog(@"bench mark begin");
    uint64_t n = dispatch_benchmark(10000, ^{
        @autoreleasepool {
            id obj = @42;
            NSMutableArray *array = [NSMutableArray array];
            for (size_t i = 0; i < size; i++) {
                [array addObject:obj];
            }
        }
    });
    NSLog(@"cost %@", @(n));
    NSLog(@"bench mark end");
}

- (void)addSourceTimerButton
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"SourceTimer" forState:UIControlStateNormal];
    button.backgroundColor = [UIColor redColor];
    button.frame = CGRectMake(0, ButtonFrameY(4), ButtonWidth, ButtonHeight);
    [button addTarget:self action:@selector(onSourceTimerButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)onSourceTimerButtonClicked
{
    __block uint64_t timeOutCount = 10;
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
    dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC, 0);//注：最后一个参数是一个余地值，按我的理解应该就是精确度能容忍的范围。注意：如果不必要地指定了一个低余地值会比较费电
    dispatch_source_set_event_handler(timer, ^{
        OSAtomicDecrement64(&timeOutCount);
        NSLog(@"timeOutCount : %@", @(timeOutCount));
        if (timeOutCount == 0) {
            dispatch_source_cancel(timer);
        }
    });
    dispatch_source_set_cancel_handler(timer, ^{
        
        NSLog(@"source timer canceled");
    });
    dispatch_resume(timer);
    dispatch_get_specific("key");
}

- (void)onTestDeadLockButtonClicked
{
    dispatch_queue_t serialQueue = dispatch_queue_create("com.pzy.TestDeaLockSerial", DISPATCH_QUEUE_SERIAL);
    dispatch_queue_t serialQueue2 = dispatch_queue_create("com.pzy.TestDeaLockSerial2", DISPATCH_QUEUE_SERIAL);
    NSLog(@"onTestDeadLockButtonClicked, %@", [NSThread currentThread]);
    dispatch_sync(serialQueue, ^{
        NSLog(@"serialQueue, %@", [NSThread currentThread]);
        dispatch_sync(serialQueue2, ^{
            NSLog(@"serialQueue2, %@", [NSThread currentThread]);
        });
    });//不死锁

    dispatch_sync(serialQueue, ^{
        NSLog(@"serialQueue, %@", [NSThread currentThread]);
        dispatch_sync(serialQueue, ^{
            NSLog(@"serialQueue2, %@", [NSThread currentThread]);
        });
    });//死锁
    
    //注：将serialQueue2换成serialQueue就换造成死锁。因为serialQueue是一个串行队列，队列中的任务只能一个个执行，而在用同步的方法将block添加到串行队列中时会阻塞当前队列。而最外层的block运行在serialQueue，当将内层block再添加到serialQueue时，外层block任务会阻塞等内层block执行完再继续往下执行，但是内层block是加在外层block后面的，必须等到外层block执行完它才能执行，就造成了互相等待形成死锁。
    //注：只有使用同步方法将任务加到串行队列才会阻塞这个队列，使用同步方法加任务到并发队列并不会阻塞这个并发队列
    
    //特别注意：像下面这样写也会导致死锁
    dispatch_set_target_queue(serialQueue2, serialQueue);
    dispatch_sync(serialQueue, ^{
        NSLog(@"serialQueue, %@", [NSThread currentThread]);
        dispatch_sync(serialQueue2, ^{
            NSLog(@"serialQueue2, %@", [NSThread currentThread]);
        });
    });//死锁
    
    dispatch_queue_t gQueue1 = dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0);
    dispatch_queue_t gQueue2 = dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0);
    dispatch_sync(gQueue1, ^{
        NSLog(@"gQueue1, %@", [NSThread currentThread]);
        dispatch_sync(gQueue2, ^{
            NSLog(@"gQueue2, %@", [NSThread currentThread]);
        });
    });//不死锁,因为globalQueue是并发队列
    
    dispatch_queue_t serialQueue3 = dispatch_queue_create("com.pzy.TestDeaLockSerial3", DISPATCH_QUEUE_SERIAL);
    dispatch_set_target_queue(serialQueue3, serialQueue);
    dispatch_sync(serialQueue3, ^{
        NSLog(@"gQueue3, %@", [NSThread currentThread]);
        dispatch_sync(serialQueue2, ^{
            NSLog(@"serialQueue2, %@", [NSThread currentThread]);
        });
    });//死锁
}

- (void)onQoSButtonClicked
{
    dispatch_queue_t globalQueue = dispatch_get_global_queue(QOS_CLASS_DEFAULT, 0);
    dispatch_queue_t queue = dispatch_queue_create("com.pzy.TestQoS", DISPATCH_QUEUE_CONCURRENT);
    dispatch_queue_t queue2 = dispatch_queue_create_with_target("com.pzy.TestQoS2", DISPATCH_QUEUE_CONCURRENT, DISPATCH_TARGET_QUEUE_DEFAULT);
    NSLog(@"");
    //这边不知道怎么获取queue的属性信息，要不然可以看看这两个的targetQueue是不是一样的。
}

/************    线程安全     ***********************/
/* 如何保证线程安全 */

@end
