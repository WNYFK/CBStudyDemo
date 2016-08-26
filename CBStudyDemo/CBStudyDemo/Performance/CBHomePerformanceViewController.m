//
//  CBHomePerformanceViewController.m
//  CBStudyDemo
//
//  Created by chenbin on 16/8/24.
//  Copyright © 2016年 ChenBin. All rights reserved.
//

#import "CBHomePerformanceViewController.h"
#import "CBCatonObserver.h"
#import "CBCatonTestViewController.h"

@implementation CBHomePerformanceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupBaseDataArr];
}

- (void)setupBaseDataArr {
    CBSectionItem *sectionItem = [[CBSectionItem alloc] initWithTitle:@"卡顿"];
    [sectionItem.cellItems addObject:[[CBSkipItem alloc] initWithTitle:@"卡顿" destinationClass:[CBCatonTestViewController class]]];
    [self.dataArr addObject:sectionItem];
}

@end
