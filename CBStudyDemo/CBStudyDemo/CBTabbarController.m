//
//  CBTabbarController.m
//  CBStudyDemo
//
//  Created by ChenBin on 16/8/12.
//  Copyright © 2016年 ChenBin. All rights reserved.
//

#import "CBTabbarController.h"
#import "CBNavigationController.h"
#import "CBBasicUseViewController.h"
#import "CBHomeKitViewController.h"
#import "CBHomePrincipleViewController.h"
#import "CBHomeHoleViewController.h"
#import "CBHomePerformanceViewController.h"

@implementation CBTabbarController

- (instancetype)init {
    self = [super init];
    if (self) {
        CBBasicUseViewController *basicUseViewController = [[CBBasicUseViewController alloc] init];
        basicUseViewController.title = @"基本用法";
        CBHomeKitViewController *kitViewController = [[CBHomeKitViewController alloc] init];
        kitViewController.title = @"造轮子";
        CBHomePrincipleViewController *principleViewController = [[CBHomePrincipleViewController alloc] init];
        principleViewController.title = @"原理";
        CBHomeHoleViewController *holeViewController = [[CBHomeHoleViewController alloc] init];
        holeViewController.title = @"坑";
        
        CBHomePerformanceViewController *performanceViewController = [[CBHomePerformanceViewController alloc] init];
        performanceViewController.title = @"性能";
        self.viewControllers = @[
                                 [[CBNavigationController alloc] initWithRootViewController:basicUseViewController],
                                 [[CBNavigationController alloc] initWithRootViewController:kitViewController],
                                 [[CBNavigationController alloc] initWithRootViewController:principleViewController],
                                 [[CBNavigationController alloc] initWithRootViewController:holeViewController],
                                 [[CBNavigationController alloc] initWithRootViewController:performanceViewController]
                                 ];
    }
    return self;
}

@end
