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

@interface CBWebImageManager ()

@property (nonatomic, strong) CBWebImageDownloader *imageDownloader;
@property (nonatomic, strong) NSMutableSet *failedURLs;
@property (nonatomic, strong) NSMutableArray<CBWebImageDownloaderOperation *> *runningOperations;

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
    return [self initWithDownloader:downloader];
}

- (instancetype)initWithDownloader:(CBWebImageDownloader *)downloader {
    if (self = [super init]) {
        self.imageDownloader = downloader;
        self.failedURLs = [NSMutableSet new];
        self.runningOperations = [NSMutableArray new];
    }
    return self;
}

- (CBWebImageDownloaderOperation *)downloadImageWithURL:(NSURL *)url progress:(CBWebImageDownloaderProgressBlock)progresssBlock completed:(CBWebImageDownloaderCompletedBlock)completedBlock {
    CBWebImageDownloaderOperation * operation = [self.imageDownloader downloadImageWithURL:url progress:progresssBlock completer:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
        if (error) {
            CB_dispatch_main_sync_safe(^{
                completedBlock(nil, nil, error, url);
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
            CB_dispatch_main_sync_safe(^{
                completedBlock(image, data, error, finished);
            });
            [self.runningOperations removeObject:operation];
        }
    }];
    if (operation) {
        [self.runningOperations addObject:operation];
    }
    return operation;
}

@end
