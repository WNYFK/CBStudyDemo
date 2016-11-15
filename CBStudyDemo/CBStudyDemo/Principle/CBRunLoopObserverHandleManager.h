//
//  CBRunLoopObserverHandleManager.h
//  CBStudyDemo
//
//  Created by ChenBin on 2016/11/14.
//  Copyright © 2016年 ChenBin. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^RunLoopOberverCallBack)(NSString *activity, CFStringRef modeName, id info);

@interface CBRunLoopObserverHandleManager : NSObject

- (instancetype)initWithInfo:(id)info withCallBack:(RunLoopOberverCallBack)callBack;
- (void)observerWithLoop:(CFRunLoopRef)loop;

@end
