//
//  CBRunLoopChangeModelViewController.m
//  CBStudyDemo
//
//  Created by ChenBin on 2016/11/14.
//  Copyright © 2016年 ChenBin. All rights reserved.
//

#import "CBRunLoopChangeModelViewController.h"

@interface CBRunLoopChangeModelViewController ()

@end

// runloop 切换model时必须先退出当前runloop

@implementation CBRunLoopChangeModelViewController

void mainLoopObserverHandle(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info) {
    CFStringRef modelName = CFRunLoopCopyCurrentMode(CFRunLoopGetMain());
    NSString *result = @"";
    switch (activity) {
        case kCFRunLoopAfterWaiting: //唤醒
            result = @"唤醒";
            break;
        case kCFRunLoopBeforeWaiting: //即将睡眠
            result = @"即将睡眠";
            break;
        case kCFRunLoopEntry: //进入
            result = @"进入";
            break;
        case kCFRunLoopExit: //退出
            result = @"退出";
            break;
        case kCFRunLoopBeforeTimers:
            result = @"BeforeTtimers";
            break;
        case kCFRunLoopBeforeSources:
            result = @"BeforeSource";
            break;
        default:
            break;
    }
    NSLog(@"ModelName:%@====%@",modelName, result);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem creatBarButtonWithTitle:@"输出" callBack:^(UIBarButtonItem *buttonItem) {
        NSLog(@"aaaaaaaa");
    }];
    
    CFRunLoopObserverContext context = {0, (__bridge void *)self, NULL, NULL, NULL};
    CFRunLoopObserverRef observer = CFRunLoopObserverCreate(kCFAllocatorDefault, kCFRunLoopAllActivities, YES, 0, mainLoopObserverHandle, &context);
    if (observer) {
        CFRunLoopAddObserver(CFRunLoopGetMain(), observer, kCFRunLoopCommonModes);
    }
}

@end
