//
//  UIImageView+CBWebCache.m
//  CBStudyDemo
//
//  Created by ChenBin on 16/8/19.
//  Copyright © 2016年 ChenBin. All rights reserved.
//

#import "UIImageView+CBWebCache.h"
#import <objc/runtime.h>
#import "UIView+CBWebCacheOperation.h"
#import "CBWebImageOperation.h"

static char KCBImageURLKey;

static NSString *KCBImageLoadOperationKey = @"UIImageViewImageLoad";

@implementation UIImageView (CBWebCache)

- (NSURL *)cb_imageURL {
    return objc_getAssociatedObject(self, &KCBImageURLKey);
}

- (void)cb_setImageWithURL:(NSURL *)url {
    [self cb_setImageWithURL:url placeholderImage:nil completed:nil];
}

- (void)cb_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder {
    [self cb_setImageWithURL:url placeholderImage:placeholder completed:nil];
}

- (void)cb_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder completed:(CBWebImageDownloaderCompletedBlock)completedBlock {
    [self cb_cancelCurrentImageLoad];
    objc_setAssociatedObject(self, &KCBImageURLKey, url, OBJC_ASSOCIATION_RETAIN);
    if (placeholder) {
        CB_dispatch_main_async_safe(^{
            self.image = placeholder;
        });
    }
    if (url) {
        __weak __typeof(self) weakSelf = self;
        id<CBWebImageOperation> operation = [[CBWebImageManager sharedManager] downloadImageWithURL:url progress:nil completed:^(UIImage *image, NSData *data, CBImageCacheType cacheType, NSError *error, BOOL finished, NSURL *url) {
            if (!weakSelf) return ;
            CB_dispatch_main_async_safe(^{
                if (!weakSelf) return ;
                if (image && completedBlock) {
                    completedBlock(image, data, cacheType, error, finished, url);
                    return;
                } else if (image) {
                    weakSelf.image = image;
                    [weakSelf setNeedsLayout];
                } else {
                    weakSelf.image = placeholder;
                    [weakSelf setNeedsLayout];
                }
                if (completedBlock && finished) {
                    completedBlock(image, data, cacheType, error, finished, url);
                }
            });
        }];
        [self cb_setImageLoadOperation:operation forKey:KCBImageLoadOperationKey];
    } else {
        CB_dispatch_main_async_safe(^{
            if (completedBlock) {
                completedBlock(nil, nil, CBImageCacheTypeNone, nil, YES, url);
            }
        });
    }
}

- (void)cb_cancelCurrentImageLoad {
    [self cb_cancelImageLoadOperationWithKey:KCBImageLoadOperationKey];
}


@end
