//
//  CBWebImageOperation_YY.h
//  CBStudyDemo
//
//  Created by ChenBin on 16/8/22.
//  Copyright © 2016年 ChenBin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CBWebImageManager_YY.h"

NS_ASSUME_NONNULL_BEGIN

@interface CBWebImageOperation_YY : NSOperation

@property (nonatomic, strong, readonly) NSURLRequest *request;
@property (nonatomic, strong, readonly, nullable) NSURLResponse *response;
@property (nonatomic, strong, readonly) NSString *cacheKey;

@property (nonatomic) BOOL shouldUseCredentialStorage;
@property (nonatomic, strong, nullable) NSURLCredential *credential;

- (instancetype)initWithRequst:(NSURLRequest *)request progress:(nullable CBWebImageProgressBlock_YY)progress transform:(nullable CBWebImageTransformBlock)transform completion:(nullable CBWebImageCompletionBlock_YY)completion NS_DESIGNATED_INITIALIZER;

- (instancetype)init UNAVAILABLE_ATTRIBUTE;
+ (instancetype)new UNAVAILABLE_ATTRIBUTE;

@end

NS_ASSUME_NONNULL_END