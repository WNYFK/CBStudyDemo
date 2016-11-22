//
//  CBRuntimeViewController.m
//  CBStudyDemo
//
//  Created by ChenBin on 2016/11/22.
//  Copyright © 2016年 ChenBin. All rights reserved.
//

#import "CBRuntimeViewController.h"

@interface CBFather : NSObject

@end

@interface CBSon : CBFather

- (void)print;


@end

@interface CBRuntimeViewController ()

@end

@implementation CBRuntimeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    CBSectionItem *sectionItem = [[CBSectionItem alloc] init];
    [self.dataArr addObject:sectionItem];
    
    [sectionItem.cellItems addObject:[[CBSkipItem alloc] initWithTitle:@"self & super" callBack:^{
        CBSon *son = [[CBSon alloc] init];
        [son print];
    }]];
}

@end


@implementation CBFather

- (instancetype)init {
    if (self = [super init]) {
        NSLog(@"Father: %@",[self class]);
    }
    return self;
}


@end


@implementation CBSon

- (instancetype)init {
    if (self = [super init]) {
        NSLog(@"Son: %@====%@",[self class], [super class]);
    }
    return self;
}

- (void)print {
    NSLog(@"%@", self);
}

@end
