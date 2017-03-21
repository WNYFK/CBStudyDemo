//
//  CBTestViewController1.m
//  CBStudyDemo
//
//  Created by ChenBin on 2017/3/6.
//  Copyright © 2017年 ChenBin. All rights reserved.
//

#import "CBTestViewController1.h"
#import "CBTestObject.h"

@interface CBTestViewController1 ()

@property (nonatomic, strong) CBTestObject *testObject;


@end

@implementation CBTestViewController1

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(10, 100, 100, 60);
    [btn addTarget:self action:@selector(testBlock) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
}

- (void)testBlock {
    [self.testObject finished:^(NSDictionary *dict) {
        NSLog(@"啊啊啊啊: %@",dict);
    }];
}

@end
