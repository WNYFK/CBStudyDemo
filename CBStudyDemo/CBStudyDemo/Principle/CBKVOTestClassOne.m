//
//  CBKVOTestClassOne.m
//  CBStudyDemo
//
//  Created by ChenBin on 16/8/16.
//  Copyright © 2016年 ChenBin. All rights reserved.
//

#import "CBKVOTestClassOne.h"
#import <objc/runtime.h>

@implementation CBKVOTestClassOne

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    NSLog(@"asdf");
}

@end
