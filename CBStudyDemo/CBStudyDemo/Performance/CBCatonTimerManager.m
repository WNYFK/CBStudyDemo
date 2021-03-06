//
//  CBCatonTimerManager.m
//  CBStudyDemo
//
//  Created by ChenBin on 16/8/25.
//  Copyright © 2016年 ChenBin. All rights reserved.
//

#import "CBCatonTimerManager.h"
#include <mach/mach.h>
#include <sys/sysctl.h>
#import <execinfo.h>
#include <pthread.h>


#define KCBHighCPUValue 70
#define KCBHighCPUWarningSecond 5

@interface CBCatonTimerManager ()

@property (nonatomic, strong) NSTimer *mainLoopPersisttimer;
@property (nonatomic, strong) NSDate *startDate;
@property (nonatomic, strong) NSTimer *cpuTimer;
@property (nonatomic, assign) NSTimeInterval presistSecondHighCpu;
@property (nonatomic, assign) BOOL hadHandleHighCpu;

@end

@implementation CBCatonTimerManager

- (void)runLoopAfterWaiting {
    [self setupTimer];
}

- (void)runLoopBeforeWaiting {
    [self.mainLoopPersisttimer invalidate];
    self.mainLoopPersisttimer = nil;
}

- (void)addTimerToCurRunLoop {
    [[NSRunLoop currentRunLoop] addTimer:self.mainLoopPersisttimer forMode:NSRunLoopCommonModes];
}

- (void)setupTimer {
    self.mainLoopPersisttimer = nil;
    self.startDate = [NSDate date];
    self.mainLoopPersisttimer = [NSTimer bk_timerWithTimeInterval:2 block:^(NSTimer *timer) {
        if (self.longTimeBlock) {
            self.longTimeBlock([[NSDate date] timeIntervalSinceDate:self.startDate]);
        }
    } repeats:YES];
    [self addTimerToCurRunLoop];
}

- (void)startObserverCPU {
    if (self.cpuTimer) return;
    self.cpuTimer = [NSTimer bk_timerWithTimeInterval:0.5 block:^(NSTimer *timer) {
        float curCpuUsage = [self cpu_usage];
        if (curCpuUsage > KCBHighCPUValue) {
            self.presistSecondHighCpu += 0.5;
            if (!self.hadHandleHighCpu && self.presistSecondHighCpu > KCBHighCPUWarningSecond && self.highCpuBlock) {
                self.hadHandleHighCpu = YES;
                self.highCpuBlock(curCpuUsage, self.presistSecondHighCpu);
            }
        } else {
            self.hadHandleHighCpu = NO;
            self.presistSecondHighCpu = 0;
        }
    } repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.cpuTimer forMode:NSRunLoopCommonModes];
}

void PrintBacktrace ( void )
{
    void *callstack[1280];
    int frameCount = backtrace(callstack, 1280);
    char **frameStrings = backtrace_symbols(callstack, frameCount);
    
    if ( frameStrings != NULL ) {
        // Start with frame 1 because frame 0 is PrintBacktrace()
        for ( int i = 1; i < frameCount; i++ ) {
            printf("%s\n", frameStrings[i]);
        }
        free(frameStrings);
    }
}

- (float)cpu_usage {
    kern_return_t kr;
    task_info_data_t tinfo;
    mach_msg_type_number_t task_info_count;
    
    task_info_count = TASK_INFO_MAX;
    kr = task_info(mach_task_self(), TASK_BASIC_INFO, (task_info_t)tinfo, &task_info_count);
    if (kr != KERN_SUCCESS) {
        
        return -1;
        
    }
    
    task_basic_info_t      basic_info;
    thread_array_t         thread_list;
    mach_msg_type_number_t thread_count;
    thread_info_data_t     thinfo;
    mach_msg_type_number_t thread_info_count;
    thread_basic_info_t basic_info_th;
    uint32_t stat_thread = 0; // Mach threads
    basic_info = (task_basic_info_t)tinfo;
    // get threads in the task
    
    kr = task_threads(mach_task_self(), &thread_list, &thread_count);
    
    if (kr != KERN_SUCCESS) {
        return -1;
    }
    if (thread_count > 0)
        stat_thread += thread_count;
    
    long tot_sec = 0;
    long tot_usec = 0;
    float tot_cpu = 0;
    int j;
    
    for (j = 0; j < thread_count; j++) {
        thread_info_count = THREAD_INFO_MAX;
        kr = thread_info(thread_list[j], THREAD_BASIC_INFO,
                         (thread_info_t)thinfo, &thread_info_count);
        if (kr != KERN_SUCCESS) {
            return -1;
        }
        
        basic_info_th = (thread_basic_info_t)thinfo;
        
        if (!(basic_info_th->flags & TH_FLAGS_IDLE)) {
            tot_sec = tot_sec + basic_info_th->user_time.seconds + basic_info_th->system_time.seconds;
            tot_usec = tot_usec + basic_info_th->system_time.microseconds + basic_info_th->system_time.microseconds;
            tot_cpu = tot_cpu + basic_info_th->cpu_usage / (float)TH_USAGE_SCALE * 100.0;
        }
        
    } // for each thread
    
    kr = vm_deallocate(mach_task_self(), (vm_offset_t)thread_list, thread_count * sizeof(thread_t));
    assert(kr == KERN_SUCCESS);
    
    return tot_cpu;
}

@end
