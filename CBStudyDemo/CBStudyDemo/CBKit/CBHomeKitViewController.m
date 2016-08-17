//
//  CBHomeKitViewController.m
//  CBStudyDemo
//
//  Created by ChenBin on 16/8/12.
//  Copyright © 2016年 ChenBin. All rights reserved.
//

#import "CBHomeKitViewController.h"
#import "CBWebImageViewController.h"

@implementation CBHomeKitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"造轮子";
    [self setupBasicData];
}

- (void)setupBasicData {
    CBSectionItem *SDWebImageSectionItem = [[CBSectionItem alloc] initWithTitle:@"SDWebImage 轮子"];
    [SDWebImageSectionItem.cellItems addObject:[[CBSkipItem alloc] initWithTitle:@"SDWebImage" destinationClass:[CBWebImageViewController class]]];
    [self.dataArr addObject:SDWebImageSectionItem];
}

@end
