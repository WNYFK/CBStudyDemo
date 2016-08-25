//
//  CBCatonTimerManager.h
//  CBStudyDemo
//
//  Created by ChenBin on 16/8/25.
//  Copyright © 2016年 ChenBin. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^CBCatonLongTimeBlock)(NSTimeInterval mainLoopPersistSecond);
typedef void(^CBCatonHighCpuBlock)(CGFloat cpuUsage, NSTimeInterval presistSecond);
typedef void(^CBCatonLowFpsBlock)(NSInteger fps);

@interface CBCatonTimerManager : NSObject

@property (nonatomic, copy) CBCatonLongTimeBlock longTimeBlock;
@property (nonatomic, copy) CBCatonHighCpuBlock highCpuBlock;
@property (nonatomic, copy) CBCatonLowFpsBlock lowFpsBlock;

- (void)runLoopAfterWaiting;
- (void)runLoopBeforeWaiting;
- (void)startObserverCPU;

@end
