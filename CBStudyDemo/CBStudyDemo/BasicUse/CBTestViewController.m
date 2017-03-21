//
//  CBTestViewController.m
//  CBStudyDemo
//
//  Created by ChenBin on 2016/11/25.
//  Copyright © 2016年 ChenBin. All rights reserved.
//

#import "CBTestViewController.h"
#import "CBTestObject.h"

@interface CBFirstView : UIView
@end

@interface CBSecView : UIView

@end

@interface CBSuperView : UIView
@property (nonatomic, strong) CBFirstView *firstView;
@property (nonatomic, strong) CBSecView *secView;

@end

@interface CBTestViewController ()

@property (atomic, assign) int intA;
@property (nonatomic, strong) NSCondition *condition;
@property (nonatomic, strong) NSMutableArray *products;

@property (nonatomic, strong) CBTestObject *testObject;

@end




@implementation CBTestViewController

- (void)createConsumenr
{
    [self.condition lock];
    while(self.products.count == 0) {
        NSLog(@"等待产品");
        [_condition wait];
    }
    [self.products removeObject:0];
    NSLog(@"消费产品");
    [_condition unlock];
}

- (void)createProducter
{
    [self.condition lock];
    [self.products addObject:[[NSObject alloc] init]];
    NSLog(@"生产了一个产品");
    [_condition signal];
    [_condition unlock];
}

- (NSMutableArray *)products
{
    if(_products == nil){
        _products = [[NSMutableArray alloc] initWithCapacity:30];
    }
    return _products;
}

- (NSCondition *)condition
{
    if(_condition == nil){
        _condition = [[NSCondition alloc] init];
    }
    return _condition;
}

- (void)testBlock {
    [self.testObject finished:^(NSDictionary *dict) {
        NSLog(@"啊啊啊啊: %@",dict);
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.intA = 0;
//    self.tableView.hidden = YES;

    self.testObject = [[CBTestObject alloc] init];
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem creatBarButtonWithTitle:@"block" callBack:^(UIBarButtonItem *buttonItem) {
        [self testBlock];
    }];
    
    [NSThread detachNewThreadSelector:@selector(createConsumenr) toTarget:self withObject:nil];
    [NSThread detachNewThreadSelector:@selector(createProducter) toTarget:self withObject:nil];
    
    CBSectionItem *sectionItem = [[CBSectionItem alloc] init];
    [self.dataArr addObject:sectionItem];
    
    [sectionItem.cellItems addObject:[[CBSkipItem alloc] initWithTitle:@"GCD test" callBack:^{
        dispatch_queue_t queue = dispatch_queue_create("com.chenbin.gcd", DISPATCH_QUEUE_CONCURRENT);
        NSLog(@"1");
        dispatch_async(queue, ^{
            NSLog(@"2");
            dispatch_sync(queue, ^{
                NSLog(@"3");
            });
            NSLog(@"4");
        });
        dispatch_async(queue, ^{
            NSLog(@"6");
            sleep(10);
            NSLog(@"7");
        });
        NSLog(@"5");
    }]];
    
    [sectionItem.cellItems addObject:[[CBSkipItem alloc] initWithTitle:@"globalQueue barrer sync" callBack:^{
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0);
        dispatch_async(queue, ^{
            NSLog(@"1111");
            sleep(10);
            NSLog(@"2222");
        });
        dispatch_barrier_sync(queue, ^{
            NSLog(@"asdfasd");
        });
        NSLog(@"333");
    }]];
    
    [sectionItem.cellItems addObject:[[CBSkipItem alloc] initWithTitle:@"myQueue barrer sync" callBack:^{
        dispatch_queue_t queue = dispatch_queue_create("com.chenbin.queue", DISPATCH_QUEUE_CONCURRENT);
        dispatch_async(queue, ^{
            NSLog(@"1111");
            sleep(10);
            NSLog(@"2222");
        });
        dispatch_barrier_sync(queue, ^{
            NSLog(@"asdfasd");
        });
        NSLog(@"333");
        
    
    }]];
    
    [sectionItem.cellItems addObject:[[CBSkipItem alloc] initWithTitle:@"lock" callBack:^{
        NSLock *lock = [[NSLock alloc] init];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [lock lock];
            NSLog(@"aaa");
            sleep(10);
            [lock unlock];
            NSLog(@"aaasss");
        });
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [lock lock];
            NSLog(@"bbbb");
            sleep(5);
            [lock unlock];
            NSLog(@"bbsss");
        });
    }]];
    
    [sectionItem.cellItems addObject:[[CBSkipItem alloc] initWithTitle:@"syn" callBack:^{
        NSObject *obj = [NSObject new];
        @synchronized (obj) {
            NSLog(@"aaaa");
            @synchronized (obj) {
                obj = nil;
                NSLog(@"bbbb");
            }
            NSLog(@"ccc");
        }
        NSLog(@"dddd");
    }]];
    
    [sectionItem.cellItems addObject:[[CBSkipItem alloc] initWithTitle:@"atomic" callBack:^{
        dispatch_queue_t queue1 = dispatch_queue_create("com.chenbin.queue1", DISPATCH_QUEUE_CONCURRENT);
        dispatch_queue_t queue2 = dispatch_queue_create("com.chenbin.queue2", DISPATCH_QUEUE_CONCURRENT);
        dispatch_async(queue1, ^{
            for (int i = 0; i < 10000; i ++) {
                self.intA = self.intA + 1;
                NSLog(@"Thread A: %d\n", self.intA);
            }
        });
        
        dispatch_async(queue2, ^{
            for (int i = 0; i < 10000; i ++) {
                self.intA = self.intA + 1;
                NSLog(@"Thread B: %d\n", self.intA);
            }
        });
    }]];
    
    [sectionItem.cellItems addObject:[[CBSkipItem alloc] initWithTitle:@"全局队列和自建队列" callBack:^{
        dispatch_queue_t queue = dispatch_queue_create("com.chenbin.queue1", DISPATCH_QUEUE_CONCURRENT);
        dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
        for (int i = 0; i < 100; i++) {
            dispatch_async(globalQueue, ^{
//                NSLog(@"GlobalQueue 开始:%d",i);
//                sleep(5);
//                NSLog(@"GlobalQueue 结束:%d",i);
                dispatch_async(globalQueue, ^{
                    NSLog(@"GlobalQueue1111");
                    sleep(10);
                    NSLog(@"GlobalQueue2222");
                });
                dispatch_barrier_sync(globalQueue, ^{
                    NSLog(@"GlobalQueueasdfasd");
                });
                NSLog(@"GlobalQueue333");
            });
            dispatch_async(queue, ^{
//                NSLog(@"Queue 开始:%d",i);
//                sleep(5);
//                NSLog(@"Queue 结束:%d",i);
                dispatch_async(queue, ^{
                    NSLog(@"1111");
                    sleep(10);
                    NSLog(@"2222");
                });
                dispatch_barrier_sync(queue, ^{
                    NSLog(@"asdfasd");
                });
                NSLog(@"333");
            });
        }
    }]];
    
    [sectionItem.cellItems addObject:[[CBSkipItem alloc] initWithTitle:@"crash" callBack:^{
        dispatch_queue_t queue = dispatch_queue_create("com.chenbin.queue", DISPATCH_QUEUE_SERIAL);
        dispatch_async(queue, ^{
            sleep(50);
            NSArray *arr = [NSArray array];
            NSLog(@"%@", arr[1]);
        });
    }]];
}
@end


@implementation CBFirstView

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    NSLog(@"CBFirstView touchBegan");
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    NSLog(@"CBFirstView hitTest");
    UIView *view = [super hitTest:point withEvent:event];
    return view;
}

@end

@implementation CBSecView

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    [super touchesBegan:touches withEvent:event];
    NSLog(@"CBSecView touchBegan");
}


- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    NSLog(@"CBSecView hitTest");

    UIView *view = [super hitTest:point withEvent:event];
    return view;
}

- (BOOL)canBecomeFirstResponder {
    return YES;
}

@end


@implementation CBSuperView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.firstView = [[CBFirstView alloc] initWithFrame:CGRectMake(10, 50, 200, 200)];
        self.firstView.backgroundColor = [UIColor yellowColor];
        [self addSubview:self.firstView];
        
        self.secView = [[CBSecView alloc] initWithFrame:CGRectMake(10, 20, 100, 100)];
        self.secView.backgroundColor = [UIColor greenColor];
        [self.firstView addSubview:self.secView];
    }
    return self;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    [super touchesBegan:touches withEvent:event];
    NSLog(@"CBSuperView touchBegan");
}


- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    NSLog(@"CBSuperView hitTest");
    UIView *view = [super hitTest:point withEvent:event];
    return view;
//    return self.secView;
}

@end
