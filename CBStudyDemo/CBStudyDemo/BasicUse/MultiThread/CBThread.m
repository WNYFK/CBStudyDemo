//
//  CBThread.m
//  CBStudyDemo
//
//  Created by ChenBin on 16/8/15.
//  Copyright © 2016年 ChenBin. All rights reserved.
//

#import "CBThread.h"
#import "CBNormalInputSource.h"

@interface CBThread ()

@property (nonatomic, strong) CBNormalInputSource *inputSource;

@end

@implementation CBThread

- (instancetype)init {
    if (self = [super init]) {
        
    }
    return self;
}

- (void)main {
    self.inputSource = [[[CBNormalInputSource alloc] init] addToCurrentRunLoop];
    CFRunLoopRun();
}

- (void)wakeUpSourceOne {
    [self.inputSource wakeUpSourceOne];
}

- (void)wakeUpSourceTwo {
    [self.inputSource wakeUpSourceTwo];
}

- (void)wakeUpRunLoop {
    CFRunLoopWakeUp(CFRunLoopGetCurrent());
}

- (void)invalidateSourceOne {
    [self.inputSource invalidateSourceOne];
}
@end
