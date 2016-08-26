//
//  CBLocalCacheManager.m
//  CBStudyDemo
//
//  Created by ChenBin on 16/8/26.
//  Copyright © 2016年 ChenBin. All rights reserved.
//

#import "CBLocalCacheManager.h"

//待完成

@interface CBLocalCacheManager ()

@property (nonatomic, strong) dispatch_queue_t ioQueue;
@property (nonatomic, strong) dispatch_group_t checkFileGroup;
@property (nonatomic, strong) NSString *personalRootPath;
@property (nonatomic, strong) NSString *publichRootPath;

@end

@implementation CBLocalCacheManager

- (instancetype)init {
    if (self = [super init]) {
        self.checkFileGroup = dispatch_group_create();
        self.ioQueue = dispatch_queue_create("com.chenbin.ioQueue", DISPATCH_QUEUE_CONCURRENT);
        [self setupPersonalBasePath];
        [self setupPublichBasePath];
    }
    return self;
}

- (void)setupPersonalBasePath {
    NSArray *cachePaths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    self.personalRootPath = [cachePaths[0] stringByAppendingPathComponent:@"com.chenbin.personalCache"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:self.personalRootPath]) {
        [fileManager createDirectoryAtPath:self.personalRootPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
}

- (void)setupPublichBasePath {
    NSArray *cachePaths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    self.publichRootPath = [cachePaths[0] stringByAppendingPathComponent:@"com.chenbin.publichCache"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:self.publichRootPath]) {
        [fileManager createDirectoryAtPath:self.publichRootPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
}

+ (CBLocalCacheManager *)sharedInstance {
    static CBLocalCacheManager *cacheManager;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        cacheManager = [[CBLocalCacheManager alloc] init];
    });
    return cacheManager;
}

- (void)saveObject:(NSObject *)object withPath:(NSString *)path withKey:(NSString *)key withCacheType:(CBLocalCacheType)cacheType {
    dispatch_async(self.ioQueue, ^{
        NSFileManager *fileManager = [[NSFileManager alloc] init];
        [fileManager createDirectoryAtPath:[self.publichRootPath stringByAppendingPathComponent:path] withIntermediateDirectories:YES attributes:nil error:nil];
        if ([object isKindOfClass:[NSString class]]) {
            [(NSString *)object writeToFile:[[self.publichRootPath stringByAppendingPathComponent:path]  stringByAppendingPathComponent:key] atomically:YES encoding:NSUTF8StringEncoding error:nil];
        }
    });
}


- (void)getObjectWithPath:(NSString *)path withKey:(NSString *)key fromCacheType:(CBLocalCacheType)cacheType withCallBack:(CBLocalCacheCallBackBlock)callBackBlock {
    
}

- (void)deleteObjectWithKey:(NSString *)key withPath:(NSString *)path fromeCacheType:(CBLocalCacheType)cacheType {
    
}

@end
