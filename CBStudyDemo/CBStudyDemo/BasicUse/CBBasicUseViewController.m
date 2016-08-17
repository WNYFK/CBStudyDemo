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
#import "CBRunTimeVIewController.h"
#import "CBCoreDataViewController.h"
#import "CBCoreDataThirdLibUseViewController.h"

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
    [runloopSectionItem.cellItems addObject:[[CBSkipItem alloc] initWithTitle:@"CFRunLoop" destinationClass:[CBCFRunLoopViewController class]]];
    [self.dataArr addObject:runloopSectionItem];
    
    CBSectionItem *multiThreadSectionItem = [[CBSectionItem alloc] initWithTitle:@"Multi-Thread"];
    [self.dataArr addObject:multiThreadSectionItem];
    
    CBSectionItem *runtimeSectionItem = [[CBSectionItem alloc] initWithTitle:@"Runtime"];
    [runtimeSectionItem.cellItems addObject:[[CBSkipItem alloc] initWithTitle:@"运行时" destinationClass:[CBRunTimeVIewController class]]];
    [self.dataArr addObject:runtimeSectionItem];
    
    CBSectionItem *coreDataSectionItem = [[CBSectionItem alloc] initWithTitle:@"CoreData"];
    [coreDataSectionItem.cellItems addObject:[[CBSkipItem alloc] initWithTitle:@"CoreData 使用" destinationClass:[CBCoreDataViewController class]]];
    [coreDataSectionItem.cellItems addObject:[[CBSkipItem alloc] initWithTitle:@"CoreData 第三方库使用" destinationClass:[CBCoreDataThirdLibUseViewController class]]];
    [self.dataArr addObject:coreDataSectionItem];
}

@end
