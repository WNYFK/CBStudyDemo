//
//  CBStore.h
//  CBStudyDemo
//
//  Created by ChenBin on 16/9/9.
//  Copyright © 2016年 ChenBin. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CBManagedObject;
@class NSFetchedResultsController;

@interface CBStore : NSObject

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

- (CBManagedObject *)managedObject;

@end
