//
//  UIView+CBWebCacheOperation.h
//  CBStudyDemo
//
//  Created by ChenBin on 16/8/19.
//  Copyright © 2016年 ChenBin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CBWebImageManager.h"

@interface UIView (CBWebCacheOperation)

- (void)cb_setImageLoadOperation:(id)operation forKey:(NSString *)key;

- (void)cb_cancelImageLoadOperationWithKey:(NSString *)key;

- (void)cb_removeImageLoadOperationWithKey:(NSString *)key;

@end
