//
//  CBWebImageOperation_YY.m
//  CBStudyDemo
//
//  Created by ChenBin on 16/8/22.
//  Copyright © 2016年 ChenBin. All rights reserved.
//

#import "CBWebImageOperation_YY.h"

@interface CBWebImageOperation_YY ()<NSURLConnectionDelegate>

@property (readwrite, getter=isExecuting) BOOL executing;
@property (readwrite, getter=isFinished) BOOL finished;
@property (readwrite, getter=isCancelled) BOOL cancelled;
@property (readwrite, getter=isStarted) BOOL started;
@property (nonatomic, strong) NSRecursiveLock *lock;
@property (nonatomic, strong) NSURLConnection *connection;
@property (nonatomic, strong) NSMutableData *data;
@property (nonatomic, assign) NSInteger expectedSize;
@property (nonatomic, assign) UIBackgroundTaskIdentifier taskID;

@property (nonatomic, copy) CBWebImageProgressBlock_YY progress;
@property (nonatomic, copy) CBWebImageTransformBlock tranform;
@property (nonatomic, copy) CBWebImageCompletionBlock_YY completion;

@end

@implementation CBWebImageOperation_YY
@synthesize executing = _executing;
@synthesize finished = _finished;
@synthesize cancelled = _cancelled;

@end
