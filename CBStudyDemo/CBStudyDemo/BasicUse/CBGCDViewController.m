//
//  CBGCDViewController.m
//  CBStudyDemo
//
//  Created by ChenBin on 16/8/17.
//  Copyright © 2016年 ChenBin. All rights reserved.
//

#import "CBGCDViewController.h"

static const void * const kCBDispatchQueueSpecificKey = &kCBDispatchQueueSpecificKey;

@interface CBGcdApply : NSObject

@property (nonatomic, copy) NSString *title;

@end

@implementation CBGcdApply

- (instancetype)initWithTitle:(NSString *)title {
    if (self = [super init]) {
        self.title = title;
    }
    return self;
}

@end


@interface CBGCDViewController ()

@property (nonatomic, strong) dispatch_queue_t queue;
@property (nonatomic, strong) dispatch_source_t source;

@end

@implementation CBGCDViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupQueue];
    
    UIButton* (^createBtn)(NSString *title, CGRect frame) = ^UIButton*(NSString *title, CGRect frame) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:title forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn.frame = frame;
        return btn;
    };
    
    UIButton *mainQueueBtn = createBtn(@"mainQueue", CGRectMake(100, 60, 200, 50));
    [self.view addSubview:mainQueueBtn];
    [[mainQueueBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        CBGCDViewController *gcdViewController = (__bridge CBGCDViewController *)dispatch_get_specific(kCBDispatchQueueSpecificKey);
        if (gcdViewController) {
            NSLog(@"mainqueue: %@", gcdViewController);
        }
    }];
    
    UIButton *subQueueBtn = createBtn(@"subQueue", CGRectMake(mainQueueBtn.x, mainQueueBtn.bottom + 20, mainQueueBtn.width, mainQueueBtn.height));
    [self.view addSubview:subQueueBtn];
    [[subQueueBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        dispatch_async(self.queue, ^{
            CBGCDViewController *gcdViewController = (__bridge CBGCDViewController *)dispatch_get_specific(kCBDispatchQueueSpecificKey);
            if (gcdViewController) {
                NSLog(@"subqueue: %@", gcdViewController);
            }
        });
    }];
    
    UIButton *dispatchBlockBtn = createBtn(@"dispatchBlock", CGRectMake(mainQueueBtn.x, subQueueBtn.bottom + 20, mainQueueBtn.width, mainQueueBtn.height));
    [self.view addSubview:dispatchBlockBtn];
    [[dispatchBlockBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        dispatch_queue_t serialQueue = dispatch_queue_create("com.chenbin.gcd.serial", DISPATCH_QUEUE_SERIAL);
        dispatch_queue_t concurrentQueue = dispatch_queue_create("com.chenbin.gcd.c", DISPATCH_QUEUE_CONCURRENT);
        dispatch_block_t firstBlock = dispatch_block_create(0, ^{
            sleep(2);
            NSLog(@"first block end");
        });
        dispatch_block_t secondBlock = dispatch_block_create(0, ^{
            NSLog(@"secong block run");
        });
        dispatch_async(serialQueue, firstBlock);
        dispatch_async(serialQueue, secondBlock);
        dispatch_async(serialQueue, secondBlock);
        
        dispatch_async(concurrentQueue, secondBlock);
        dispatch_block_cancel(secondBlock);
    }];
    
    UIButton *applyBtn = createBtn(@"apply", CGRectMake(mainQueueBtn.x, dispatchBlockBtn.bottom + 20, mainQueueBtn.width, mainQueueBtn.height));
    [self.view addSubview:applyBtn];
    [[applyBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        dispatch_queue_t queue = dispatch_queue_create("com.chenbin.apply.queue", DISPATCH_QUEUE_CONCURRENT);
        NSMutableArray<CBGcdApply *> *array = [NSMutableArray array];
        for (int i = 0; i < 30; i++) {
            [array addObject:[[CBGcdApply alloc] initWithTitle:[NSString stringWithFormat:@"title:%d",i]]];
        }
        dispatch_apply(array.count, queue, ^(size_t index) {
            NSLog(@"%@",array[index].title);
        });
        NSLog(@"完成");
    }];
    
    UIButton *sourceBtn = createBtn(@"sourceTimer", CGRectMake(mainQueueBtn.x, applyBtn.bottom + 20, mainQueueBtn.width, mainQueueBtn.height));
    [self.view addSubview:sourceBtn];
    [[sourceBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        dispatch_source_t source = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER,0, 0, DISPATCH_TARGET_QUEUE_DEFAULT);
        dispatch_source_set_event_handler(source, ^(){
            NSLog(@"Time flies.");
        });
        self.source = source;
        dispatch_source_set_timer(source, DISPATCH_TIME_NOW, 5ull * NSEC_PER_SEC,100ull * NSEC_PER_MSEC);
        dispatch_resume(source);
    }];
}

- (void)setupQueue {
    self.queue = dispatch_queue_create("com.chenbin.specific.queue", DISPATCH_QUEUE_CONCURRENT);
    dispatch_queue_set_specific(self.queue, kCBDispatchQueueSpecificKey, (__bridge void *)(self), NULL);
}

@end
