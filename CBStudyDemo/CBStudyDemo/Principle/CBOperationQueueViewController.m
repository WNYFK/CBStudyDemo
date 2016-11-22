//
//  CBOperationQueueViewController.m
//  CBStudyDemo
//
//  Created by ChenBin on 2016/11/15.
//  Copyright © 2016年 ChenBin. All rights reserved.
//

#import "CBOperationQueueViewController.h"
#import "CBOperation.h"

@interface CBOperationQueueViewController ()

@property (nonatomic, strong) NSOperationQueue *blockOperationQueue;
@property (nonatomic, strong) NSOperationQueue *operationQueue;
@property (nonatomic, strong) NSMutableArray<NSOperation *> *operations;

@end

@implementation CBOperationQueueViewController

- (void)dealloc {
    [self.operationQueue cancelAllOperations];
    [self.blockOperationQueue cancelAllOperations];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    NSLog(@"%@",self.operationQueue.operations);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.blockOperationQueue = [[NSOperationQueue alloc] init];
    self.blockOperationQueue.maxConcurrentOperationCount = 2;
    
    self.operationQueue = [[NSOperationQueue alloc] init];
    self.operationQueue.maxConcurrentOperationCount = 2;
    self.operations = [NSMutableArray array];
    
    @weakify(self);
    CBSectionItem *sectionItem1 = [[CBSectionItem alloc] initWithTitle:@"BlockOperation"];
    dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    [sectionItem1.cellItems addObject:[[CBSkipItem alloc] initWithTitle:@"BlockOperation dispatch_async" callBack:^{
        @strongify(self);
        NSBlockOperation *blockOperation1 = [NSBlockOperation blockOperationWithBlock:^{
            NSLog(@"cell1 blockOperation1 start");
            dispatch_async(globalQueue, ^{
                NSLog(@"cell1 blockOperation1 globalQueue");
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 15 * NSEC_PER_SEC), globalQueue, ^{
                    NSLog(@"cell1 blockOperation1 dispatch after finished");
                });
            });
            
            NSLog(@"cell1 blockOperation1 end");
        }];
        
        NSBlockOperation *blockOperation2 = [NSBlockOperation blockOperationWithBlock:^{
            NSLog(@"cell1 blockOperation2 start");
            dispatch_async(globalQueue, ^{
                NSLog(@"cell1 blockOperation2 global");
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC), globalQueue, ^{
                    NSLog(@"cell1 blockOperation2 dispatch after finished");
                });
            });
            
            NSLog(@"cell1 blockOperation2 end");
        }];
        [blockOperation2 addDependency:blockOperation1];
        [self.blockOperationQueue addOperation:blockOperation1];
        [self.blockOperationQueue addOperation:blockOperation2];
    }]];
    
    [sectionItem1.cellItems addObject:[[CBSkipItem alloc] initWithTitle:@"BlockOperation dispatch_after" callBack:^{
        @strongify(self);
        NSBlockOperation *blockOperation1 = [NSBlockOperation blockOperationWithBlock:^{
            NSLog(@"cell2 blockOperation1 start");
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 15 * NSEC_PER_SEC), globalQueue, ^{
                NSLog(@"cell2 blockOperation1 dispatch after finished");
            });
            NSLog(@"cell2 blockOperation1 end");
        }];
        
        NSBlockOperation *blockOperation2 = [NSBlockOperation blockOperationWithBlock:^{
            NSLog(@"cell2 blockOperation2 start");
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC), globalQueue, ^{
                NSLog(@"cell2 blockOperation2 dispatch after finished");
            });
            NSLog(@"cell2 blockOperation2 end");
        }];
        [blockOperation2 addDependency:blockOperation1];
        [self.blockOperationQueue addOperation:blockOperation1];
        [self.blockOperationQueue addOperation:blockOperation2];
    }]];
    [self.dataArr addObject:sectionItem1];
    
    CBSectionItem *sectionItem2 = [[CBSectionItem alloc] initWithTitle:@"Operation"];
   __block CBOperation *operation1;
    [sectionItem2.cellItems addObject:[[CBSkipItem alloc] initWithTitle:@"开始Operation异步处理" callBack:^{
        for (int i = 0; i < 10; i++) {
            operation1 = [[CBOperation alloc] initWithPersistTime:5 + i * 5];
            CBOperation *operation2 = [[CBOperation alloc] initWithPersistTime:3 + i * 3];
//            [operation2 addDependency:operation1];
            [self.operationQueue addOperation:operation1];
//            [self.operationQueue addOperation:operation2];
            if (i % 2 == 0) {
                [self.operations addObject:operation1];
            }
        }
    }]];
    [sectionItem2.cellItems addObject:[[CBSkipItem alloc] initWithTitle:@"取消Operation处理" callBack:^{
        [self.operations enumerateObjectsUsingBlock:^(NSOperation * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj cancel];
        }];
//        [operation1 cancel];
    }]];
    [self.dataArr addObject:sectionItem2];
}

@end
