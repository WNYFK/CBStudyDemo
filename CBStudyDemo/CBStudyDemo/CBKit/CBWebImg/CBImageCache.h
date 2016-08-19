//
//  CBImageCache.h
//  CBStudyDemo
//
//  Created by ChenBin on 16/8/18.
//  Copyright © 2016年 ChenBin. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, CBImageCacheType) {
    CBImageCacheTypeNone,
    CBImageCacheTypeDisk,
    CBImageCacheTypeMemory
};

typedef void(^CBWebImageQueryCompletedBlock)(UIImage *image, CBImageCacheType cacheType);
typedef void(^CBWebImageCheckCacheCompletionBlock)(BOOL isInCache);
typedef void(^CBWebImageCalculateSizeBlock)(NSUInteger fileCount, NSUInteger totalSize);

@interface CBImageCache : NSObject

@property (nonatomic, assign) BOOL shouldDecompressImages;
@property (nonatomic, assign) BOOL shouldDisableiCloud;
@property (nonatomic, assign) BOOL shouldCacheImagesInMemory;
@property (nonatomic, assign) NSUInteger maxMemoryCost;
@property (nonatomic, assign) NSUInteger maxMemoryCountLimit;
@property (nonatomic, assign) NSInteger maxCacheAge;
@property (nonatomic, assign) NSUInteger maxCahceSize;

+ (CBImageCache *)sharedImageCache;

- (instancetype)initWithNamespace:(NSString *)ns;

- (instancetype)initWithNamespace:(NSString *)ns diskCacheDirectory:(NSString *)directory;

- (NSOperation *)queryDiskCacheForKey:(NSString *)key done:(CBWebImageQueryCompletedBlock)doneBlock;
- (void)storeImage:(UIImage *)image recalculateFromImage:(BOOL)recalculate imageData:(NSData *)imageData forKey:(NSString *)key toDisk:(BOOL)toDisk;

- (NSString *)makeDiskCachePath:(NSString *)fullNamespace;

@end
