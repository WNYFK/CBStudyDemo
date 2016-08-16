//
//  CBObject+KVC.m
//  CBStudyDemo
//
//  Created by ChenBin on 16/8/16.
//  Copyright © 2016年 ChenBin. All rights reserved.
//

#import "CBObject+KVC.h"
#import <objc/runtime.h>

@implementation CBObject_KVC

- (id)valueForKey:(NSString *)key {
    SEL getterSEL = NSSelectorFromString(key);
    if ([self respondsToSelector:getterSEL]) {
        NSMethodSignature *signature = [self methodSignatureForSelector:getterSEL];
        char type = [signature methodReturnType][0];
        IMP imp = [self methodForSelector:getterSEL];
        if (type == @encode(id)[0] || type == @encode(Class)[0]) {
            return ((id (*)(id, SEL))imp)(self, getterSEL);
        } else {
            switch (type) {
                #define CB_CASE(_typeChar, _type) \
                    case _typeChar: {   \
                    return @(((_type (*)(id, SEL))imp)(self, getterSEL));    \
                    break;  \
                }
                CB_CASE('i', int)
                CB_CASE('B', BOOL)
                CB_CASE('I', unsigned int)
                CB_CASE('S', unsigned short)
                CB_CASE('c', char)
                CB_CASE('f', float)
                CB_CASE('s', short)
                CB_CASE('d', double)
                default:
                    break;
            }
        }
        
    }
    Ivar ivar = class_getClassVariable(object_getClass(self), key.UTF8String);
    if (!ivar) {
        ivar = class_getInstanceVariable(object_getClass(self), [[@"_" stringByAppendingString:key] UTF8String]);
    }
    if (ivar) {
        
    }
    return nil;
}

@end

