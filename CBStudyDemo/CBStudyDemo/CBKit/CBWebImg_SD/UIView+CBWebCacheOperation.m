//
//  UIView+CBWebCacheOperation.m
//  CBStudyDemo
//
//  Created by ChenBin on 16/8/19.
//  Copyright © 2016年 ChenBin. All rights reserved.
//

#import "UIView+CBWebCacheOperation.h"
#import "CBWebImageOperation.h"
#import <objc/runtime.h>

static char KCBLoadOperationKey;

@implementation UIView (CBWebCacheOperation)

- (NSMutableDictionary *)operationDictionary {
    NSMutableDictionary *operations = objc_getAssociatedObject(self, &KCBLoadOperationKey);
    if (operations) return operations;
    operations = [NSMutableDictionary dictionary];
    objc_setAssociatedObject(self, &KCBLoadOperationKey, operations, OBJC_ASSOCIATION_RETAIN);
    return operations;
}

- (void)cb_setImageLoadOperation:(id)operation forKey:(NSString *)key {
    [self cb_cancelImageLoadOperationWithKey:key];
    NSMutableDictionary *operationDict = [self operationDictionary];
    [operationDict setObject:operation forKey:key];
}

- (void)cb_cancelImageLoadOperationWithKey:(NSString *)key {
    NSMutableDictionary *operationDict = [self operationDictionary];
    id operations = [operationDict objectForKey:key];
    if (operations) {
        if ([operations isKindOfClass:[NSArray class]]) {
            for (id <CBWebImageOperation> operation in operations) {
                if (operation) {
                    [operation cancel];
                }
            }
        } else if ([operations conformsToProtocol:@protocol(CBWebImageOperation)]) {
            [(id<CBWebImageOperation>)operations cancel];
        }
        [operationDict removeObjectForKey:key];
    }
}

- (void)cb_removeImageLoadOperationWithKey:(NSString *)key {
    NSMutableDictionary *operationDict = [self operationDictionary];
    [operationDict removeObjectForKey:key];
}

@end
