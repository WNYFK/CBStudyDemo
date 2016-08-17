//
//  CBWebImageCompat.h
//  CBStudyDemo
//
//  Created by ChenBin on 16/8/17.
//  Copyright © 2016年 ChenBin. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^CBWebImageDownloaderProgressBlock)(NSInteger receivedSize, NSInteger expectedSize);
typedef void(^CBWebImageDownloaderCompletedBlock)(UIImage *image, NSData *data, NSError *error, BOOL finished);
typedef void(^CBWebImageNoParamsBlock)();


@interface CBWebImageCompat : NSObject

@end


#define CB_dispatch_main_sync_safe(block)\
    if ([NSThread isMainThread]) {\
        block();\
    } else {\
        dispatch_sync(dispatch_get_main_queue(), block);\
    }

#define CB_dispatch_main_async_safe(block)\
    if ([NSThread isMainThread]) {\
        block();\
    } else {\
        dispatch_async(dispatch_get_main_queue(), block);\
    }