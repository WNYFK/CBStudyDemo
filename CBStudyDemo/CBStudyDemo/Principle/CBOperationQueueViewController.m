//
//  CBOperationQueueViewController.m
//  CBStudyDemo
//
//  Created by ChenBin on 2016/11/15.
//  Copyright © 2016年 ChenBin. All rights reserved.
//

#import "CBOperationQueueViewController.h"

@interface CBOperationQueueViewController ()

@property (nonatomic, strong) NSOperationQueue *blockOperationQueue;
@property (nonatomic, strong) NSOperationQueue *operationQueue;

@end

@implementation CBOperationQueueViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.blockOperationQueue = [[NSOperationQueue alloc] init];
    self.blockOperationQueue.maxConcurrentOperationCount = 2;
    
    self.operationQueue = [[NSOperationQueue alloc] init];
    self.operationQueue.maxConcurrentOperationCount = 1;
    
    @weakify(self);
    CBSectionItem *sectionItem = [[CBSectionItem alloc] init];
    [sectionItem.cellItems addObject:[[CBSkipItem alloc] initWithTitle:@"BlockOperation" callBack:^{
        @strongify(self);
        NSBlockOperation *blockOperation1 = [NSBlockOperation blockOperationWithBlock:^{
            NSLog(@"blockOperation1 start");
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 5), dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                NSLog(@"blockOperation1 dispatch after finished");
            });
            NSLog(@"blockOperation1 end");
        }];
        
        NSBlockOperation *blockOperation2 = [NSBlockOperation blockOperationWithBlock:^{
            NSLog(@"blockOperation2 start");
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2), dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                NSLog(@"blockOperation2 dispatch after finished");
            });
            NSLog(@"blockOperation2 end");
        }];
        [blockOperation2 addDependency:blockOperation1];
        [self.blockOperationQueue addOperation:blockOperation1];
        [self.blockOperationQueue addOperation:blockOperation2];
    }]];
}

@end
