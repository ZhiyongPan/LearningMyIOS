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

void sig_handler(int sig, siginfo_t *info, void *context)
{
    printf("sig_handler");
    ucontext_t *ucontext = context;
    NSMutableString *str = [NSMutableString stringWithFormat:@"Signal caught: %d \n",sig];

    [str appendString:[NSString stringWithFormat:@"pc 0x%llx\n", ucontext->uc_mcontext->__ss.__pc]];
    [str appendString:[NSString stringWithFormat:@"lr 0x%llx\n", ucontext->uc_mcontext->__ss.__lr]];
    [str appendString:[NSString stringWithFormat:@"fp 0x%llx\n", ucontext->uc_mcontext->__ss.__fp]];
    [str appendString:[NSString stringWithFormat:@"sp 0x%llx\n", ucontext->uc_mcontext->__ss.__sp]];
    [str appendString:[NSString stringWithFormat:@"uc_stack size 0x%lx\n", sizeof(ucontext->uc_stack.ss_size)]];
    [str appendString:[NSString stringWithFormat:@"uc_stack ss_sp 0x%llx\n", (long long)ucontext->uc_stack.ss_sp]];


    if (ucontext->uc_link != NULL)
    {
        [str appendString:@"uc_link : \n"];
        [str appendString:[NSString stringWithFormat:@"pc 0x%llx\n", ucontext->uc_link->uc_mcontext->__ss.__pc]];
        [str appendString:[NSString stringWithFormat:@"lr 0x%llx\n", ucontext->uc_link->uc_mcontext->__ss.__lr]];
        [str appendString:[NSString stringWithFormat:@"fp 0x%llx\n", ucontext->uc_link->uc_mcontext->__ss.__fp]];
        [str appendString:[NSString stringWithFormat:@"sp 0x%llx\n", ucontext->uc_link->uc_mcontext->__ss.__sp]];
    }
    else
    {
        [str appendString:@"uc_link is null"];
    }
    NSLog(@"%@",str);
    ucontext->uc_mcontext->__ss.__pc = ucontext->uc_mcontext->__ss.__lr;
}

mach_port_t myExceptionPort = 0;

@interface TestMainViewController ()

@end

@implementation TestMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    int ret = task_set_exception_ports(
//                                       mach_task_self(),
//                                       EXC_MASK_BAD_ACCESS,
//                                       MACH_PORT_NULL,//m_exception_port,
//                                       EXCEPTION_DEFAULT,
//                                       0);
//    if (ret == 0)NSLog(@"Disable lldb to catch exceptions");
//    struct sigaction sa;
//    memset(&sa, 0, sizeof(struct sigaction));
//    sa.sa_flags = SA_SIGINFO;
//    sa.sa_sigaction = sig_handler;
//
//    sigaction(SIGSEGV, &sa, NULL);
//    sigaction(SIGINT, &sa, NULL);
//    sigaction(SIGABRT, &sa, NULL);
//    sigaction(SIGKILL, &sa, NULL);
//    sigaction(SIGBUS, &sa, NULL);
//
//    [self invokeCrash];
//    NSLog(@"Resume after crash");
    
    catchMACHExceptions();
    
    NSArray *array = @[@"1", @"2", @"3"];
    NSMutableArray *mArray = [[NSMutableArray alloc] initWithArray:array];
    [mArray release];
    [mArray addObject:@"4"];
}

//- (void)invokeCrash
//{
//    void *a = calloc(1, sizeof(void *));
//    NSLog(@"Crash Addr of a: 0x%llx", (long long)a);
//    ((void(*)())a)();
//}
void catchMACHExceptions() {
    
    kern_return_t rc = 0;
    exception_mask_t excMask = EXC_MASK_BAD_ACCESS |
    EXC_MASK_BAD_INSTRUCTION |
    EXC_MASK_ARITHMETIC |
    EXC_MASK_SOFTWARE |
    EXC_MASK_BREAKPOINT;
    
    rc = mach_port_allocate(mach_task_self(), MACH_PORT_RIGHT_RECEIVE, &myExceptionPort);
    if (rc != KERN_SUCCESS) {
        fprintf(stderr, "------->Fail to allocate exception port\\\\\\\\n");
        return;
    }
    
    rc = mach_port_insert_right(mach_task_self(), myExceptionPort, myExceptionPort, MACH_MSG_TYPE_MAKE_SEND);
    if (rc != KERN_SUCCESS) {
        fprintf(stderr, "-------->Fail to insert right");
        return;
    }
    
    rc = thread_set_exception_ports(mach_thread_self(), excMask, myExceptionPort, EXCEPTION_DEFAULT, MACHINE_THREAD_STATE);
    if (rc != KERN_SUCCESS) {
        fprintf(stderr, "-------->Fail to  set exception\\\\\\\\n");
        return;
    }
    
    // at the end of catchMachExceptions, spawn the exception handling thread
    pthread_t thread;
//    pthread_create(&thread, NULL, exc_handler, NULL);
    pthread_create(&thread, NULL, sig_handler, NULL);
} // end catchMACHExceptions

static void *exc_handler(void *ignored) {
    // Exception handler – runs a message loop. Refactored into a standalone function
    // so as to allow easy insertion into a thread (can be in same program or different)
    mach_msg_return_t rc;
    fprintf(stderr, "Exc handler listening\\\\\\\\n");
    // The exception message, straight from mach/exc.defs (following MIG processing) // copied here for ease of reference.
    typedef struct {
        mach_msg_header_t Head;
        /* start of the kernel processed data */
        mach_msg_body_t msgh_body;
        mach_msg_port_descriptor_t thread;
        mach_msg_port_descriptor_t task;
        /* end of the kernel processed data */
        NDR_record_t NDR;
        exception_type_t exception;
        mach_msg_type_number_t codeCnt;
        integer_t code[2];
        int flavor;
        mach_msg_type_number_t old_stateCnt;
        natural_t old_state[144];
    } Request;
    
    Request exc;
    
    
    struct rep_msg {
        mach_msg_header_t Head;
        NDR_record_t NDR;
        kern_return_t RetCode;
    } rep_msg;
    
    
//    for(;;) {
        // Message Loop: Block indefinitely until we get a message, which has to be
        // 这里会阻塞，直到接收到exception message，或者线程被中断。
        // an exception message (nothing else arrives on an exception port)
        rc = mach_msg( &exc.Head,
                      MACH_RCV_MSG|MACH_RCV_LARGE,
                      0,
                      sizeof(Request),
                      myExceptionPort, // Remember this was global – that's why.
                      MACH_MSG_TIMEOUT_NONE,
                      MACH_PORT_NULL);
        
        if(rc != MACH_MSG_SUCCESS) {
            /*... */
//            break ;
        };
        
        
        // Normally we would call exc_server or other. In this example, however, we wish
        // to demonstrate the message contents:
        
        printf("Got message %d. Exception : %d Flavor: %d. Code %lld/%lld. State count is %d\\\\\\\\n" ,
               exc.Head.msgh_id, exc.exception, exc.flavor,
               exc.code[0], exc.code[1], // can also print as 64-bit quantity
               exc.old_stateCnt);
        
        rep_msg.Head = exc.Head;
        rep_msg.NDR = exc.NDR;
        rep_msg.RetCode = KERN_FAILURE;
        
        kern_return_t result;
        if (rc == MACH_MSG_SUCCESS) {
            result = mach_msg(&rep_msg.Head,
                              MACH_SEND_MSG,
                              sizeof (rep_msg),
                              0,
                              MACH_PORT_NULL,
                              MACH_MSG_TIMEOUT_NONE,
                              MACH_PORT_NULL);
        }
//    }
    
    return  NULL;
    
} // end exc_handler

@end
