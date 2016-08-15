//
//  CBBasicUseViewController.m
//  CBStudyDemo
//
//  Created by ChenBin on 16/8/12.
//  Copyright © 2016年 ChenBin. All rights reserved.
//

#import "CBBasicUseViewController.h"
#import "CBNSRunLoopViewController.h"
#import "CBCFRunLoopViewController.h"

@interface CBBasicUseViewController ()


@end

@implementation CBBasicUseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"基本用法";
    [self setupBaseData];
    [self.tableView reloadData];
}

- (void)setupBaseData {
    CBSectionItem *runloopSectionItem = [[CBSectionItem alloc] initWithTitle:@"RunLoop"];
    [runloopSectionItem.cellItems addObject:[[CBSkipItem alloc] initWithTitle:@"NSRunLoop" destinationClass:[CBNSRunLoopViewController class]]];
    [runloopSectionItem.cellItems addObject:[[CBSkipItem alloc] initWithTitle:@"CFRunLoop" destinationClass:[CBNSRunLoopViewController class]]];
    [self.dataArr addObject:runloopSectionItem];
    
    CBSectionItem *multiThreadSectionItem = [[CBSectionItem alloc] initWithTitle:@"Multi-Thread"];
    [self.dataArr addObject:multiThreadSectionItem];
}

@end
