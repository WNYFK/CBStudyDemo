//
//  CBCFRunLoopViewController.m
//  CBStudyDemo
//
//  Created by ChenBin on 16/8/15.
//  Copyright © 2016年 ChenBin. All rights reserved.
//

#import "CBCFRunLoopViewController.h"
#import "CBThread.h"

@interface CBCFRunLoopViewController ()

@property (nonatomic, strong) dispatch_queue_t queue;
@property (nonatomic, strong) CBThread *thread;

@end

@implementation CBCFRunLoopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.queue = dispatch_queue_create("com.wnyfk.runloop", DISPATCH_QUEUE_CONCURRENT);
    
    UIButton *startBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    startBtn.frame = CGRectMake(10, 50, 150, 40);
    [startBtn setTitle:@"唤醒子线程" forState:UIControlStateNormal];
    [self.view addSubview:startBtn];
    [startBtn addTarget:self action:@selector(wakeUpSubThread) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *wakeUpSourceOneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    wakeUpSourceOneBtn.frame = CGRectMake(200, 50, 150, 40);
    [wakeUpSourceOneBtn setTitle:@"处理sourceOne" forState:UIControlStateNormal];
    [self.view addSubview:wakeUpSourceOneBtn];
    [wakeUpSourceOneBtn addTarget:self action:@selector(wakeUpSourceOne) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *wakeUpSourceTwoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    wakeUpSourceTwoBtn.frame = CGRectMake(10, 200, 150, 40);
    [wakeUpSourceTwoBtn setTitle:@"处理sourceTwo" forState:UIControlStateNormal];
    [self.view addSubview:wakeUpSourceTwoBtn];
    [wakeUpSourceTwoBtn addTarget:self action:@selector(wakeUpSourceTwo) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *invalidateSourceOneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    invalidateSourceOneBtn.frame = CGRectMake(10, 260, 150, 40);
    [invalidateSourceOneBtn setTitle:@"InvalidateSourceOne" forState:UIControlStateNormal];
    [self.view addSubview:invalidateSourceOneBtn];
    [invalidateSourceOneBtn addTarget:self action:@selector(invalidateSourceOne) forControlEvents:UIControlEventTouchUpInside];
    
    self.thread = [[CBThread alloc] initWithTarget:self selector:@selector(threadStart) object:nil];
    [self.thread start];
}

- (void)threadStart {
    NSLog(@"%s", __FUNCTION__);
}

- (void)wakeUpSubThread {
//    [self.thread performSelector:@selector(wakeUpRunLoop) withObject:nil];
    [self.thread performSelector:@selector(wakeUpRunLoop) onThread:self.thread withObject:nil waitUntilDone:NO];
}

- (void)wakeUpSourceOne {
    [self.thread performSelector:@selector(wakeUpSourceOne) onThread:self.thread withObject:nil waitUntilDone:NO];
}

- (void)wakeUpSourceTwo {
    [self.thread performSelector:@selector(wakeUpSourceTwo) onThread:self.thread withObject:nil waitUntilDone:NO];
}

- (void)invalidateSourceOne {
    [self.thread invalidateSourceOne];
}
@end
