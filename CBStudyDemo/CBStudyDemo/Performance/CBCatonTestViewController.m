//
//  CBCatonTestViewController.m
//  CBStudyDemo
//
//  Created by ChenBin on 16/8/25.
//  Copyright © 2016年 ChenBin. All rights reserved.
//

#import "CBCatonTestViewController.h"

@implementation CBCatonTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *startBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [startBtn setTitle:@"开始" forState:UIControlStateNormal];
    [startBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    startBtn.frame = CGRectMake(100, 100, 200, 60);
    [startBtn addTarget:self action:@selector(startBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:startBtn];
    
    UIButton *deadlockMainBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [deadlockMainBtn setTitle:@"主线程死锁" forState:UIControlStateNormal];
    [deadlockMainBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    deadlockMainBtn.frame = CGRectMake(100, 200, 200, 60);
    [deadlockMainBtn addTarget:self action:@selector(deadlockMainQueue) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:deadlockMainBtn];
    
    UIButton *deadlockSubQueueBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    deadlockSubQueueBtn.frame = CGRectMake(100, 300, 200, 60);
    [deadlockSubQueueBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [deadlockSubQueueBtn setTitle:@"子线程死锁" forState:UIControlStateNormal];
    [deadlockSubQueueBtn addTarget:self action:@selector(deadlockSubQueue) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:deadlockSubQueueBtn];
    
}

- (void)deadlockMainQueue {
    dispatch_queue_t queue = dispatch_get_main_queue();
    dispatch_async(queue, ^{
        dispatch_sync(queue, ^{
        });
    });

}

- (void)deadlockSubQueue {
    dispatch_queue_t queue = dispatch_queue_create("com.chenbin.subQueue", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(queue, ^{
       dispatch_sync(queue, ^{
       });
    });
}

- (void)startBtnClicked:(UIButton *)btn {
    dispatch_async(dispatch_queue_create("com.chenbin.queue2", DISPATCH_QUEUE_CONCURRENT), ^{
        int i = 0;
        while (YES) {
            i++;
            if (i % 10000 == 0){
                sleep(1);
            }
        }
    });
    dispatch_async(dispatch_queue_create("com.chenbin.queue3", DISPATCH_QUEUE_CONCURRENT), ^{
        int i = 0;
        while (YES) {
            i++;
            if (i % 10000 == 0){
                sleep(1);
            }
        }
    });
    dispatch_async(dispatch_queue_create("com.chenbin.queue4", DISPATCH_QUEUE_CONCURRENT), ^{
        int i = 0;
        while (YES) {
            i++;
            if (i % 10000 == 0){
                sleep(0.5);
            }
        }
    });
    dispatch_async(dispatch_queue_create("com.chenbin.queue5", DISPATCH_QUEUE_CONCURRENT), ^{
        int i = 0;
        while (YES) {
            i++;
            if (i % 10000 == 0){
                sleep(1);
            }
        }
    });
    dispatch_async(dispatch_queue_create("com.chenbin.queue6", DISPATCH_QUEUE_CONCURRENT), ^{
        int i = 0;
        while (YES) {
            i++;
            if (i % 10000 == 0){
//                sleep(1);
            }
        }
    });
    dispatch_async(dispatch_queue_create("com.chenbin.queue7", DISPATCH_QUEUE_CONCURRENT), ^{
        int i = 0;
        while (YES) {
            i++;
            if (i % 10000 == 0){
//                sleep(1);
            }
        }
    });
    dispatch_async(dispatch_queue_create("com.chenbin.queue8", DISPATCH_QUEUE_CONCURRENT), ^{
        int i = 0;
        while (YES) {
            i++;
            if (i % 10000 == 0){
//                sleep(1);
            }
        }
    });
    dispatch_async(dispatch_queue_create("com.chenbin.queue9", DISPATCH_QUEUE_CONCURRENT), ^{
        int i = 0;
        while (i < 1000000) {
            i++;
//            if (i % 1000 == 0){
//                sleep(2);
//            }
        }
    });
}

@end
