//
//  CBSkipItem.m
//  CBStudyDemo
//
//  Created by ChenBin on 16/8/12.
//  Copyright © 2016年 ChenBin. All rights reserved.
//

#import "CBSkipItem.h"

@implementation CBSkipItem

- (instancetype)initWithTitle:(NSString *)title destinationClass:(Class)dClass {
    if (self = [super init]) {
        self.title = title;
        self.destinationClass = dClass;
    }
    return self;
}

- (instancetype)initWithTitle:(NSString *)title callBack:(CBNormalCallBack)callBack {
    if (self = [super init]) {
        self.title = title;
        self.callBack = callBack;
    }
    return self;
}
@end

@interface CBSectionItem ()

@property (nonatomic, strong) NSMutableArray<CBSkipItem *> *cellItems;

@end

@implementation CBSectionItem

- (instancetype)initWithTitle:(NSString *)title {
    if (self = [self init]) {
        self.title = title;
    }
    return self;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.cellItems = [NSMutableArray array];
    }
    return self;
}

@end