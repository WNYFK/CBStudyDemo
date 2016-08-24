//
//  CBCatonObserver.h
//  CBStudyDemo
//
//  Created by chenbin on 16/8/24.
//  Copyright © 2016年 ChenBin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CBCatonObserver : NSObject

+ (CBCatonObserver *)sharedInstance;

- (void)startObserver;

@end
