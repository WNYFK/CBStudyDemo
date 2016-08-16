//
//  NSObject+KVO.h
//  CBStudyDemo
//
//  Created by ChenBin on 16/8/16.
//  Copyright © 2016年 ChenBin. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^CBObservingBlock)(_Nonnull id observedObject,  NSString * _Nonnull observedKey, _Nonnull id oldValue, _Nonnull id newValue);

@interface NSObject (KVO)

- (void)CB_addObserver:(NSObject  * _Nonnull )observer forKey:(NSString * _Nonnull)key withBlock:(CBObservingBlock _Nonnull)block;
- (void)CB_removeObserver:(NSObject * _Nonnull)observer forKey:(NSString * _Nonnull)key;

@end
