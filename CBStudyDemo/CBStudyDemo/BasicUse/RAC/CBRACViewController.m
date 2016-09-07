//
//  CBRACViewController.m
//  CBStudyDemo
//
//  Created by chenbin on 16/9/3.
//  Copyright © 2016年 ChenBin. All rights reserved.
//

#import "CBRACViewController.h"

@interface CBRACViewController ()


@end

@implementation CBRACViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CBSectionItem *sectionItem = [[CBSectionItem alloc] init];
    [self.dataArr addObject:sectionItem];
    
    CBSkipItem *item1 = [[CBSkipItem alloc] initWithTitle:@"item1" callBack:^{
        RACSignal *single1 = [[[[RACSignal return:@"gggggg"] delay:10] mapReplace:[RACSignal empty]] concat];
        RACSignal *single2 = [[[RACSignal return:@"hhhhhh"] delay:5] repeat];
        [[single1 concat:single2] subscribeNext:^(id x) {
            NSLog(@"mmmmm:%@",x);
        }];
    }];
    [sectionItem.cellItems addObject:item1];
}
@end
