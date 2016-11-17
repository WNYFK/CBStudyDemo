//
//  CBOperation.m
//  CBStudyDemo
//
//  Created by ChenBin on 2016/11/15.
//  Copyright © 2016年 ChenBin. All rights reserved.
//

#import "CBOperation.h"

@interface CBOperation ()

//@property (assign, nonatomic, getter= isCancelled) BOOL cancelled;
@property (assign, nonatomic, getter= isFinished) BOOL finished;
@property (assign, nonatomic, getter= isExecuting) BOOL executing;
@property (assign, nonatomic) int persistTime;
@property (strong, nonatomic) NSRecursiveLock *lock;


@end

@implementation CBOperation
@synthesize executing = _executing;
@synthesize cancelled = _cancelled;
@synthesize finished = _finished;

- (instancetype)initWithPersistTime:(int)persistTime {
    if (self = [super init]) {
        self.persistTime = persistTime;
        self.lock = [NSRecursiveLock new];
    }
    return self;
}

- (void)start {
    @autoreleasepool {
        [self.lock lock];
        if (self.isCancelled) {
            self.finished = YES;
            return;
        }
        self.executing = YES;
        [self.lock unlock];
        sleep(self.persistTime / 2);
        if (!self.isCancelled) {
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                sleep(self.persistTime / 2);
                if (!self.isCancelled) {
                    [self.lock lock];
                    self.finished = YES;
                    [self.lock unlock];
                    NSLog(@"完成：%d", self.persistTime);
                }
            });
        }
    }
}

- (void)cancel {
    NSLog(@"取消：%d", self.persistTime);
    if (self.isFinished) return;
    [super cancel];
    [self.lock lock];
    if (self.isExecuting) self.executing = NO;
    if (!self.isFinished) self.finished = YES;
    [self.lock unlock];
}

- (BOOL)isExecuting {
    [self.lock lock];
    BOOL executing = _executing;
    [self.lock unlock];
    return executing;
}

- (void)setExecuting:(BOOL)executing {
    [self.lock lock];
    if (_executing != executing) {
        [self willChangeValueForKey:@"isExecuting"];
        _executing = executing;
        [self didChangeValueForKey:@"isExecuting"];
    }
    [self.lock unlock];
}

- (BOOL)isFinished {
    [self.lock lock];
    BOOL finished = _finished;
    [self.lock unlock];
    return finished;
}

- (void)setFinished:(BOOL)finished {
    [self.lock lock];
    if (_finished != finished) {
        [self willChangeValueForKey:@"isFinished"];
        _finished = finished;
        [self didChangeValueForKey:@"isFinished"];
    }
    [self.lock unlock];
}

//- (BOOL)isCancelled {
//    [self.lock lock];
//    BOOL cancelled = _cancelled;
//    [self.lock unlock];
//    return cancelled;
//}

//- (void)setCancelled:(BOOL)cancelled {
//    [self.lock lock];
//    if (!_cancelled != cancelled) {
//        [self willChangeValueForKey:@"isCancelled"];
//        _cancelled = cancelled;
//        [self didChangeValueForKey:@"isCancelled"];
//    }
//    [self.lock unlock];
//}

- (BOOL)isConcurrent {
    return YES;
}

- (BOOL)isAsynchronous {
    return YES;
}

@end
