//
//  CBTestObject.m
//  CBStudyDemo
//
//  Created by ChenBin on 2017/3/6.
//  Copyright © 2017年 ChenBin. All rights reserved.
//

#import "CBTestObject.h"

@implementation CBTestObject

- (void)finished:(void (^)(NSDictionary *))callBack {
    NSLog(@"回调啊");
    callBack(@{@"key" : @"value"});
}

@end
