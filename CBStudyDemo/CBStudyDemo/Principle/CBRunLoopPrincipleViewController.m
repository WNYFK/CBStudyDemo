//
//  CBRunLoopPrincipleViewController.m
//  CBStudyDemo
//
//  Created by ChenBin on 2016/11/14.
//  Copyright © 2016年 ChenBin. All rights reserved.
//

#import "CBRunLoopPrincipleViewController.h"
#import "CBRunLoopChangeModelViewController.h"
#import "CBRunLoopSourceHandleViewController.h"

@interface CBRunLoopPrincipleViewController ()

@end

@implementation CBRunLoopPrincipleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CBSectionItem *sectionItem = [[CBSectionItem alloc] initWithTitle:nil];
    [sectionItem.cellItems addObject:[[CBSkipItem alloc] initWithTitle:@"runloop切换model" destinationClass:[CBRunLoopChangeModelViewController class]]];
    
    [sectionItem.cellItems addObject:[[CBSkipItem alloc] initWithTitle:@"source使用" destinationClass:[CBRunLoopSourceHandleViewController class]]];
    
    [self.dataArr addObject:sectionItem];
    
}



@end
