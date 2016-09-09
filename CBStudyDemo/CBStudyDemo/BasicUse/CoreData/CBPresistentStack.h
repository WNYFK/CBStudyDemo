//
//  CBPresistentStack.h
//  CBStudyDemo
//
//  Created by ChenBin on 16/9/9.
//  Copyright © 2016年 ChenBin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface CBPresistentStack : NSObject

@property (nonatomic, strong, readonly) NSManagedObjectContext *managedObjectContext;

- (instancetype)initWithStoreURL:(NSURL *)storeURL modelURL:(NSURL *)modelURL;

@end
