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
    startBtn.frame = CGRectMake(100, 100, 100, 60);
    [startBtn addTarget:self action:@selector(startBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:startBtn];
    
}

- (void)startBtnClicked:(UIButton *)btn {
    dispatch_async(dispatch_queue_create("com.chenbin.queue2", DISPATCH_QUEUE_CONCURRENT), ^{
        int i = 0;
        while (YES) {
            i++;
//            if (i % 1000 == 0){
//                sleep(2);
//            }
        }
    });
    dispatch_async(dispatch_queue_create("com.chenbin.queue3", DISPATCH_QUEUE_CONCURRENT), ^{
        int i = 0;
        while (YES) {
            i++;
//            if (i % 1000 == 0){
//                sleep(2);
//            }
        }
    });
    dispatch_async(dispatch_queue_create("com.chenbin.queue4", DISPATCH_QUEUE_CONCURRENT), ^{
        int i = 0;
        while (YES) {
            i++;
//            if (i % 1000 == 0){
//                sleep(2);
//            }
        }
    });
    dispatch_async(dispatch_queue_create("com.chenbin.queue5", DISPATCH_QUEUE_CONCURRENT), ^{
        int i = 0;
        while (YES) {
            i++;
//            if (i % 1000 == 0){
//                sleep(2);
//            }
        }
    });
    dispatch_async(dispatch_queue_create("com.chenbin.queue6", DISPATCH_QUEUE_CONCURRENT), ^{
        int i = 0;
        while (YES) {
            i++;
//            if (i % 1000 == 0){
//                sleep(2);
//            }
        }
    });
    dispatch_async(dispatch_queue_create("com.chenbin.queue7", DISPATCH_QUEUE_CONCURRENT), ^{
        int i = 0;
        while (YES) {
            i++;
            if (i % 1000 == 0){
                sleep(2);
            }
        }
    });
    dispatch_async(dispatch_queue_create("com.chenbin.queue8", DISPATCH_QUEUE_CONCURRENT), ^{
        int i = 0;
        while (YES) {
            i++;
//            if (i % 1000 == 0){
//                sleep(2);
//            }
        }
    });
    dispatch_async(dispatch_queue_create("com.chenbin.queue9", DISPATCH_QUEUE_CONCURRENT), ^{
        int i = 0;
        while (YES) {
            i++;
//            if (i % 1000 == 0){
//                sleep(2);
//            }
        }
    });
    int i = 0;
    while (YES) {
        i++;
        if (i % 1000 == 0){
            sleep(2);
        }
    }
    
}

@end
