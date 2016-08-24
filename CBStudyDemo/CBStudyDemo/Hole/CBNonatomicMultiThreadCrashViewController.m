//
//  CBNonatomicMultiThreadCrashViewController.m
//  CBStudyDemo
//
//  Created by ChenBin on 16/8/24.
//  Copyright © 2016年 ChenBin. All rights reserved.
//

#import "CBNonatomicMultiThreadCrashViewController.h"

@interface CBNonatomicMultiThreadCrashViewController ()

@property (nonatomic, strong) NSObject *obj1;

@property (atomic, strong) NSObject *obj2;

@end

@implementation CBNonatomicMultiThreadCrashViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *startBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    startBtn.frame = CGRectMake(50, 100, 100, 60);
    [startBtn setTitle:@"nonatomic" forState:UIControlStateNormal];
    [startBtn addTarget:self action:@selector(runNonatomic) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:startBtn];
    
    UIButton *atomicBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    atomicBtn.frame = CGRectMake(50, 200, 100, 60);
    [atomicBtn setTitle:@"atomic" forState:UIControlStateNormal];
    [atomicBtn addTarget:self action:@selector(runAtomic) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:atomicBtn];
}

- (void)runNonatomic {
    dispatch_async(dispatch_queue_create("com.chenbin.nonatomic.queue1", DISPATCH_QUEUE_CONCURRENT), ^{
        [self writeNonatomicProperty];
    });
    dispatch_async(dispatch_queue_create("com.chenbin.nonatomic.queue2", DISPATCH_QUEUE_CONCURRENT), ^{
        [self writeNonatomicProperty];
    });
    dispatch_async(dispatch_queue_create("com.chenbin.nonatomic.queue3", DISPATCH_QUEUE_CONCURRENT), ^{
        [self writeNonatomicProperty];
    });
    dispatch_async(dispatch_queue_create("com.chenbin.nonatomic.queue4", DISPATCH_QUEUE_CONCURRENT), ^{
        [self writeNonatomicProperty];
    });
    dispatch_async(dispatch_queue_create("com.chenbin.nonatomic.queue5", DISPATCH_QUEUE_CONCURRENT), ^{
        [self writeNonatomicProperty];
    });
    dispatch_async(dispatch_queue_create("com.chenbin.nonatomic.queue6", DISPATCH_QUEUE_CONCURRENT), ^{
        [self writeNonatomicProperty];
    });
    dispatch_async(dispatch_queue_create("com.chenbin.nonatomic.queue7", DISPATCH_QUEUE_CONCURRENT), ^{
        [self writeNonatomicProperty];
    });
    dispatch_async(dispatch_queue_create("com.chenbin.nonatomic.queue8", DISPATCH_QUEUE_CONCURRENT), ^{
        [self writeNonatomicProperty];
    });
}

- (void)runAtomic {
    dispatch_async(dispatch_queue_create("com.chenbin.atomic.queue1", DISPATCH_QUEUE_CONCURRENT), ^{
        [self writeAtomicProperty];
    });
    dispatch_async(dispatch_queue_create("com.chenbin.atomic.queue2", DISPATCH_QUEUE_CONCURRENT), ^{
        [self writeAtomicProperty];
    });
    dispatch_async(dispatch_queue_create("com.chenbin.atomic.queue3", DISPATCH_QUEUE_CONCURRENT), ^{
        [self writeAtomicProperty];
    });
    dispatch_async(dispatch_queue_create("com.chenbin.atomic.queue4", DISPATCH_QUEUE_CONCURRENT), ^{
        [self writeAtomicProperty];
    });
    dispatch_async(dispatch_queue_create("com.chenbin.atomic.queue5", DISPATCH_QUEUE_CONCURRENT), ^{
        [self writeAtomicProperty];
    });
    dispatch_async(dispatch_queue_create("com.chenbin.atomic.queue6", DISPATCH_QUEUE_CONCURRENT), ^{
        [self writeAtomicProperty];
    });
    dispatch_async(dispatch_queue_create("com.chenbin.atomic.queue7", DISPATCH_QUEUE_CONCURRENT), ^{
        [self writeAtomicProperty];
    });
    dispatch_async(dispatch_queue_create("com.chenbin.atomic.queue8", DISPATCH_QUEUE_CONCURRENT), ^{
        [self writeAtomicProperty];
    });
}

- (void)writeNonatomicProperty {
    for (int i = 0; i < 1000; i++) {
        self.obj1 = [NSObject new];
    }
}

- (void)writeAtomicProperty {
    for (int i = 0; i < 1000; i++) {
        self.obj2 = [NSObject new];
    }
}

@end
