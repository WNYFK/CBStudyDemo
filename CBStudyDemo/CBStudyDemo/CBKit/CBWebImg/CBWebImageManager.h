//
//  CBWebImageManager.h
//  CBStudyDemo
//
//  Created by ChenBin on 16/8/18.
//  Copyright © 2016年 ChenBin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CBWebImageCompat.h"
#import "CBWebImageOperation.h"

@class CBWebImageDownloader, CBWebImageDownloaderOperation;

@interface CBWebImageManager : NSObject

@property (nonatomic, strong, readonly) CBWebImageDownloader *imageDownloader;

+ (CBWebImageManager *)sharedManager;

- (id <CBWebImageOperation>)downloadImageWithURL:(NSURL *)url progress:(CBWebImageDownloaderProgressBlock)progresssBlock completed:(CBWebImageDownloaderCompletedBlock)completedBlock;

@end
