//
//  CBRACTestVIewController.m
//  CBStudyDemo
//
//  Created by ChenBin on 16/9/7.
//  Copyright © 2016年 ChenBin. All rights reserved.
//

#import "CBRACTestVIewController.h"

@interface CBRACTestVIewController ()


@end

@implementation CBRACTestVIewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CBSectionItem *sectionItem = [[CBSectionItem alloc] init];
    [self.dataArr addObject:sectionItem];
    
    CBSkipItem *concatItem = [[CBSkipItem alloc] initWithTitle:@"concat" callBack:^{
        RACSignal *single1 = [[[[RACSignal return:@NO] delay:12] startWith:@YES] setNameWithFormat:@"single1"];
        RACSignal *single2 = [[[[RACSignal return:@YES] delay:10] startWith:@NO] setNameWithFormat:@"single2"];
        [[[[[[[[RACSignal combineLatest:@[single1, single2]]
               and]
              ignore:@NO]
             take:1]
            delay:0.5]
           concat:[RACSignal return:@"Single结果"]]
          skip:1] subscribeNext:^(id x) {
            NSLog(@"aaaa:%@",x);
        }];
    }];
    [sectionItem.cellItems addObject:concatItem];
    
    CBSkipItem *skipItem = [[CBSkipItem alloc] initWithTitle:@"skip" callBack:^{
        RACSignal *single = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            [subscriber sendNext:@1];
            [subscriber sendNext:@2];
            [subscriber sendNext:@3];
            [subscriber sendNext:@4];
            [subscriber sendNext:@5];
            return nil;
        }];
        [[single skip:2] subscribeNext:^(id x) {
            NSLog(@"skip:%@",x);
        }];
    }];
    [sectionItem.cellItems addObject:skipItem];
    
    CBSkipItem *takeItem = [[CBSkipItem alloc] initWithTitle:@"take" callBack:^{
        RACSignal *single = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            [subscriber sendNext:@1];
            [subscriber sendNext:@2];
            [subscriber sendNext:@3];
            return nil;
        }];
        [[single take:2] subscribeNext:^(id x) {
            NSLog(@"take:%@",x);
        }];
    }];
    [sectionItem.cellItems addObject:takeItem];
    
    CBSkipItem *takeUntilItem = [[CBSkipItem alloc] initWithTitle:@"takeUntil" callBack:^{
        RACSignal *single1 = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            __block NSInteger index = 0;
            [NSTimer bk_scheduledTimerWithTimeInterval:5 block:^(NSTimer *timer) {
                [subscriber sendNext:[NSString stringWithFormat:@"takeUntil:%ld",(long)(index++)]];
            } repeats:YES];
            return nil;
        }];
        RACSignal *single2 = [[RACSignal return:@YES] delay:15];
        [[single1 takeUntil:single2] subscribeNext:^(id x) {
            NSLog(@"%@",x);
        }];
    }];
    [sectionItem.cellItems addObject:takeUntilItem];
    
    CBSkipItem *takeLastItem = [[CBSkipItem alloc] initWithTitle:@"takeLast" callBack:^{
        RACSignal *single1 = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            [subscriber sendNext:@1];
            [subscriber sendNext:@2];
            [subscriber sendNext:@3];
            [subscriber sendCompleted];
            return nil;
        }];
        [[single1 takeLast:1] subscribeNext:^(id x) {
            NSLog(@"%@",x);
        }];
    }];
    [sectionItem.cellItems addObject:takeLastItem];
    
    CBSkipItem *mergeItem = [[CBSkipItem alloc] initWithTitle:@"merge" callBack:^{
        RACSignal *single1 = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            __block NSInteger index = 0;
            [NSTimer bk_scheduledTimerWithTimeInterval:5 block:^(NSTimer *timer) {
                [subscriber sendNext:[NSString stringWithFormat:@"single1:%ld",(long)(index++)]];
            } repeats:YES];
            return nil;
        }];
        RACSignal *single2 = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            __block NSInteger index = 0;
            [NSTimer bk_scheduledTimerWithTimeInterval:3 block:^(NSTimer *timer) {
                [subscriber sendNext:[NSString stringWithFormat:@"single2:%ld",(long)(index++)]];
            } repeats:YES];
            return nil;
        }];
        [[single1 merge:single2] subscribeNext:^(id x) {
            NSLog(@"merge--%@",x);
        }];
    }];
    [sectionItem.cellItems addObject:mergeItem];
    
    CBSkipItem *reduceItem = [[CBSkipItem alloc] initWithTitle:@"reduce" callBack:^{
        NSArray *arr = @[@1, @2, @3, @4, @5, @6];
        RACSignal *single = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [subscriber sendNext:obj];
            }];
            [subscriber sendCompleted];
            return nil;
        }];
        [[single aggregateWithStart:@0 reduce:^id(NSNumber *running, NSNumber *next) {
            return @(running.integerValue + next.integerValue);
        }] subscribeNext:^(id x) {
            NSLog(@"reduce:%@",x);
        }];
    }];
    [sectionItem.cellItems addObject:reduceItem];
    
    CBSkipItem *reduceEachItem = [[CBSkipItem alloc] initWithTitle:@"reduceEach" callBack:^{
        RACSignal *single = [RACSignal return:RACTuplePack(@1, @2, @3, @4)];
        [[single reduceEach:^id(NSNumber *value1, NSNumber *value2, NSNumber *value3){
            return @(value1.integerValue + value2.integerValue + value3.integerValue);
        }] subscribeNext:^(id x) {
            NSLog(@"reduceEach:%@",x);
        }];
    }];
    [sectionItem.cellItems addObject:reduceEachItem];
    
    CBSkipItem *zipItem = [[CBSkipItem alloc] initWithTitle:@"zip" callBack:^{
        RACSignal *single1 = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            [subscriber sendNext:@"single1"];
            [subscriber sendCompleted];
            return nil;
        }];
        
        RACSignal *single2 = [RACSignal return:@"single2"];
        [[single1 zipWith:single2] subscribeNext:^(id x) {
            NSLog(@"%@",x);
        }];
    }];
    [sectionItem.cellItems addObject:zipItem];
    
    CBSkipItem *flattenMapItem = [[CBSkipItem alloc] initWithTitle:@"flattenMap" callBack:^{
        RACSignal *single = [RACSignal return:[RACSignal return:@"flattenMap"]];
        [[single flattenMap:^RACStream *(id value) {
            return value;
        }] subscribeNext:^(id x) {
            NSLog(@"%@",x);
        }];
    }];
    [sectionItem.cellItems addObject:flattenMapItem];
    
    CBSkipItem *flattenItem = [[CBSkipItem alloc] initWithTitle:@"flatten---1" callBack:^{
        RACSubject *test1 = [RACSubject subject];
        RACSubject *test2 = [RACSubject subject];
        RACSubject *test3 = [RACSubject subject];
        RACSignal *single = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            [subscriber sendNext:test1];
            [subscriber sendNext:test2];
            [subscriber sendNext:test3];
            return nil;
        }];
        [[single flatten:2] subscribeNext:^(id x) {
            NSLog(@"flatten2:%@",x);
        }];
        [[single flatten:3] subscribeNext:^(id x) {
            NSLog(@"flatten3:%@",x);
        }];
        [[single flatten] subscribeNext:^(id x) {
            NSLog(@"flatten:%@", x);
        }];
        [test1 sendNext:@"test1"];
        [test2 sendNext:@"test2"];
        [test3 sendNext:@"test3"];
    }];
    [sectionItem.cellItems addObject:flattenItem];
    
    CBSkipItem *flatten2Item = [[CBSkipItem alloc] initWithTitle:@"flatten---2" callBack:^{
        RACSignal *single = [RACSignal return:[RACSignal return:@"flatten"]];
        [[single flatten] subscribeNext:^(id x) {
            NSLog(@"%@",x);
        }];
    }];
    [sectionItem.cellItems addObject:flatten2Item];
    
    CBSkipItem *mapItem = [[CBSkipItem alloc] initWithTitle:@"map" callBack:^{
        RACSignal *single = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            [subscriber sendNext:@1];
            [subscriber sendNext:@2];
            [subscriber sendCompleted];
            return nil;
        }];
        [[single map:^id(id value) {
            return [NSString stringWithFormat:@"map:%@",value];
        }] subscribeNext:^(id x) {
            NSLog(@"%@",x);
        }];
    }];
    [sectionItem.cellItems addObject:mapItem];
    
    CBSkipItem *mapReplaceItem = [[CBSkipItem alloc] initWithTitle:@"mapReplace" callBack:^{
        RACSignal *single = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            [subscriber sendNext:@"12"];
            [subscriber sendNext:@"23"];
            [subscriber sendCompleted];
            return nil;
        }];
        [[single mapReplace:@"mapReplace"] subscribeNext:^(id x) {
            NSLog(@"%@",x);
        }];
    }];
    [sectionItem.cellItems addObject:mapReplaceItem];
    
    CBSkipItem *filterItem = [[CBSkipItem alloc] initWithTitle:@"filter" callBack:^{
        RACSignal *single = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            [subscriber sendNext:@1];
            [subscriber sendNext:@2];
            [subscriber sendNext:@3];
            [subscriber sendCompleted];
            return nil;
        }];
        [[single filter:^BOOL(NSNumber *value) {
            return value.integerValue > 2;
        }] subscribeNext:^(id x) {
            NSLog(@"filter: %@",x);
        }];
    }];
    [sectionItem.cellItems addObject:filterItem];
    
    CBSkipItem *startItem = [[CBSkipItem alloc] initWithTitle:@"start" callBack:^{
        RACSignal *single = [[RACSignal return:@"startWith"] startWith:@"start"];
        [single subscribeNext:^(id x) {
            NSLog(@"%@",x);
        }];
    }];
    [sectionItem.cellItems addObject:startItem];
}
@end
