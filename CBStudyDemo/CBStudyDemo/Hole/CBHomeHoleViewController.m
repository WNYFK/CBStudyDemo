//
//  CBHomeHoleViewController.m
//  CBStudyDemo
//
//  Created by ChenBin on 16/8/24.
//  Copyright © 2016年 ChenBin. All rights reserved.
//

#import "CBHomeHoleViewController.h"
#import "CBNonatomicMultiThreadCrashViewController.h"
#import "MYPScrollViewPagingViewController.h"

@implementation CBHomeHoleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupBaseDataArr];
}

- (void)setupBaseDataArr {
    CBSectionItem *sectionItem = [[CBSectionItem alloc] initWithTitle:@"nonatomic 坑"];
    [sectionItem.cellItems addObject:[[CBSkipItem alloc] initWithTitle:@"nonatomic多线程坑" destinationClass:[CBNonatomicMultiThreadCrashViewController class]]];
    [self.dataArr addObject:sectionItem];
    
    CBSectionItem *sectionItem1 = [[CBSectionItem alloc] initWithTitle:@"scrollView 坑"];
    [sectionItem1.cellItems addObject:[[CBSkipItem alloc] initWithTitle:@"scrollview paging 坑" destinationClass:[MYPScrollViewPagingViewController class]]];
    [self.dataArr addObject:sectionItem1];
}


@end
