//
//  CBCoreDataConnect.m
//  CBStudyDemo
//
//  Created by ChenBin on 16/9/12.
//  Copyright © 2016年 ChenBin. All rights reserved.
//

#import "CBCoreDataConnect.h"
#import "User.h"
#import "CBManagedObjectContextManager.h"

@interface CBCoreDataConnect ()

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

@end

@implementation CBCoreDataConnect

- (instancetype)init {
    if (self = [self initWithManagedObjectContext:[[CBManagedObjectContextManager sharedInstance] managedObjectContext]]) {
        
    }
    return self;
}

- (instancetype)initWithManagedObjectContext:(NSManagedObjectContext *)managedObjectContext {
    if (self = [super init]) {
        self.managedObjectContext = managedObjectContext;
    }
    return self;
}

- (BOOL)insertEntityName:(NSString *)entityName attributeInfo:(NSDictionary<NSString *,id> *)attributeInfo {
    [self.managedObjectContext performBlock:^{
        
    }];
    NSManagedObject *insetData = [NSEntityDescription insertNewObjectForEntityForName:entityName inManagedObjectContext:self.managedObjectContext];
    [attributeInfo enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, id _Nonnull value, BOOL * _Nonnull stop) {
        [insetData setValue:value forKey:key];
    }];
    NSError *error;
    [self.managedObjectContext save:&error];
    return  error == nil;
}

- (NSArray<User *> *)fetchWithEntityName:(NSString *)entityName predicate:(NSString *)predicate {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:entityName];
    if (predicate) {
        request.predicate = [NSPredicate predicateWithFormat:predicate];
    }
    NSError *error;
    return [self.managedObjectContext executeFetchRequest:request error:&error];
}

- (BOOL)updateWithEntityName:(NSString *)entityName predicate:(NSString *)predicate attributeInfo:(NSDictionary<NSString *,NSString *> *)attributeInfo {
    NSArray<User *> *results = [self fetchWithEntityName:entityName predicate:predicate];
    [results enumerateObjectsUsingBlock:^(User * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [attributeInfo enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSString * _Nonnull value, BOOL * _Nonnull stop) {
            [obj setValue:value forKey:key];
        }];
    }];
    NSError *error;
    [self.managedObjectContext save:&error];
    return error == nil;
}

- (BOOL)deleteWithEntityName:(NSString *)entityName predicate:(NSString *)predicate {
    NSArray<User *> *results = [self fetchWithEntityName:entityName predicate:predicate];
    [results enumerateObjectsUsingBlock:^(User * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.managedObjectContext deleteObject:obj];
    }];
    NSError *error;
    [self.managedObjectContext save:&error];
    return error == nil;
}
@end
