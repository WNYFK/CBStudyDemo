//
//  CBNormalInputSource.m
//  CBStudyDemo
//
//  Created by ChenBin on 16/8/15.
//  Copyright © 2016年 ChenBin. All rights reserved.
//

#import "CBNormalInputSource.h"

@interface CBSourceOneObject : NSObject

@property (assign, nonatomic) int sourceOneTag;

- (void)willHandle;
- (void)handleSourceMethod;

@end

@interface CBSourceTwoObject : NSObject

@property (assign, nonatomic) int sourceTwoTag;

- (void)willHandle;
- (void)handleSourceMethod;

@end

@interface CBNormalInputSource ()

@property (nonatomic, assign) CFRunLoopSourceRef sourceOne;
@property (nonatomic, assign) CFRunLoopSourceRef sourceTwo;

@end

@implementation CBNormalInputSource

- (void)dealloc {
    NSLog(@"CBNullInputSource dealloc");
}

static void schedule(void *info, CFRunLoopRef rl, CFStringRef mode) {
    NSLog(@"schedule");
}

static void cancel(void *info, CFRunLoopRef rl, CFStringRef mode) {
    NSLog(@"cancel");
}

static void perform(void *info) {
    NSObject *obj = (__bridge NSObject *)info;
    if ([obj isKindOfClass:[CBSourceOneObject class]]) {
        [(CBSourceOneObject *)obj handleSourceMethod];
    } else if ([obj isKindOfClass:[CBSourceTwoObject class]]) {
        [(CBSourceTwoObject *)obj handleSourceMethod];
    }
}

static CFRunLoopSourceRef createSource(id obj) {
    CFRunLoopSourceContext context = {
        .version = 0,
        .info = (__bridge_retained void *)(obj),
        .retain = NULL, .release = NULL,
        .copyDescription = NULL,
        .equal = NULL, .hash = NULL,
        .schedule = schedule,
        .cancel = cancel,
        .perform = perform,
    };
    return CFRunLoopSourceCreate(kCFAllocatorDefault, 0, &context);
}

- (instancetype)init {
    if (self = [super init]) {
        self.sourceOne = createSource([[CBSourceOneObject alloc] init]);
        self.sourceTwo = createSource([[CBSourceTwoObject alloc] init]);
    }
    return self;
}

- (instancetype)addToCurrentRunLoop {
    if (CFRunLoopSourceIsValid(self.sourceOne)) {
        CFRunLoopAddSource(CFRunLoopGetCurrent(), self.sourceOne, kCFRunLoopDefaultMode);
    }
    if (CFRunLoopSourceIsValid(self.sourceTwo)) {
        CFRunLoopAddSource(CFRunLoopGetCurrent(), self.sourceTwo, kCFRunLoopDefaultMode);
    }
    return self;
}

- (void)invalidate {
    CFRunLoopStop(CFRunLoopGetCurrent());
}

- (void)invalidateSourceOne {
    if (CFRunLoopSourceIsValid(self.sourceOne)) {
        CFRunLoopSourceInvalidate(self.sourceOne);
    }
}

- (void)invalidateSourceTwo {
    if (CFRunLoopSourceIsValid(self.sourceTwo)) {
        CFRunLoopSourceInvalidate(self.sourceTwo);
    }
}

- (void)wakeUpSourceOne {
    CFRunLoopSourceSignal(self.sourceOne);
    CFRunLoopWakeUp(CFRunLoopGetCurrent());
}

- (void)wakeUpSourceTwo {
    CFRunLoopSourceSignal(self.sourceTwo);
    CFRunLoopWakeUp(CFRunLoopGetCurrent());
}
@end

@implementation CBSourceOneObject

- (void)dealloc {
    NSLog(@"CBSourceOneObject dealloc");
}

- (void)willHandle {
    NSLog(@"CBSourceOneObejct willHandle");
}

- (void)handleSourceMethod {
    NSLog(@"CBSourceOneObejct handleSource Method: %d", self.sourceOneTag++);
}

@end


@implementation CBSourceTwoObject

- (void)dealloc {
    NSLog(@"CBSourceTwoObject dealloc");
}

- (void)willHandle {
    NSLog(@"CBSourceTwoObejct willHandle");
}

- (void)handleSourceMethod {
    NSLog(@"CBSourceTwoObejct handleSource Method: %d", self.sourceTwoTag++);
}

@end


