//
//  CBWebImageDownloaderOperation.h
//  CBStudyDemo
//
//  Created by ChenBin on 16/8/17.
//  Copyright © 2016年 ChenBin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CBWebImageCompat.h"

@interface CBWebImageDownloaderOperation : NSOperation

@property (nonatomic, strong, readonly) NSURLRequest *request;
@property (nonatomic, strong, readonly) NSURLSessionTask *dataTask;
@property (nonatomic, assign) BOOL shouldDecompressImages;
@property (nonatomic, strong) NSURLCredential *credential;
@property (nonatomic, assign) NSInteger expectedSize;
@property (nonatomic, strong) NSURLResponse *response;

- (instancetype)initWithRequest:(NSURLRequest *)request inSession:(NSURLSession *)session progress:(CBWebImageDownloaderProgressBlock)progressBlock completed:(CBWebImageDownloaderCompletedBlock)completedBlock cancelled:(CBWebImageNoParamsBlock)cancelBlock;

@end
