//
//  CBWebImageDownloader.m
//  CBStudyDemo
//
//  Created by ChenBin on 16/8/18.
//  Copyright © 2016年 ChenBin. All rights reserved.
//

#import "CBWebImageDownloader.h"
#import "CBWebImageDownloaderOperation.h"
#import <ImageIO/ImageIO.h>

static NSString *const KProgressCallKey = @"progress";
static NSString *const KCompletedCallbackKey = @"completed";

@interface CBWebImageDownloader ()

@property (nonatomic, strong) NSOperationQueue *downloadQueue;
@property (nonatomic, weak) NSOperation *lastAddedOperation;
@property (nonatomic, strong) NSMutableDictionary *URLCallbacks;
@property (nonatomic, strong) NSMutableDictionary *HTTPHeaders;
@property (nonatomic, strong) dispatch_queue_t barrierQueue;

@end

@implementation CBWebImageDownloader

+ (CBWebImageDownloader *)sharedDownloader {
    static dispatch_once_t once;
    static CBWebImageDownloader *imgDownloader;
    dispatch_once(&once, ^{
        imgDownloader = [[CBWebImageDownloader alloc] init];
    });
    return imgDownloader;
}

- (void)dealloc {
    [self.downloadQueue cancelAllOperations];
}

- (instancetype)init {
    if (self = [super init]) {
        self.shouldDecompressImages = YES;
        self.downloadQueue = [NSOperationQueue new];
        self.downloadQueue.maxConcurrentOperationCount = 6;
        self.URLCallbacks = [NSMutableDictionary new];
        self.HTTPHeaders = [@{@"Accept": @"iamge/*;q=0.8"} mutableCopy];
        self.barrierQueue = dispatch_queue_create("con.chenbin.CBWebImageDownloader", DISPATCH_QUEUE_CONCURRENT);
        self.downloadTimeout = 15;
    }
    return self;
}

- (void)setMaxConcurrentDownloads:(NSInteger)maxConcurrentDownloads {
    self.downloadQueue.maxConcurrentOperationCount = maxConcurrentDownloads;
}

- (NSUInteger)currentDownloadCount {
    return self.downloadQueue.operationCount;
}

- (NSInteger)maxConcurrentDownloads {
    return self.downloadQueue.maxConcurrentOperationCount;
}

- (CBWebImageDownloaderOperation *)downloadImageWithURL:(NSURL *)url progress:(CBWebImageDownloaderProgressBlock)progressBlock completer:(CBWebImageDownloaderCompletedBlock)completedBlock {
    __block CBWebImageDownloaderOperation *operation;
    __weak __typeof(self) wself = self;
    [self addProgressCallback:progressBlock completedBlock:completedBlock forURL:url createCallback:^{
        NSTimeInterval timeoutInterval = wself.downloadTimeout == 0 ? 15 : wself.downloadTimeout;
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:timeoutInterval];
        request.HTTPShouldHandleCookies = YES;
        request.HTTPShouldUsePipelining = YES;
        request.allHTTPHeaderFields = wself.HTTPHeaders;
        operation = [[CBWebImageDownloaderOperation alloc] initWithRequest:request inSession:nil progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            CBWebImageDownloader *sself = wself;
            if (!sself) return ;
            __block NSArray *callbacksForURL;
            dispatch_sync(sself.barrierQueue, ^{
                callbacksForURL = [sself.URLCallbacks[url] copy];
            });
            for (NSDictionary *callbacks in callbacksForURL) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    CBWebImageDownloaderProgressBlock callback = callbacks[KProgressCallKey];
                    if (callback) callback(receivedSize, expectedSize);
                });
            }
        } completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
            CBWebImageDownloader *sself = wself;
            if (!sself) return ;
            __block NSArray *callbakcsForURL;
            dispatch_barrier_sync(sself.barrierQueue, ^{
                callbakcsForURL = [sself.URLCallbacks[url] copy];
                if (finished) {
                    [sself.URLCallbacks removeObjectForKey:url];
                }
            });
            for (NSDictionary *callbacks in callbakcsForURL) {
                CBWebImageDownloaderCompletedBlock callback = callbacks[KCompletedCallbackKey];
                if (callback) callback(image, data, error, finished);
            }
        } cancelled:^{
            CBWebImageDownloader *sself = wself;
            if (!sself) return ;
            dispatch_barrier_async(sself.barrierQueue, ^{
                [sself.URLCallbacks removeObjectForKey:url];
            });
        }];
        operation.shouldDecompressImages = wself.shouldDecompressImages;
        [wself.downloadQueue addOperation:operation];
    }];
    return operation;
}

- (void)addProgressCallback:(CBWebImageDownloaderProgressBlock)progressCallback completedBlock:(CBWebImageDownloaderCompletedBlock)completedBlock forURL:(NSURL *)url createCallback:(CBWebImageNoParamsBlock)createCallback {
    if (url == nil) {
        if (completedBlock != nil) {
            completedBlock(nil, nil, nil, nil);
        }
        return;
    }
    
    dispatch_barrier_sync(self.barrierQueue, ^{
        BOOL first = NO;
        if (!self.URLCallbacks[url]) {
            self.URLCallbacks[url] = [NSMutableArray new];
            first = YES;
        }
        NSMutableArray *callbacksForURL = self.URLCallbacks[url];
        NSMutableDictionary *callbacks = [NSMutableDictionary new];
        if (progressCallback) callbacks[KProgressCallKey] = [progressCallback copy];
        if (completedBlock) callbacks[KCompletedCallbackKey] = [completedBlock copy];
        [callbacksForURL addObject:callbacks];
        self.URLCallbacks[url] = callbacksForURL;
        if (first) {
            createCallback();
        }
    });
}

- (void)setSuspended:(BOOL)suspended {
    [self.downloadQueue setSuspended:suspended];
}

- (void)cancelAllDownloads {
    [self.downloadQueue cancelAllOperations];
}

@end
