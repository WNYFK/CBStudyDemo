//
//  CBLocalCacheManager.h
//  CBStudyDemo
//
//  Created by ChenBin on 16/8/26.
//  Copyright © 2016年 ChenBin. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, CBLocalCacheType) {
    CBLocalCacheTypePersonal,
    CBLocalCacheTypePublich
};

typedef void(^CBLocalCacheCallBackBlock)(NSObject *result, NSError *error);

@interface CBLocalCacheManager : NSObject

+ (CBLocalCacheManager *)sharedInstance;

- (void)saveObject:(NSObject *)object withPath:(NSString *)path withKey:(NSString *)key withCacheType:(CBLocalCacheType)cacheType;
- (void)deleteObjectWithKey:(NSString *)key withPath:(NSString *)path fromeCacheType:(CBLocalCacheType)cacheType;
- (void)getObjectWithPath:(NSString *)path withKey:(NSString *)key fromCacheType:(CBLocalCacheType)cacheType withCallBack:(CBLocalCacheCallBackBlock)callBackBlock;

@end
