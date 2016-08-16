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
}

@end
