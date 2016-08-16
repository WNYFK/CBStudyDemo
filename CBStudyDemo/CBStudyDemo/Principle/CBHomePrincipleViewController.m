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

@implementation CBHomePrincipleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"原理";
    [self setupBaseData];
}

- (void)setupBaseData {
    CBSectionItem *kvoSectionItem = [[CBSectionItem alloc] initWithTitle:@"KVO"];
    [kvoSectionItem.cellItems addObject:[[CBSkipItem alloc] initWithTitle:@"KVO实现" destinationClass:[CBKVORealizeViewController class]]];
    [kvoSectionItem.cellItems addObject:[[CBSkipItem alloc] initWithTitle:@"KVO Block实现" destinationClass:[CBKVOBlockViewController class]]];
    [self.dataArr addObject:kvoSectionItem];
}

@end
