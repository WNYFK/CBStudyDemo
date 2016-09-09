//
//  CBManagedObject.m
//  CBStudyDemo
//
//  Created by ChenBin on 16/9/9.
//  Copyright © 2016年 ChenBin. All rights reserved.
//

#import "CBManagedObject.h"

@implementation CBManagedObject
@dynamic title, parent, children, order;

+ (instancetype)insertItemWithTitle:(NSString *)title parent:(CBManagedObject *)parent inManagedObejctContext:(NSManagedObjectContext *)managedObjectContext {
    NSUInteger order = parent.numberOfChildren;
    CBManagedObject *managedObejct = [NSEntityDescription insertNewObjectForEntityForName:self.entityName inManagedObjectContext:managedObjectContext];
    managedObejct.title = title;
    managedObejct.parent = parent;
    managedObejct.order = @(order);
    return managedObejct;
}

+ (NSString *)entityName {
    return @"CBManagedObject";
}

- (NSUInteger)numberOfChildren {
    return self.children.count;
}

- (NSFetchedResultsController *)childrenFetchedResultsController {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:[self.class entityName]];
    request.predicate = [NSPredicate predicateWithFormat:@"parent = %@", self];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"order" ascending:YES]];
    return [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
}

- (void)prepareForDeletion {
    if (self.parent.isDeleted) return;
    NSSet *siblings = self.parent.children;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"order > %@", self.order];
    NSSet *itemsAfterSelf = [siblings filteredSetUsingPredicate:predicate];
    [itemsAfterSelf enumerateObjectsUsingBlock:^(CBManagedObject*  _Nonnull sibling, BOOL * _Nonnull stop) {
        sibling.order = @(sibling.order.integerValue - 1);
    }];
}


@end
