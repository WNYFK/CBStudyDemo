//
//  CBStore.m
//  CBStudyDemo
//
//  Created by ChenBin on 16/9/9.
//  Copyright © 2016年 ChenBin. All rights reserved.
//

#import "CBStore.h"
#import "CBManagedObject.h"
#import <CoreData/CoreData.h>

@implementation CBStore

- (CBManagedObject *)managedObject {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"CBManagedObject"];
    request.predicate = [NSPredicate predicateWithFormat:@"parent = %@", nil];
    NSArray *objects = [self.managedObjectContext executeFetchRequest:request error:NULL];
    CBManagedObject *managedObject = [objects lastObject];
    if (managedObject == nil) {
        managedObject = [CBManagedObject insertItemWithTitle:nil parent:nil inManagedObejctContext:self.managedObjectContext];
    }
    return managedObject;
}

@end
