//
//  CBWebImageManager.m
//  CBStudyDemo
//
//  Created by ChenBin on 16/8/18.
//  Copyright © 2016年 ChenBin. All rights reserved.
//

#import "CBWebImageManager.h"
#import "CBWebImageDownloader.h"
#import "CBWebImageDownloaderOperation.h"
#import "CBImageCache.h"


@interface CBWebImageCombinedOperation : NSObject<CBWebImageOperation>

@property (nonatomic, assign, getter = isCancelled) BOOL cancelled;
@property (nonatomic, copy) CBWebImageNoParamsBlock cancelBlock;
@property (nonatomic, strong) NSOperation *cacheOperation;

@end

@interface CBWebImageManager ()

@property (nonatomic, strong) CBImageCache *imgCache;
@property (nonatomic, strong) CBWebImageDownloader *imageDownloader;
@property (nonatomic, strong) NSMutableSet *failedURLs;
@property (nonatomic, strong) NSMutableArray *runningOperations;

@end

@implementation CBWebImageManager

+ (CBWebImageManager *)sharedManager {
    static dispatch_once_t once;
    static CBWebImageManager *imageManager;
    dispatch_once(&once, ^{
        imageManager = [[CBWebImageManager alloc] init];
    });
    return imageManager;
}

- (instancetype)init {
    CBWebImageDownloader *downloader = [CBWebImageDownloader sharedDownloader];
    return [self initWithDownloader:downloader cache:[CBImageCache sharedImageCache]];
}

- (instancetype)initWithDownloader:(CBWebImageDownloader *)downloader cache:(CBImageCache *)cache {
    if (self = [super init]) {
        self.imgCache = cache;
        self.imageDownloader = downloader;
        self.failedURLs = [NSMutableSet new];
        self.runningOperations = [NSMutableArray new];
    }
    return self;
}

- (NSString *)cacheKeyForURL:(NSURL *)url {
    if (!url) return @"";
    return [url absoluteString];
}

- (id <CBWebImageOperation>)downloadImageWithURL:(NSURL *)url progress:(CBWebImageDownloaderProgressBlock)progresssBlock completed:(CBWebImageDownloaderCompletedBlock)completedBlock {
    
    __block CBWebImageCombinedOperation *combinedOperation = [CBWebImageCombinedOperation new];
    __weak CBWebImageCombinedOperation *weakCombinedOperation = combinedOperation;
    
    @synchronized (self.runningOperations) {
        [self.runningOperations addObject:combinedOperation];
    }
    
    NSString *key = [self cacheKeyForURL:url];
    combinedOperation.cacheOperation = [self.imgCache queryDiskCacheForKey:key done:^(UIImage *image, CBImageCacheType cacheType) {
        if (combinedOperation.isCancelled) {
            @synchronized (self.runningOperations) {
                [self.runningOperations removeObject:combinedOperation];
            }
            return ;
        }
        if (image) {
            CB_dispatch_main_sync_safe(^{
                __strong __typeof(weakCombinedOperation) strongOperation = weakCombinedOperation;
                if (strongOperation && !strongOperation.isCancelled) {
                    completedBlock(image, nil, cacheType, nil, YES, url);
                }
            });
        } else {
            CBWebImageDownloaderOperation * operation = [self.imageDownloader downloadImageWithURL:url progress:progresssBlock completer:^(UIImage *image, NSData *data, CBImageCacheType cacheType, NSError *error, BOOL finished, NSURL *url) {
                if (error) {
                    CB_dispatch_main_sync_safe(^{
                        completedBlock(nil, nil, CBImageCacheTypeNone, error, YES, url);
                    });
                    if (error.code != NSURLErrorNotConnectedToInternet
                        && error.code != NSURLErrorCancelled
                        && error.code != NSURLErrorTimedOut
                        && error.code != NSURLErrorInternationalRoamingOff
                        && error.code != NSURLErrorDataNotAllowed
                        && error.code != NSURLErrorCannotFindHost
                        && error.code != NSURLErrorCannotConnectToHost) {
                        @synchronized (self.failedURLs) {
                            [self.failedURLs addObject:url];
                        }
                    }
                } else {
                    @synchronized (self.failedURLs) {
                        [self.failedURLs removeObject:url];
                    }
                    if (image && finished) {
                        [self.imgCache storeImage:image recalculateFromImage:NO imageData:data forKey:key toDisk:YES];
                    }
                    CB_dispatch_main_sync_safe(^{
                        completedBlock(image, data, CBImageCacheTypeNone, error, finished, url);
                    });
                    [self.runningOperations removeObject:operation];
                }
            }];
            
            combinedOperation.cancelBlock = ^{
                [operation cancel];
                @synchronized (self.runningOperations) {
                    __strong __typeof(weakCombinedOperation) strongOperation = weakCombinedOperation;
                    if (strongOperation) {
                        [self.runningOperations removeObject:strongOperation];
                    }
                }
            };
        }
    }];
    return combinedOperation;
}

@end

@implementation CBWebImageCombinedOperation

- (void)setCancelBlock:(CBWebImageNoParamsBlock)cancelBlock {
    if (self.isCancelled) {
        if (cancelBlock) {
            cancelBlock();
        }
        _cancelBlock = nil;
    } else {
        _cancelBlock = cancelBlock;
    }
}

- (void)cancel {
    self.cancelled = YES;
    if (self.cacheOperation) {
        [self.cacheOperation cancel];
        self.cacheOperation = nil;
    }
    if (self.cancelBlock) {
        self.cancelBlock();
        self.cancelBlock = nil;
    }
}

@end
