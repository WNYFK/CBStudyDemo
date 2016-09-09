//
//  CBManagedObject.h
//  CBStudyDemo
//
//  Created by ChenBin on 16/9/9.
//  Copyright © 2016年 ChenBin. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface CBManagedObject : NSManagedObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSNumber *order;
@property (nonatomic, strong) CBManagedObject *parent;
@property (nonatomic, strong) NSSet *children;

+ (instancetype)insertItemWithTitle:(NSString *)title
                             parent:(CBManagedObject *)parent
             inManagedObejctContext:(NSManagedObjectContext *)managedObjectContext;

- (NSFetchedResultsController *)childrenFetchedResultsController;

@end
