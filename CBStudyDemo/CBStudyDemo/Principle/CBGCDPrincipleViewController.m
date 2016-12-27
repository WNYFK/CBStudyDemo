//
//  CBGCDPrincipleViewController.m
//  CBStudyDemo
//
//  Created by ChenBin on 2016/11/15.
//  Copyright © 2016年 ChenBin. All rights reserved.
//

#import "CBGCDPrincipleViewController.h"

@interface CBGCDPrincipleViewController ()

@end

@implementation CBGCDPrincipleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    CBSectionItem *sectionItem = [[CBSectionItem alloc] init];
    
    dispatch_queue_t globalQueue = dispatch_queue_create("com.chenbin.globalQueue", DISPATCH_QUEUE_CONCURRENT);
    
    [sectionItem.cellItems addObject:[[CBSkipItem alloc] initWithTitle:@"globalQueue长时间任务" callBack:^{
        dispatch_async(globalQueue, ^{
            NSLog(@"开始长时间任务");
            sleep(20);
            NSLog(@"长时间任务结束");
        });
    }]];
    [sectionItem.cellItems addObject:[[CBSkipItem alloc] initWithTitle:@"syn" callBack:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"1111");
            dispatch_sync(globalQueue, ^{
                NSLog(@"222");
            });
            NSLog(@"3333");
        });
    }]];
    
    
    
    [sectionItem.cellItems addObject:[[CBSkipItem alloc] initWithTitle:@"asyn" callBack:^{
        NSLog(@"11111");
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"2222");
        });
        NSLog(@"33333");
    }]];
    
    [sectionItem.cellItems addObject:[[CBSkipItem alloc] initWithTitle:@"队列 & 线程" callBack:^{
        dispatch_queue_t queue = dispatch_queue_create("com.chenbin.queue", nil);
        NSLog(@"1");
        dispatch_sync(queue, ^{
            NSLog(@"Current thread = %@", [NSThread currentThread]);
            dispatch_sync(dispatch_get_main_queue(), ^{
                NSLog(@"Current thread = %@", [NSThread currentThread]);
            });
            NSLog(@"2");
        });
        NSLog(@"3");
    }]];
    
    [self.dataArr addObject:sectionItem];
}

@end
