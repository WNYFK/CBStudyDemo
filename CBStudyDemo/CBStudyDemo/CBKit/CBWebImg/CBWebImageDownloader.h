//
//  CBWebImageDownloader.h
//  CBStudyDemo
//
//  Created by ChenBin on 16/8/18.
//  Copyright © 2016年 ChenBin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CBWebImageCompat.h"

@class CBWebImageDownloaderOperation;

@interface CBWebImageDownloader : NSObject

@property (nonatomic, assign) BOOL shouldDecompressImages;
@property (nonatomic, assign) NSInteger maxConcurrentDownloads;
@property (nonatomic, assign) NSUInteger currentDownloadCount;
@property (nonatomic, assign) NSTimeInterval downloadTimeout;

+ (CBWebImageDownloader *)sharedDownloader;

- (CBWebImageDownloaderOperation *)downloadImageWithURL:(NSURL *)url progress:(CBWebImageDownloaderProgressBlock)progressBlock completer:(CBWebImageDownloaderCompletedBlock)completedBlock;
- (void)cancelAllDownloads;
- (void)setSuspended:(BOOL)suspended;

@end
