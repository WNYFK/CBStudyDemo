//
//  CBRunLoopPrincipleViewController.m
//  CBStudyDemo
//
//  Created by ChenBin on 2016/11/14.
//  Copyright © 2016年 ChenBin. All rights reserved.
//

#import "CBRunLoopPrincipleViewController.h"
#import "CBRunLoopChangeModelViewController.h"
#import "CBRunLoopSourceHandleViewController.h"

@interface CBRunLoopPrincipleViewController ()

@end

@implementation CBRunLoopPrincipleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CBSectionItem *sectionItem = [[CBSectionItem alloc] initWithTitle:nil];
    [sectionItem.cellItems addObject:[[CBSkipItem alloc] initWithTitle:@"runloop切换model" destinationClass:[CBRunLoopChangeModelViewController class]]];
    
    [sectionItem.cellItems addObject:[[CBSkipItem alloc] initWithTitle:@"source使用" destinationClass:[CBRunLoopSourceHandleViewController class]]];
    
    [self.dataArr addObject:sectionItem];
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_queue_create("myqueue", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_group_enter(group);
    dispatch_async(queue, ^{
        dispatch_group_enter(group);
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            
            sleep(5);
            NSLog(@"4");
            dispatch_group_leave(group);
        });
        
        NSLog(@"1");
        dispatch_group_leave(group);

    });
    dispatch_group_enter(group);

    dispatch_async(queue, ^{
        NSLog(@"2");
        dispatch_group_leave(group);

    });
    
    
    dispatch_group_enter(group);

    dispatch_async(queue, ^{
        sleep(3);
        NSLog(@"3");
        dispatch_group_leave(group);

    });
    
    dispatch_group_notify(group, queue, ^{
        NSLog(@"all");
    });
    NSLog(@"5");
}



@end
