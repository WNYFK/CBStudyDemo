//
//  CBManagedObjectContextManager.h
//  CBStudyDemo
//
//  Created by ChenBin on 16/9/12.
//  Copyright © 2016年 ChenBin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CBManagedObjectContextManager : NSObject

+ (CBManagedObjectContextManager *)sharedInstance;

@property (nonatomic, strong, readonly) NSManagedObjectContext *managedObjectContext;

@end
