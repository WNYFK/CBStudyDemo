//
//  CBThread.h
//  CBStudyDemo
//
//  Created by ChenBin on 16/8/15.
//  Copyright © 2016年 ChenBin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CBThread : NSThread

- (void)wakeUpSourceOne;
- (void)wakeUpSourceTwo;
- (void)wakeUpRunLoop;

- (void)invalidateSourceOne;

@end
