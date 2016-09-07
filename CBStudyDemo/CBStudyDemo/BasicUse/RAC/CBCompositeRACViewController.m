//
//  CBCompositeRACViewController.m
//  CBStudyDemo
//
//  Created by ChenBin on 16/9/7.
//  Copyright © 2016年 ChenBin. All rights reserved.
//

#import "CBCompositeRACViewController.h"

@implementation CBCompositeRACViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CBSectionItem *sectionItem = [[CBSectionItem alloc] init];
    [self.dataArr addObject:sectionItem];
    
    CBSkipItem *item1 = [[CBSkipItem alloc] initWithTitle:@"任务1必须等任务2完成后才可执行" callBack:^{
        RACSignal *single1 = [RACSignal return:@"single1"];
        RACSignal *single2 = [[RACSignal return:@"single2"] delay:5];
        [[[[single2 mapReplace:[RACSignal empty]] concat] concat:single1] subscribeNext:^(id x) {
            NSLog(@"%@",x);
        }];
    }];
    [sectionItem.cellItems addObject:item1];
    
    CBSkipItem *item2 = [[CBSkipItem alloc] initWithTitle:@"网络失败后20秒后重试" callBack:^{
        
    }];
    [sectionItem.cellItems addObject:item2];
}

@end
