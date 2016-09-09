//
//  CBNormalInputSource.h
//  CBStudyDemo
//
//  Created by ChenBin on 16/8/15.
//  Copyright © 2016年 ChenBin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CBNormalInputSource : NSObject

- (instancetype)addToCurrentRunLoop;

- (void)wakeUpSourceOne;
- (void)wakeUpSourceTwo;

- (void)invalidateSourceOne;
- (void)invalidateSourceTwo;
- (void)invalidate;

@end
