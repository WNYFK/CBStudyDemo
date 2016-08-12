//
//  CBSkipItem.m
//  CBStudyDemo
//
//  Created by ChenBin on 16/8/12.
//  Copyright © 2016年 ChenBin. All rights reserved.
//

#import "CBSkipItem.h"

@implementation CBSkipItem

@end

@interface CBSectionItem ()

@property (nonatomic, strong) NSMutableArray<CBSkipItem *> *cellItems;

@end

@implementation CBSectionItem

- (instancetype)init {
    self = [super init];
    if (self) {
        self.cellItems = [NSMutableArray array];
    }
    return self;
}

@end