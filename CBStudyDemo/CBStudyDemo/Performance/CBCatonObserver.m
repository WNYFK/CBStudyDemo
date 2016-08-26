//
//  CBCatonObserver.m
//  CBStudyDemo
//
//  Created by chenbin on 16/8/24.
//  Copyright © 2016年 ChenBin. All rights reserved.
//

#import "CBCatonObserver.h"
#import "CBCatonTimerManager.h"
#import <CrashReporter/CrashReporter.h>

@interface CBCatonThread : NSThread

@property (nonatomic, strong) CBCatonTimerManager *catonTimerManager;
@property (nonatomic, weak) NSThread *curThread;

- (void)runLoopBeforeWaiting;
- (void)runLoopAfterWaiting;

@end

@interface CBCatonObserver ()

@property (nonatomic, strong) CBCatonThread *catonThread;

@end

@implementation CBCatonObserver

- (instancetype)init {
    if (self = [super init]) {
        self.catonThread = [[CBCatonThread alloc] init];
    }
    return self;
}


+ (CBCatonObserver *)sharedInstance {
    static CBCatonObserver *catonObserver;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        catonObserver = [[CBCatonObserver alloc] init];
    });
    return catonObserver;
}

- (void)startObserver {
    [self.catonThread start];
}

@end


void mainRunLoopObserver(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info) {
    NSObject *object = (__bridge NSObject*)info;
    if (![object isKindOfClass:[CBCatonThread class]]) return;
    CBCatonThread *catonThread = (CBCatonThread *)object;
    switch (activity) {
        case kCFRunLoopBeforeWaiting:   //即将进入休眠
        {
            [catonThread.curThread performSelector:@selector(runLoopBeforeWaiting) onThread:catonThread.curThread withObject:nil waitUntilDone:NO];
        }
            break;
        case kCFRunLoopAfterWaiting: //刚从休眠中唤醒
        {
            [catonThread.catonTimerManager performSelector:@selector(runLoopAfterWaiting) onThread:catonThread.curThread withObject:nil waitUntilDone:NO];
        }
            break;
            
        default:
            break;
    }
}

@implementation CBCatonThread

- (instancetype)init {
    if (self = [super init]) {
        [self setupTimerManager];
    }
    return self;
}

- (void)setupTimerManager {
    self.catonTimerManager = [[CBCatonTimerManager alloc] init];
    self.catonTimerManager.longTimeBlock = ^(NSTimeInterval persistSecond){
        NSLog(@"警告MainLoop执行时间过长！持续时间 %f s",persistSecond);
    };
    
    self.catonTimerManager.lowFpsBlock = ^(NSInteger fpsUsage) {
        
    };
    
    self.catonTimerManager.highCpuBlock = ^(CGFloat cpuUsage, NSTimeInterval presistSeond) {
        NSLog(@"当时cpu使用: %f===持续时间：%f",cpuUsage, presistSeond);
        NSData *lagData = [[[PLCrashReporter alloc]
                            initWithConfiguration:[[PLCrashReporterConfig alloc] initWithSignalHandlerType:PLCrashReporterSignalHandlerTypeBSD symbolicationStrategy:PLCrashReporterSymbolicationStrategyAll]] generateLiveReport];
        PLCrashReport *lagReport = [[PLCrashReport alloc] initWithData:lagData error:NULL];
        NSString *lagReportString = [PLCrashReportTextFormatter stringValueForCrashReport:lagReport withTextFormat:PLCrashReportTextFormatiOS];
    };
}

- (void)main {
    [[NSRunLoop currentRunLoop] addPort:[NSPort port] forMode:NSRunLoopCommonModes];
    self.curThread = [NSThread currentThread];
    [self.curThread setName:@"CBCatonThread"];
    [self startObserverMainLoop];
    [self.catonTimerManager startObserverCPU];
    [[NSRunLoop currentRunLoop] run];
}

- (void)runLoopBeforeWaiting {
    [self.catonTimerManager runLoopBeforeWaiting];
}

- (void)runLoopAfterWaiting {
    [self.catonTimerManager runLoopAfterWaiting];
}

- (void)startObserverMainLoop {
    CFRunLoopObserverContext context = {0, (__bridge void *)(self), NULL, NULL, NULL};
    CFRunLoopObserverRef observer = CFRunLoopObserverCreate(kCFAllocatorDefault, kCFRunLoopAfterWaiting | kCFRunLoopBeforeWaiting, YES, 0, mainRunLoopObserver, &context);
    if (observer) {
        CFRunLoopAddObserver(CFRunLoopGetMain(), observer, kCFRunLoopCommonModes);
    }
}

@end