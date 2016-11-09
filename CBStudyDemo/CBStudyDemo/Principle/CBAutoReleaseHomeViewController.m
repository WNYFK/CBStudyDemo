//
//  CBAutoReleaseHomeViewController.m
//  CBStudyDemo
//
//  Created by ChenBin on 2016/11/7.
//  Copyright © 2016年 ChenBin. All rights reserved.
//

#import "CBAutoReleaseHomeViewController.h"

@interface CBAutoReleaseHomeViewController ()

@end

@implementation CBAutoReleaseHomeViewController

__weak NSString* reference = nil;

- (void)viewDidLoad {
    [super viewDidLoad];
    @autoreleasepool {
        NSString *str = [NSString stringWithFormat:@"chenbin"];
        reference = str;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"%@", reference);
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSLog(@"%@",reference);
}


@end
