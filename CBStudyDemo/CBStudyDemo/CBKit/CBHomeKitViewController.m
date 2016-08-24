//
//  CBHomeKitViewController.m
//  CBStudyDemo
//
//  Created by ChenBin on 16/8/12.
//  Copyright © 2016年 ChenBin. All rights reserved.
//

#import "CBHomeKitViewController.h"
#import "CBWebImageViewController.h"
#import "CBWebImageViewController_YY.h"

@implementation CBHomeKitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"造轮子";
    [self setupBasicData];
}

- (void)setupBasicData {
    CBSectionItem *WebImageSectionItem = [[CBSectionItem alloc] initWithTitle:@"WebImage 轮子"];
    [WebImageSectionItem.cellItems addObject:[[CBSkipItem alloc] initWithTitle:@"SDWebImage" destinationClass:[CBWebImageViewController class]]];
    [WebImageSectionItem.cellItems addObject:[[CBSkipItem alloc] initWithTitle:@"YYWebImage" destinationClass:[CBWebImageViewController_YY class]]];
    [self.dataArr addObject:WebImageSectionItem];
}

@end
