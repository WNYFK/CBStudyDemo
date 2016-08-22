//
//  CBWebImageManager_YY.h
//  CBStudyDemo
//
//  Created by ChenBin on 16/8/22.
//  Copyright © 2016年 ChenBin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, CBWebImageFromType) {
    CBWebImageFromTypeNone = 0,
    CBWebImageFromTypeMemoryCacheFast,
    CBWebImageFromTypeMemoryCache,
    CBWebImageFromTypeDiskCache,
    CBWebImageFromTypeRemote
};

typedef NS_ENUM(NSInteger, CBWebImageStage) {
    CBWebImageStageProgress = -1,
    CBWebImageStageCancelled = 0,
    CBWebImageStageFinished = 1
};

typedef UIImage * _Nullable (^CBWebImageTransformBlock)(UIImage *image, NSURL *url);
typedef void(^CBWebImageProgressBlock_YY)(NSInteger receivedSize, NSInteger expectedSize);
typedef void(^CBWebImageCompletionBlock_YY)(UIImage * _Nullable image, NSURL *url, CBWebImageFromType from, CBWebImageStage stage, NSError * _Nullable error);

@interface CBWebImageManager_YY : NSObject

@end

NS_ASSUME_NONNULL_END