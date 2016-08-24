//
//  CBWebImageOperation_YY.m
//  CBStudyDemo
//
//  Created by ChenBin on 16/8/22.
//  Copyright © 2016年 ChenBin. All rights reserved.
//

#import "CBWebImageOperation_YY.h"

@interface CBWebImageOperation_YY ()<NSURLConnectionDelegate>

@property (nonatomic, readwrite, getter=isExecuting) BOOL executing;
@property (nonatomic, readwrite, getter=isFinished) BOOL finished;
@property (nonatomic, readwrite, getter=isCancelled) BOOL cancelled;
@property (readwrite, getter=isStarted) BOOL started;
@property (nonatomic, strong) NSRecursiveLock *lock;
@property (nonatomic, strong) NSURLConnection *connection;
@property (nonatomic, strong) NSMutableData *data;
@property (nonatomic, assign) NSInteger expectedSize;
@property (nonatomic, assign) UIBackgroundTaskIdentifier taskID;
@property (nonatomic, strong) NSURLRequest *request;
@property (nonatomic, strong) NSString *cacheKey;

@property (nonatomic, copy) CBWebImageProgressBlock_YY progress;
@property (nonatomic, copy) CBWebImageTransformBlock tranform;
@property (nonatomic, copy) CBWebImageCompletionBlock_YY completion;

@end

@implementation CBWebImageOperation_YY
@synthesize executing = _executing;
@synthesize finished = _finished;
@synthesize cancelled = _cancelled;

- (instancetype)initWithRequst:(NSURLRequest *)request progress:(CBWebImageProgressBlock_YY)progress transform:(CBWebImageTransformBlock)transform completion:(CBWebImageCompletionBlock_YY)completion {
    self = [super init];
    if (!self) return nil;
    self.request = request;
    self.cacheKey = request.URL.absoluteString;
    self.shouldUseCredentialStorage = YES;
    self.progress = progress;
    self.tranform = transform;
    self.completion = completion;
    self.executing = NO;
    self.finished = NO;
    self.cancelled = NO;
    self.taskID = UIBackgroundTaskInvalid;
    self.lock = [NSRecursiveLock new];
    return self;
}

#pragma mark - Override NSOperation

- (void)start {
    @autoreleasepool {
        [self.lock lock];
        self.started = YES;
        if (self.isCancelled){
            self.finished = YES;
        } else if (self.isReady && !self.isFinished && !self.isExecuting) {
            self.executing = YES;
            
        }
        
        
        [self.lock unlock];
    }
}

- (void)setExecuting:(BOOL)executing {
    [self.lock lock];
    if (_executing != executing){
        [self willChangeValueForKey:@"isExecuting"];
        _executing = executing;
        [self didChangeValueForKey:@"isExecuting"];
    }
    [self.lock unlock];
}

- (BOOL)isExecuting {
    [self.lock lock];
    BOOL executing = _executing;
    [self.lock unlock];
    return executing;
}

- (void)setFinished:(BOOL)finished {
    [self.lock lock];
    if (_finished != finished){
        [self willChangeValueForKey:@"isFinished"];
        _finished = finished;
        [self didChangeValueForKey:@"isFinished"];
    }
    [self.lock unlock];
}

- (BOOL)isFinished {
    [self.lock lock];
    BOOL finished = _finished;
    [self.lock unlock];
    return finished;
}

- (void)setCancelled:(BOOL)cancelled {
    [self.lock lock];
    if (_cancelled != cancelled) {
        [self willChangeValueForKey:@"isCancelled"];
        _cancelled = cancelled;
        [self didChangeValueForKey:@"isCancelled"];
    }
    [self.lock unlock];
}


- (BOOL)isConcurrent {
    return YES;
}

- (BOOL)isAsynchronous {
    return YES;
}

@end
