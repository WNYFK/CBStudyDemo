//
//  CBHomeHoleViewController.m
//  CBStudyDemo
//
//  Created by ChenBin on 16/8/24.
//  Copyright © 2016年 ChenBin. All rights reserved.
//

#import "CBHomeHoleViewController.h"
#import "CBNonatomicMultiThreadCrashViewController.h"

@implementation CBHomeHoleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupBaseDataArr];
}

- (void)setupBaseDataArr {
    CBSectionItem *sectionItem = [[CBSectionItem alloc] initWithTitle:@"nonatomic 坑"];
    [sectionItem.cellItems addObject:[[CBSkipItem alloc] initWithTitle:@"nonatomic多线程坑" destinationClass:[CBNonatomicMultiThreadCrashViewController class]]];
    [self.dataArr addObject:sectionItem];
}

@end
