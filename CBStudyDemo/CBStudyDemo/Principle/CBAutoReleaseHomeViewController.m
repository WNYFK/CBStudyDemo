//
//  CBAutoReleaseHomeViewController.m
//  CBStudyDemo
//
//  Created by ChenBin on 2016/11/7.
//  Copyright © 2016年 ChenBin. All rights reserved.
//

#import "CBAutoReleaseHomeViewController.h"
#import "CBAutoreleaseForThreadViewController.h"

@interface CBAutoReleaseHomeViewController ()

@end

@implementation CBAutoReleaseHomeViewController

__weak NSString* reference = nil;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CBSectionItem *sectionItem = [[CBSectionItem alloc] init];
    [self.dataArr addObject:sectionItem];
    
    [sectionItem.cellItems addObject:[[CBSkipItem alloc] initWithTitle:@"autorelease for thread" destinationClass:[CBAutoreleaseForThreadViewController class]]];
    
}


@end
