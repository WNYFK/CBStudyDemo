//
//  CBTestObject.h
//  CBStudyDemo
//
//  Created by ChenBin on 2017/3/6.
//  Copyright © 2017年 ChenBin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CBTestObject : NSObject

- (void)finished: (void(^)(NSDictionary *))callBack;

@end
