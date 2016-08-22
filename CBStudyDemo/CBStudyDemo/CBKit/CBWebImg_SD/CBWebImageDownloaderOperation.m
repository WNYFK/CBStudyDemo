//
//  CBWebImageDownloaderOperation.m
//  CBStudyDemo
//
//  Created by ChenBin on 16/8/17.
//  Copyright © 2016年 ChenBin. All rights reserved.
//

#import "CBWebImageDownloaderOperation.h"
#import <ImageIO/ImageIO.h>

@interface CBWebImageDownloaderOperation ()<NSURLSessionTaskDelegate, NSURLSessionDelegate, NSURLSessionDataDelegate>

@property (nonatomic, copy) CBWebImageDownloaderProgressBlock progressBlock;
@property (nonatomic, copy) CBWebImageDownloaderCompletedBlock completedBlock;
@property (nonatomic, copy) CBWebImageNoParamsBlock cancleBlock;

@property (nonatomic, assign, getter = isExecuting) BOOL executing;
@property (nonatomic, assign, getter = isFinished) BOOL finished;
@property (nonatomic, strong) NSMutableData *imageData;

@property (nonatomic, weak) NSURLSession *unownedSession;
@property (nonatomic, strong) NSURLSession *ownedSession;
@property (nonatomic, strong) NSURLRequest *request;
@property (nonatomic, strong) NSURLSessionTask *dataTask;
@property (atomic, strong) NSThread *thread;

@end

@implementation CBWebImageDownloaderOperation {
    size_t width, height;
    UIImageOrientation orientation;
    BOOL responseFromCached;
}

@synthesize executing = _executing;
@synthesize finished = _finished;

- (instancetype)initWithRequest:(NSURLRequest *)request inSession:(NSURLSession *)session progress:(CBWebImageDownloaderProgressBlock)progressBlock completed:(CBWebImageDownloaderCompletedBlock)completedBlock cancelled:(CBWebImageNoParamsBlock)cancelBlock {
    if (self = [super init]) {
        self.request = request;
        self.shouldDecompressImages = YES;
        self.progressBlock = progressBlock;
        self.completedBlock = completedBlock;
        self.cancleBlock = cancelBlock;
        self.executing = NO;
        self.finished = NO;
        self.expectedSize = 0;
        self.unownedSession = session;
        responseFromCached = YES;
        
    }
    return self;
}

- (void)start {
    @synchronized (self) {
        if (self.isCancelled) {
            self.finished = YES;
            [self reset];
            return;
        }
        NSURLSession *session = self.unownedSession;
        if (!self.unownedSession) {
            NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
            sessionConfig.timeoutIntervalForRequest = 15;
            self.ownedSession = [NSURLSession sessionWithConfiguration:sessionConfig delegate:self delegateQueue:nil];
            session = self.ownedSession;
        }
        self.dataTask = [session dataTaskWithRequest:self.request];
        self.executing = YES;
        self.thread = [NSThread currentThread];
    }
    [self.dataTask resume];
    if (self.dataTask) {
        if (self.progressBlock) {
            self.progressBlock(0, NSURLResponseUnknownLength);
        }
    } else {
        if (self.completedBlock) { //can't be initialized
        }
    }
}

- (void)cancel {
    @synchronized (self) {
        if (self.thread) {
            [self performSelector:@selector(cancelInternalAndStop) onThread:self.thread withObject:nil waitUntilDone:NO];
        } else {
            [self cancelInternal];
        }
    }
}

- (void)cancelInternalAndStop {
    if (self.isFinished) return;
    [self cancelInternal];
}

- (void)cancelInternal {
    if (self.isFinished) return;
    [super cancel];
    
    if (self.cancleBlock) self.cancleBlock();
    if (self.dataTask) {
        [self.dataTask cancel];
        if (self.isExecuting) self.executing = NO;
        if (!self.isFinished) self.finished = YES;
    }
    [self reset];
}

- (void)done {
    self.finished = YES;
    self.executing = NO;
    [self reset];
}

- (void)reset {
    self.cancleBlock = nil;
    self.completedBlock = nil;
    self.progressBlock = nil;
    self.dataTask = nil;
    self.imageData = nil;
    self.thread = nil;
    if (self.ownedSession) {
        [self.ownedSession invalidateAndCancel];
        self.ownedSession = nil;
    }
}

- (void)setFinished:(BOOL)finished {
    [self willChangeValueForKey:@"isFinished"];
    _finished = finished;
    [self didChangeValueForKey:@"isFinished"];
}

- (void)setExecuting:(BOOL)executing {
    [self willChangeValueForKey:@"isExecuting"];
    _executing = executing;
    [self didChangeValueForKey:@"isExecuting"];
}

- (BOOL)isConcurrent {
    return YES;
}

#pragma mark NSURLSessionDataDelegate

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler {
    if (![response respondsToSelector:@selector(statusCode)] || ([((NSHTTPURLResponse *)response) statusCode] < 400 && [((NSHTTPURLResponse *)response) statusCode] != 304)) {
        NSInteger expected = response.expectedContentLength > 0 ? (NSInteger)response.expectedContentLength : 0;
        self.expectedSize = expected;
        if (self.progressBlock) {
            self.progressBlock(0, expected);
        }
        self.imageData = [[NSMutableData alloc] initWithCapacity:expected];
        self.response = response;
    } else {
        NSUInteger code = [((NSHTTPURLResponse *)response) statusCode];
        if (code == 304) {
            [self cancelInternal];
        } else {
            [self.dataTask cancel];
        }
        if (self.completedBlock) {
            self.completedBlock(nil, nil, CBImageCacheTypeNone, [NSError errorWithDomain:NSURLErrorDomain code:code userInfo:nil], YES, self.request.URL);
        }
        [self done];
    }
    if (completionHandler) {
        completionHandler(NSURLSessionResponseAllow);
    }
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data {
    [self.imageData appendData:data];
    if (self.expectedSize > 0 && self.completedBlock) {
        const NSInteger totalSize = self.imageData.length;
        CGImageSourceRef imageSource = CGImageSourceCreateWithData((__bridge CFDataRef)self.imageData, NULL);
        if (width + height == 0) {
            CFDictionaryRef properties = CGImageSourceCopyPropertiesAtIndex(imageSource, 0, NULL);
            if (properties) {
                NSInteger orientationValue = -1;
                CFTypeRef val = CFDictionaryGetValue(properties, kCGImagePropertyPixelHeight);
                if (val) CFNumberGetValue(val, kCFNumberLongType, &height);
                val = CFDictionaryGetValue(properties, kCGImagePropertyPixelWidth);
                if (val) CFNumberGetValue(val, kCFNumberLongType, &width);
                val = CFDictionaryGetValue(properties, kCGImagePropertyOrientation);
                if (val) CFNumberGetValue(val, kCFNumberNSIntegerType, &orientationValue);
                CFRelease(properties);
                orientation = [[self class] orientationFromPropertyValue:orientationValue];
            }
        }
        if (width + height > 0 && totalSize < self.expectedSize) {
            CGImageRef partialImageRef = CGImageSourceCreateImageAtIndex(imageSource, 0, NULL);
            if (partialImageRef) {
                const size_t partialHeight = CGImageGetHeight(partialImageRef);
                CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
                CGContextRef bmContext = CGBitmapContextCreate(NULL, width, height, 8, width * 4, colorSpace, kCGBitmapByteOrderDefault | kCGImageAlphaPremultipliedFirst);
                CGColorSpaceRelease(colorSpace);
                if (bmContext) {
                    CGContextDrawImage(bmContext, (CGRect){.origin.x = 0.0f, .origin.y = 0.0f, .size.width = width, .size.height = partialHeight}, partialImageRef);
                    CGImageRelease(partialImageRef);
                    partialImageRef = CGBitmapContextCreateImage(bmContext);
                    CGContextRelease(bmContext);
                }
                else {
                    CGImageRelease(partialImageRef);
                    partialImageRef = nil;
                }
                
                UIImage *image = [UIImage imageWithCGImage:partialImageRef scale:1 orientation:orientation];
//                NSString *key = @"";
                CGImageRelease(partialImageRef);
                CB_dispatch_main_sync_safe(^{
                    if (self.completedBlock) {
                        self.completedBlock(image, nil, CBImageCacheTypeNone, nil, NO, self.request.URL);
                    }
                });
            }
        }
        CFRelease(imageSource);
    }
    if (self.progressBlock) {
        self.progressBlock(self.imageData.length, self.expectedSize);
    }
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask willCacheResponse:(NSCachedURLResponse *)proposedResponse completionHandler:(void (^)(NSCachedURLResponse * _Nullable))completionHandler {
    responseFromCached = NO;
    NSCachedURLResponse *cachedResponse = proposedResponse;
    if (self.request.cachePolicy == NSURLRequestReloadIgnoringCacheData) {
        cachedResponse = nil;
    }
    if (completionHandler) {
        completionHandler(cachedResponse);
    }
}

#pragma mark NSURLSessionTaskDelegate

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    @synchronized (self) {
        self.thread = nil;
        self.dataTask = nil;
    }
    if (error) {
        if (self.completedBlock) {
            self.completedBlock(nil, nil, CBImageCacheTypeNone, error, YES, self.request.URL);
        }
    } else {
        CBWebImageDownloaderCompletedBlock completionBlock = self.completedBlock;
        if (![[NSURLCache sharedURLCache] cachedResponseForRequest:self.request]) {
            responseFromCached = NO;
        }
        if (completionBlock) {
            if (responseFromCached) {
                completionBlock(nil, nil, CBImageCacheTypeNone, nil, YES, self.request.URL);
            } else if (self.imageData) {
                UIImage *image = [UIImage imageWithData:self.imageData];
                if (CGSizeEqualToSize(image.size, CGSizeZero)) {
                    completionBlock(nil, nil, CBImageCacheTypeNone, [NSError errorWithDomain:@"Error" code:0 userInfo:@{NSLocalizedDescriptionKey : @"Downloaded image has 0 pixels"}], YES, self.request.URL);
                } else {
                    completionBlock(image, self.imageData, CBImageCacheTypeNone, nil, YES, self.request.URL);
                }
            } else {
                completionBlock(nil, nil, CBImageCacheTypeNone, [NSError errorWithDomain:@"Error" code:0 userInfo:@{NSLocalizedDescriptionKey : @"Image data is nil"}], YES, self.request.URL);
            }
        }
    }
    self.completionBlock = nil;
    [self done];
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential * _Nullable))completionHandler {
    NSURLSessionAuthChallengeDisposition disposition = NSURLSessionAuthChallengePerformDefaultHandling;
    __block NSURLCredential *credential = nil;
    
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
        disposition = NSURLSessionAuthChallengeUseCredential;
    } else {
        if ([challenge previousFailureCount] == 0) {
            if (self.credential) {
                credential = self.credential;
                disposition = NSURLSessionAuthChallengeUseCredential;
            } else {
                disposition = NSURLSessionAuthChallengeCancelAuthenticationChallenge;
            }
        } else {
            disposition = NSURLSessionAuthChallengeCancelAuthenticationChallenge;
        }
    }
    
    if (completionHandler) {
        completionHandler(disposition, credential);
    }
}


+ (UIImageOrientation)orientationFromPropertyValue:(NSInteger)value {
    switch (value) {
        case 1:
            return UIImageOrientationUp;
        case 3:
            return UIImageOrientationDown;
        case 8:
            return UIImageOrientationLeft;
        case 6:
            return UIImageOrientationRight;
        case 2:
            return UIImageOrientationUpMirrored;
        case 4:
            return UIImageOrientationDownMirrored;
        case 5:
            return UIImageOrientationLeftMirrored;
        case 7:
            return UIImageOrientationRightMirrored;
        default:
            return UIImageOrientationUp;
    }
}
@end
