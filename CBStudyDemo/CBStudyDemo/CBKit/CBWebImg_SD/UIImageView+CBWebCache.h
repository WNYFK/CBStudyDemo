//
//  UIImageView+CBWebCache.h
//  CBStudyDemo
//
//  Created by ChenBin on 16/8/19.
//  Copyright © 2016年 ChenBin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CBWebImageCompat.h"
#import "CBWebImageManager.h"

@interface UIImageView (CBWebCache)

- (NSURL *)cb_imageURL;

- (void)cb_setImageWithURL:(NSURL *)url;
- (void)cb_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder;

- (void)cb_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder completed:(CBWebImageDownloaderCompletedBlock)completedBlock;

- (void)cb_cancelCurrentImageLoad;

@end
