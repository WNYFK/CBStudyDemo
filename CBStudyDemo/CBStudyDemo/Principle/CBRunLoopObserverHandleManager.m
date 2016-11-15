//
//  CBRunLoopObserverHandleManager.m
//  CBStudyDemo
//
//  Created by ChenBin on 2016/11/14.
//  Copyright © 2016年 ChenBin. All rights reserved.
//

#import "CBRunLoopObserverHandleManager.h"

@interface CBRunLoopObserverHandleManager ()

@property (nonatomic, copy) RunLoopOberverCallBack callBack;
@property (nonatomic, assign) id info;

@end

@implementation CBRunLoopObserverHandleManager

- (instancetype)initWithInfo:(id)info withCallBack:(RunLoopOberverCallBack)callBack {
    if (self = [super init]) {
        self.info = info;
        self.callBack = [callBack copy];
    }
    return self;
}

static void loopObserverHandle(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info) {
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
    NSObject *obj = (__bridge NSObject *)info;
    if ([obj isKindOfClass:[CBRunLoopObserverHandleManager class]]) {
        CBRunLoopObserverHandleManager *loopHandleManager = (CBRunLoopObserverHandleManager *)obj;
        loopHandleManager.callBack(result, modelName, loopHandleManager.info);
    }
}

- (void)observerWithLoop:(CFRunLoopRef)loop {
    
    CFRunLoopObserverContext context = {0, (__bridge void *)self, NULL, NULL, NULL};
    CFRunLoopObserverRef observer = CFRunLoopObserverCreate(kCFAllocatorDefault, kCFRunLoopAllActivities, YES, 0, loopObserverHandle, &context);
    if (observer) {
        CFRunLoopAddObserver(loop, observer, kCFRunLoopCommonModes);
    }
}

@end
