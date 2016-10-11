//
//  CBCoreDataMultiThreadUseViewController.m
//  CBStudyDemo
//
//  Created by ChenBin on 16/9/12.
//  Copyright © 2016年 ChenBin. All rights reserved.
//

#import "CBCoreDataMultiThreadUseViewController.h"
#import "CBCoreDataConnect.h"

@interface CBCoreDataMultiThreadUseViewController ()

@property (nonatomic, strong) CBCoreDataConnect *coreDataConnect;

@end

@implementation CBCoreDataMultiThreadUseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.coreDataConnect = [[CBCoreDataConnect alloc] init];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 100, 100, 20)];
//    label.numberOfLines = 0;
    label.text = @"a";
    [self.view addSubview:label];
    
    UIButton *btn = [UIButton createButtonWithTitle:@"异步添加" frame:CGRectMake(50, 100, 250, 60) callBack:^(UIButton *button) {
        label.text = [NSString stringWithFormat:@"%@asdfa",label.text];
        [label sizeToFit];
//        dispatch_queue_t queue1 = dispatch_queue_create("com.chenbin.queue1", DISPATCH_QUEUE_CONCURRENT);
//        dispatch_queue_t queue2 = dispatch_queue_create("com.chenbin.queue2", DISPATCH_QUEUE_CONCURRENT);
//        for (int i = 0; i < 10; i ++) {
//            dispatch_async(queue1, ^{
//                [self.coreDataConnect insertEntityName:@"User" attributeInfo:@{@"name" : [NSString stringWithFormat:@"queue1:%d",i]}];
//            });
//        }
//        for (int i = 0; i < 300; i ++) {
//            dispatch_async(queue2, ^{
//                [self.coreDataConnect insertEntityName:@"User" attributeInfo:@{@"name" : [NSString stringWithFormat:@"queue2:%d",i]}];
//            });
//        }
    }];
    [self.view addSubview:btn];
    
}
@end
