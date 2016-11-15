//
//  CBRunLoopSourceHandleViewController.m
//  CBStudyDemo
//
//  Created by ChenBin on 2016/11/14.
//  Copyright © 2016年 ChenBin. All rights reserved.
//

#import "CBRunLoopSourceHandleViewController.h"
#import "CBThread.h"
#import "CBRunLoopObserverHandleManager.h"

@interface CBRunLoopSourceObject : NSObject

@property (nonatomic, assign) NSInteger tag;
@property (nonatomic, strong) NSString *threadName;

- (instancetype)initWithThreadName:(NSString*)threadName;
- (void)handleSourceMethod;

@end

@interface CBRunLoopSourceHandle : NSObject

@property (nonatomic, assign) CFRunLoopSourceRef mainThreadSource0;

@property (nonatomic, strong) NSThread *subThreadUseLoop;
@property (nonatomic, strong) NSThread *subThread;
@property (nonatomic, strong) CBRunLoopSourceObject *subThreadLoopSourceObject;
@property (nonatomic, assign) CFRunLoopSourceRef subThreadSource0;
@property (nonatomic, strong) CBRunLoopObserverHandleManager *subThreadUseLoopObserverHandle;
@property (nonatomic, strong) CBRunLoopObserverHandleManager *subThreadObserverHandle;


- (void)handleSource0InMainThread;

- (void)handleSource0InSubThreadUseWakeUpLoop;
- (void)handleSourceInSubThread;

@end

@interface CBRunLoopSourceHandleViewController ()

@property (nonatomic, strong) CBRunLoopSourceHandle *sourceHandle;

@end

@implementation CBRunLoopSourceHandleViewController

- (void)dealloc {
    NSLog(@"CBRunLoopSourceHandleViewController dealloc");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.sourceHandle = [[CBRunLoopSourceHandle alloc] init];
    
    @weakify(self);
    CBSectionItem *sectionItem = [[CBSectionItem alloc] init];
    [sectionItem.cellItems addObject:[[CBSkipItem alloc] initWithTitle:@"主线程通过唤醒loop来处理source0" callBack:^{
        @strongify(self);
        [self.sourceHandle handleSource0InMainThread];
    }]];
    [sectionItem.cellItems addObject:[[CBSkipItem alloc] initWithTitle:@"子线程通过唤醒loop来处理source0" callBack:^{
        @strongify(self);
        [self.sourceHandle handleSource0InSubThreadUseWakeUpLoop];
    }]];
    [sectionItem.cellItems addObject:[[CBSkipItem alloc] initWithTitle:@"子线程直接处理source" callBack:^{
        @strongify(self);
        [self.sourceHandle handleSourceInSubThread];
    }]];
    [self.dataArr addObject:sectionItem];
}

@end


@implementation CBRunLoopSourceHandle

- (void)dealloc {
    NSLog(@"CBRunLoopSourceHandle dealloc");
    CFRelease(self.subThreadSource0);
    CFRelease(self.mainThreadSource0);
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
}

static void release(const void *info) {
    CFRelease(info);
}

static CFStringRef copyDescription(const void *info) {
    NSString *des = @"Cpaaaaa";
    return (__bridge CFStringRef)des;
}

static Boolean equal(const void *info1, const void *info2) {
    return YES;
}

static void schedule(void *info, CFRunLoopRef rl, CFRunLoopMode mode) {
    NSLog(@"schedule===%@",mode);
}

static void cancel(void *info, CFRunLoopRef rl, CFRunLoopMode mode) {
    NSLog(@"cancel=====%@",mode);
}

static void perform(void *info) {
    NSObject *obj = (__bridge NSObject *)info;
    if ([obj isKindOfClass:[CBRunLoopSourceObject class]]) {
        [(CBRunLoopSourceObject *)obj handleSourceMethod];
    }
}

static CFRunLoopSourceRef createSource0(id obj) {
    CFRunLoopSourceContext sourceContext = {
        .version = 0,
        .info = (__bridge_retained void *)obj,
        .retain = NULL,
        .release = release,
        .copyDescription = copyDescription,
        .equal = equal,
        .hash = NULL,
        .schedule = schedule,
        .cancel = cancel,
        .perform = perform
    };
    return CFRunLoopSourceCreate(kCFAllocatorDefault, 0, &sourceContext);
}

- (instancetype)init {
    if (self = [super init]) {
        self.mainThreadSource0 = createSource0([[CBRunLoopSourceObject alloc] initWithThreadName:@"main thread"]);
        self.subThreadSource0 = createSource0([[CBRunLoopSourceObject alloc] initWithThreadName:@"sub thread use loop"]);
        self.subThreadUseLoop = [[NSThread alloc] initWithBlock:^{
            NSLog(@"sub thread start");
            NSRunLoop *runloop = [NSRunLoop currentRunLoop];
            [runloop addPort:[NSPort new] forMode:NSDefaultRunLoopMode];
            [runloop run];
        }];
        self.subThreadUseLoop.name = @"sub thread use loop";
        [self.subThreadUseLoop start];
        
        self.subThread = [[NSThread alloc] initWithBlock:^{
            NSRunLoop *loop = [NSRunLoop currentRunLoop];
            [loop addPort:[NSPort new] forMode:NSDefaultRunLoopMode];
            [loop run];
        }];
        [self.subThread setName:@"sub thread"];
        [self.subThread start];
    }
    return self;
}

- (void)handleSource0InMainThread {
    [self threadHandleSource:self.mainThreadSource0 thread:CFRunLoopGetCurrent()];
}

- (void)handleSource0InSubThreadUseWakeUpLoop {
    [self performSelector:@selector(subThreadStartUseWakeUpLoop) onThread:self.subThread withObject:nil waitUntilDone:NO];
}

- (void)subThreadStartUseWakeUpLoop {
    [self threadHandleSource:self.subThreadSource0 thread:CFRunLoopGetCurrent()];
    if (!self.subThreadUseLoopObserverHandle) {
        self.subThreadUseLoopObserverHandle = [[CBRunLoopObserverHandleManager alloc] initWithInfo:self withCallBack:^(NSString *activity, CFStringRef modeName, id info) {
            NSLog(@"threadName: %@====activity: %@",[NSThread currentThread].name, activity);
        }];
        [self.subThreadUseLoopObserverHandle observerWithLoop:CFRunLoopGetCurrent()];
    }
}

- (void)handleSourceInSubThread {
    [self performSelector:@selector(subThreadStart) onThread:self.subThread withObject:nil waitUntilDone:NO];
}

- (void)subThreadStart {
    if (!self.subThreadObserverHandle) {
        self.subThreadObserverHandle = [[CBRunLoopObserverHandleManager alloc] initWithInfo:self withCallBack:^(NSString *activity, CFStringRef modeName, id info) {
            NSLog(@"threadName: %@=====activity: %@",[NSThread currentThread].name, activity);
        }];
        [self.subThreadObserverHandle observerWithLoop:CFRunLoopGetCurrent()];
    }
    if (!self.subThreadLoopSourceObject) {
        self.subThreadLoopSourceObject = [[CBRunLoopSourceObject alloc] initWithThreadName:[NSThread currentThread].name];
    }
    [self.subThreadLoopSourceObject handleSourceMethod];
    [self performSelector:@selector(subThreadPerTest) withObject:nil afterDelay:60];
}

- (void)subThreadPerTest {
    NSLog(@"SubThreadPerTest");
}

- (void)threadHandleSource:(CFRunLoopSourceRef)source thread:(CFRunLoopRef)loop {
    if (CFRunLoopSourceIsValid(source)) {
        CFRunLoopAddSource(loop, source, kCFRunLoopDefaultMode);
    }
    CFRunLoopSourceSignal(source);
    CFRunLoopWakeUp(loop);
}

@end

@implementation CBRunLoopSourceObject

- (void)dealloc {
    NSLog(@"CBRunLoopSourceObejct dealloc");
}

- (instancetype)initWithThreadName:(NSString *)threadName {
    if (self = [super init]) {
        self.threadName = threadName;
        self.tag = 0;
    }
    return self;
}

- (void)handleSourceMethod {
    NSLog(@"CBRunLoopSourceObject====thread: %@====modelName: %@------%ld", [[NSThread currentThread] name], CFRunLoopCopyCurrentMode(CFRunLoopGetCurrent()), self.tag++);
}

@end
