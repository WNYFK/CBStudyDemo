//
//  CBHomePrincipleViewController.m
//  CBStudyDemo
//
//  Created by ChenBin on 16/8/12.
//  Copyright © 2016年 ChenBin. All rights reserved.
//

#import "CBHomePrincipleViewController.h"
#import "CBKVORealizeViewController.h"
#import "CBKVOBlockViewController.h"
#import "CBKVCRealizeViewController.h"
#import "CBGestureViewController.h"
#import "CBTouchTestViewController.h"
#import "CBAutoReleaseHomeViewController.h"
#import "CBRunLoopPrincipleViewController.h"
#import "CBOperationQueueViewController.h"
#import "CBGCDPrincipleViewController.h"
#import "CBPrincipleThreadViewController.h"

@implementation CBHomePrincipleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"原理";
    [self setupBaseData];
}

- (void)setupBaseData {
    CBSectionItem *kvoSectionItem = [[CBSectionItem alloc] initWithTitle:@"KVO"];
    [kvoSectionItem.cellItems addObject:[[CBSkipItem alloc] initWithTitle:@"KVO 实现" destinationClass:[CBKVORealizeViewController class]]];
    [kvoSectionItem.cellItems addObject:[[CBSkipItem alloc] initWithTitle:@"KVO Block实现" destinationClass:[CBKVOBlockViewController class]]];
    [self.dataArr addObject:kvoSectionItem];
    
    CBSectionItem *kvcSectionItem = [[CBSectionItem alloc] initWithTitle:@"KVC"];
    [kvcSectionItem.cellItems addObject:[[CBSkipItem alloc] initWithTitle:@"KVC实现" destinationClass:[CBKVCRealizeViewController class]]];
    [self.dataArr addObject:kvcSectionItem];
    
    CBSectionItem *gestureSectionItem = [[CBSectionItem alloc] initWithTitle:@"手势相关"];
    [gestureSectionItem.cellItems addObject:[[CBSkipItem alloc] initWithTitle:@"手势" destinationClass:[CBGestureViewController class]]];
    [gestureSectionItem.cellItems addObject:[[CBSkipItem alloc] initWithTitle:@"touch" destinationClass:[CBTouchTestViewController class]]];
    [self.dataArr addObject:gestureSectionItem];
    
    CBSectionItem *autoReleaseSectionItem = [[CBSectionItem alloc] initWithTitle:@"AutoRelease"];
    [autoReleaseSectionItem.cellItems addObject:[[CBSkipItem alloc] initWithTitle:@"AutoReease 原理" destinationClass:[CBAutoReleaseHomeViewController class]]];
    [self.dataArr addObject:autoReleaseSectionItem];
    
    CBSectionItem *runloopSectionItem = [[CBSectionItem alloc] initWithTitle:@"RunLoop"];
    [runloopSectionItem.cellItems addObject:[[CBSkipItem alloc] initWithTitle:@"RunLoop原理" destinationClass:[CBRunLoopPrincipleViewController class]]];
    [self.dataArr addObject:runloopSectionItem];
    
    CBSectionItem *mulThreadSectionItem = [[CBSectionItem alloc] initWithTitle:@"多线程"];
    [mulThreadSectionItem.cellItems addObject:[[CBSkipItem alloc] initWithTitle:@"NSOperationQueue" destinationClass:[CBOperationQueueViewController class]]];
    [mulThreadSectionItem.cellItems addObject:[[CBSkipItem alloc] initWithTitle:@"NSThread" destinationClass:[CBPrincipleThreadViewController class]]];
    [mulThreadSectionItem.cellItems addObject:[[CBSkipItem alloc] initWithTitle:@"GCD" destinationClass:[CBGCDPrincipleViewController class]]];
    [self.dataArr addObject:mulThreadSectionItem];
}

@end
