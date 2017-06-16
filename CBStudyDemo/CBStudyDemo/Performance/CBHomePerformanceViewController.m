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
#import "CBStudyDemo-Swift.h"

@implementation CBHomePerformanceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupBaseDataArr];
}

- (void)setupBaseDataArr {
    CBSectionItem *sectionItem = [[CBSectionItem alloc] initWithTitle:@"卡顿"];
    [sectionItem.cellItems addObject:[[CBSkipItem alloc] initWithTitle:@"卡顿" destinationClass:[CBCatonTestViewController class]]];
    [self.dataArr addObject:sectionItem];
    
    CBSectionItem *swiftPerformanceSectionItem = [[CBSectionItem alloc] initWithTitle:@"swift 性能"];
    [self.dataArr addObject:swiftPerformanceSectionItem];
    [sectionItem.cellItems addObject:[[CBSkipItem alloc] initWithTitle:@"swift 性能" destinationClass:[CBSwiftTestViewController class]]];
}

@end
