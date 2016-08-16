//
//  NSObject+KVO.m
//  CBStudyDemo
//
//  Created by ChenBin on 16/8/16.
//  Copyright © 2016年 ChenBin. All rights reserved.
//

#import "NSObject+KVO.h"
#import <objc/runtime.h>
#import <objc/message.h>
#import "CBKVORealizeViewController.h"

NSString *const KCBKVOClassPrefix = @"CBKVOClassPrefix_";
NSString *const KCBKVOAssociatedObservers = @"CBKVOAssociatedObservers";

@interface CBObserverInfo : NSObject

@property (nonatomic, weak) NSObject *observer;
@property (nonatomic, copy) NSString *key;
@property (nonatomic, copy) CBObservingBlock block;

- (instancetype)initWithObserver:(NSObject *)observer key:(NSString *)key block:(CBObservingBlock)block;

@end


static NSString *getterForSetter(NSString *setter) {
    if (setter.length <= 0 || ![setter hasPrefix:@"set"] || ![setter hasSuffix:@":"]) {
        return nil;
    }
    
    NSRange range = NSMakeRange(3, setter.length - 4);
    NSString *key = [setter substringWithRange:range];
    
    NSString *firstLetter = [[key substringToIndex:1] lowercaseString];
    key = [key stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:firstLetter];
    return key;
}

static NSString *setterForGetter(NSString *getter) {
    if (getter.length <= 0) {
        return nil;
    }
    
    NSString *firstLetter = [[getter substringToIndex:1] uppercaseString];
    NSString *remainingLetters = [getter substringFromIndex:1];
    
    NSString *setter = [NSString stringWithFormat:@"set%@%@:",firstLetter, remainingLetters];
    return setter;
}

static void sendKVO(id self, NSString *getterName, id oldValue, id newValue) {
    NSMutableArray *observers = objc_getAssociatedObject(self, (__bridge const void *)(KCBKVOAssociatedObservers));
    for (CBObserverInfo *observerInfo in observers) {
        if ([observerInfo.key isEqualToString:getterName]) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                observerInfo.block(self, getterName, oldValue, newValue);
            });
        }
    }
}

static void kvo_setter(id self, SEL _cmd, id newValue) {
    NSString *setterName = NSStringFromSelector(_cmd);
    NSString *getterName = getterForSetter(setterName);
    if (!getterName) {
        NSString *reason = [NSString stringWithFormat:@"Object %@ does not have setter %@", self, setterName];
        @throw [NSException exceptionWithName:NSInvalidArgumentException reason:reason userInfo:nil];
        return;
    }
    
    struct objc_super superClass = {
        .receiver = self,
        .super_class = class_getSuperclass(object_getClass(self))
    };
    id oldValue = [self valueForKey:getterName];
    void (*objc_msgSendSuperCasted)(void *, SEL, id) = (void *)objc_msgSendSuper;
    objc_msgSendSuperCasted(&superClass, _cmd, newValue);
    sendKVO(self, getterName, oldValue, newValue);
}

static Class kvo_class(id self, SEL _cmd) {
    return class_getSuperclass(object_getClass(self));
}

static NSMutableDictionary *_basicTypeEncodeDict;
#define CB_DEFINE_TYPE_ENCODE_CASE(_type) [_basicTypeEncodeDict setObject:@#_type forKey:[NSString stringWithUTF8String:@encode(_type)]];

@implementation NSObject (KVO)

- (void)CB_addObserver:(NSObject *)observer forKey:(NSString *)key withBlock:(CBObservingBlock)block {
    SEL setterSelector = NSSelectorFromString(setterForGetter(key));
    Method setterMehod = class_getInstanceMethod([self class], setterSelector);
    if (!setterMehod) {
        NSString *reason = [NSString stringWithFormat:@"OBject %@ does not have a setter for key %@", self, key];
        @throw [NSException exceptionWithName:NSInvalidArgumentException reason:reason userInfo:nil];
        return;
    }
    
    Class clazz = object_getClass(self);
    NSString *clazzName = NSStringFromClass(clazz);
    
    if (![clazzName hasPrefix:KCBKVOClassPrefix]) {
        clazz = [self makeKvoClassWithOriginalClassName:clazzName];
        object_setClass(self, clazz);
    }
    
    if (![self hasSelector:setterSelector]) {
        if (!_basicTypeEncodeDict) {
            _basicTypeEncodeDict = [[NSMutableDictionary alloc] init];
            CB_DEFINE_TYPE_ENCODE_CASE(BOOL);
            CB_DEFINE_TYPE_ENCODE_CASE(int);
            CB_DEFINE_TYPE_ENCODE_CASE(char);
            CB_DEFINE_TYPE_ENCODE_CASE(short);
            CB_DEFINE_TYPE_ENCODE_CASE(unsigned short);
            CB_DEFINE_TYPE_ENCODE_CASE(unsigned int);
            CB_DEFINE_TYPE_ENCODE_CASE(long);
            CB_DEFINE_TYPE_ENCODE_CASE(unsigned long);
            CB_DEFINE_TYPE_ENCODE_CASE(long long);
            CB_DEFINE_TYPE_ENCODE_CASE(float);
            CB_DEFINE_TYPE_ENCODE_CASE(double);
        }
        const char *types = method_getTypeEncoding(setterMehod);
        NSString *methodType = [NSString stringWithUTF8String:method_getTypeEncoding(setterMehod)];
        methodType = [methodType componentsSeparatedByString:@"@0:8"].lastObject;
        NSString *valueEncodeType = [methodType substringToIndex:methodType.length - 2];
        IMP childSetValue = nil;
        NSString *valueType = _basicTypeEncodeDict[valueEncodeType];
        if (valueType) {
            #define CB_SetterBasicTypeIMP(type) imp_implementationWithBlock(^(id _self, type newValue) { \
                    id oldValue = [observer valueForKey:key];    \
                    IMP superSetterIMP = class_getMethodImplementation(class_getSuperclass(object_getClass(self)), setterSelector); \
                    void (*setterSel)(void*, SEL, int) = (void *)superSetterIMP; \
                    setterSel((__bridge void *)(_self), setterSelector, newValue); \
                    sendKVO(self, key, oldValue, @(newValue)); \
                });
            switch ([valueEncodeType UTF8String][0]) {
                #define CB_Setter_ARG_CASE(_typeChar, _type) \
                case _typeChar: {   \
                    childSetValue = CB_SetterBasicTypeIMP(_type);   \
                    break;  \
                }
                CB_Setter_ARG_CASE('i', int)
                CB_Setter_ARG_CASE('B', BOOL)
                CB_Setter_ARG_CASE('I', unsigned int)
                CB_Setter_ARG_CASE('S', unsigned short)
                CB_Setter_ARG_CASE('c', char)
                CB_Setter_ARG_CASE('f', float)
                CB_Setter_ARG_CASE('s', short)
                CB_Setter_ARG_CASE('d', double)
                default:
                    break;
            }
        } else {
            childSetValue = (IMP)kvo_setter;
        }
        class_addMethod(clazz, setterSelector, childSetValue, types);
    }
    
    CBObserverInfo *observerInfo = [[CBObserverInfo alloc] initWithObserver:observer key:key block:block];
    NSMutableArray *observers = objc_getAssociatedObject(self, (__bridge const void *)(KCBKVOAssociatedObservers));
    if (!observers) {
        observers = [NSMutableArray array];
        objc_setAssociatedObject(self, (__bridge const void *)(KCBKVOAssociatedObservers), observers, OBJC_ASSOCIATION_RETAIN);
    }
    [observers addObject:observerInfo];
}

- (void)CB_removeObserver:(NSObject *)observer forKey:(NSString *)key {
    NSMutableArray *observers = objc_getAssociatedObject(self, (__bridge const void *)(KCBKVOAssociatedObservers));
    
    CBObserverInfo *observerInfo;
    for (CBObserverInfo *info in observers) {
        if (info.observer == observer && [info.key isEqualToString:key]) {
            observerInfo = info;
            break;
        }
    }
    [observers removeObject:observerInfo];
}

- (BOOL)hasSelector:(SEL)selector {
    Class clazz = object_getClass(self);
    unsigned int mehodCount = 0;
    Method *methodList = class_copyMethodList(clazz, &mehodCount);
    for (unsigned int i = 0; i < mehodCount; i++) {
        SEL thisSelector = method_getName(methodList[i]);
        if (thisSelector == selector) {
            free(methodList);
            return YES;
        }
    }
    free(methodList);
    return NO;
}

- (Class)makeKvoClassWithOriginalClassName:(NSString *)originalClazzName {
    NSString *kvoClazzName = [KCBKVOClassPrefix stringByAppendingString:originalClazzName];
    Class clazz = NSClassFromString(kvoClazzName);
    if (clazz) {
        return clazz;
    }
    
    Class originalClazz = object_getClass(self);
    Class kvoClass = objc_allocateClassPair(originalClazz, kvoClazzName.UTF8String, 0);
    
    Method clazzMehod = class_getInstanceMethod(originalClazz, @selector(class));
    const char *types = method_getTypeEncoding(clazzMehod);
    class_addMethod(kvoClass, @selector(class), (IMP)kvo_class, types);
    objc_registerClassPair(kvoClass);
    return kvoClass;
}

@end

@implementation CBObserverInfo

- (instancetype)initWithObserver:(NSObject *)observer key:(NSString *)key block:(CBObservingBlock)block {
    if (self = [super init]) {
        self.observer = observer;
        self.key = key;
        self.block = block;
    }
    return self;
}

@end
