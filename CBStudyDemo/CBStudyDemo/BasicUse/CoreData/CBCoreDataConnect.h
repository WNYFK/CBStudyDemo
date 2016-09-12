//
//  CBCoreDataConnect.h
//  CBStudyDemo
//
//  Created by ChenBin on 16/9/12.
//  Copyright © 2016年 ChenBin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class User;

@interface CBCoreDataConnect : NSObject

@property (nonatomic, strong, readonly) NSManagedObjectContext *managedObjectContext;

- (instancetype)initWithManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;

- (BOOL)insertEntityName:(NSString *)entityName attributeInfo:(NSDictionary<NSString*, id> *)attributeInfo;
- (NSArray<User *> *)fetchWithEntityName:(NSString *)entityName predicate:(NSString *)predicate;
- (BOOL)updateWithEntityName:(NSString *)entityName predicate:(NSString *)predicate attributeInfo:(NSDictionary<NSString*, NSString*> *)attributeInfo;
- (BOOL)deleteWithEntityName:(NSString *)entityName predicate:(NSString *)predicate;

@end
