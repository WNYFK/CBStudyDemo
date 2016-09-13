//
//  CBManagedObjectContextManager.m
//  CBStudyDemo
//
//  Created by ChenBin on 16/9/12.
//  Copyright © 2016年 ChenBin. All rights reserved.
//

#import "CBManagedObjectContextManager.h"
#import <CoreData/CoreData.h>

static CBManagedObjectContextManager *instance = nil;

@interface CBManagedObjectContextManager ()

@property (nonatomic, strong) NSManagedObjectContext *backgroundObjectContext;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@end

@implementation CBManagedObjectContextManager

+ (CBManagedObjectContextManager *)sharedInstance {
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        instance = [[CBManagedObjectContextManager alloc] init];
    });
    return instance;
}

- (NSManagedObjectContext *)managedObjectContext {
    if (!_managedObjectContext) {
        _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        _managedObjectContext.persistentStoreCoordinator = self.persistentStoreCoordinator;
    }
    return _managedObjectContext;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    if (!_persistentStoreCoordinator) {
        _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.managedObjectModel];
        NSURL *url = [self.applicationDocumentsDirectory URLByAppendingPathComponent:@"CoreData.sqlite"];
        NSError *error;
        [_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:url options:nil error:&error];
    }
    return _persistentStoreCoordinator;
}

- (NSManagedObjectContext *)backgroundObjectContext {
    if (!_backgroundObjectContext) {
        _backgroundObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        _backgroundObjectContext.parentContext = self.managedObjectContext;
    }
    return _backgroundObjectContext;
}

- (NSURL *)applicationDocumentsDirectory {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSCachesDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    return [[NSManagedObjectModel alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"CoreData" withExtension:@"momd"]];
}

@end
