//
//  CBCatonObserver.m
//  CBStudyDemo
//
//  Created by chenbin on 16/8/24.
//  Copyright © 2016年 ChenBin. All rights reserved.
//

#import "CBCatonObserver.h"

@interface CBCatonThread : NSThread

@end

@implementation CBCatonObserver

+ (CBCatonObserver *)sharedInstance {
    static CBCatonObserver *catonObserver;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        catonObserver = [[CBCatonObserver alloc] init];
    });
    return catonObserver;
}

- (void)startObserver {
    
}

@end


@implementation CBCatonThread



@end