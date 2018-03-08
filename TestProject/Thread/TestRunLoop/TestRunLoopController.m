//
//  TestRunLoopController.m
//  TestProject
//
//  Created by 潘志勇 on 2018/3/8.
//  Copyright © 2018年 pzy. All rights reserved.
//

#import "TestRunLoopController.h"

@interface TestRunLoopController ()

@end

@implementation TestRunLoopController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    AddButton(YES, 1, @"Observer");
    
}

- (void)onObserverButtonClicked
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        CFRunLoopRef myRunLoopRef = CFRunLoopGetCurrent();
        CFRunLoopObserverContext context = {0, CFBridgingRetain(self), NULL, NULL, NULL};
        CFRunLoopObserverRef observer = CFRunLoopObserverCreate(kCFAllocatorDefault,kCFRunLoopAllActivities, YES, 0, &MyRunLoopObserver, &context);
        if (observer) {
            CFRunLoopRef cfLoop = myRunLoopRef;
            CFRunLoopAddObserver(cfLoop, observer, kCFRunLoopDefaultMode);
        }
        NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(show) userInfo:nil repeats:YES];
        NSInteger loopCount = 3;
        do {
            [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:5]];
            loopCount--;
            NSLog(@"LoopCount : %lu", loopCount);
        } while (loopCount);
        // [timer invalidate];
        //timer = nil;
        printf("myRunLoopRef: %p\n", myRunLoopRef);
        printf("CFRunLoopGetCurrent: %p\n", CFRunLoopGetCurrent());
        CFRunLoopStop(myRunLoopRef);
        printf("timer: %p\n", timer);
    });
}

void MyRunLoopObserver(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void* info) {
    // Perform your tasks here.
    switch (activity) {
        case kCFRunLoopEntry:
            NSLog(@"RunLoop 进入");
            break;
        case kCFRunLoopBeforeTimers:
            NSLog(@"即将处理 Timer");
            break;
        case kCFRunLoopBeforeSources:
            NSLog(@"即将处理 Input Sources");
            break;
        case kCFRunLoopBeforeWaiting:
            NSLog(@"即将睡眠");
            break;
        case kCFRunLoopAfterWaiting:
            NSLog(@"从睡眠中唤醒,处理完唤醒源之前");
            break;
        case kCFRunLoopExit:
            NSLog(@"退出");
            break;
        default:
            break;
    }
}

- (void)show
{
    NSLog(@"show");
}

@end
