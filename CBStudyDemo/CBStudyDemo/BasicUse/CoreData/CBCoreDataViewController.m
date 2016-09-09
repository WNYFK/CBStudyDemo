//
//  CBCoreDataViewController.m
//  CBStudyDemo
//
//  Created by ChenBin on 16/8/17.
//  Copyright © 2016年 ChenBin. All rights reserved.
//

#import "CBCoreDataViewController.h"
#import <CoreData/CoreData.h>
#import "CBManagedObject.h"
#import "CBFetchedResultsControllerDataSource.h"
#import "CBPresistentStack.h"
#import "CBStore.h"

@interface CBCoreDataViewController ()<CBFetchedResultsControllerDataSourceDelegate>

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) CBManagedObject *managedObject;
@property (nonatomic, strong) CBFetchedResultsControllerDataSource *fetchedResultsControllerDataSource;
@property (nonatomic, assign) NSInteger index;

@property (nonatomic, strong) CBManagedObject *parentManagedObject;

@property (nonatomic, strong) CBStore *store;
@property (nonatomic, strong) CBPresistentStack *persistentStack;

@end

@implementation CBCoreDataViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem creatBarButtonWithTitle:@"添加" callBack:^(UIBarButtonItem *buttonItem) {
        NSString *title = [NSString stringWithFormat:@"添加：%ld",(long)self.index];
        NSString* actionName = [NSString stringWithFormat:NSLocalizedString(@"add item \"%@\"", @"Undo action name of add item"), title];
        [self.undoManager setActionName:actionName];
        [CBManagedObject insertItemWithTitle:title parent:self.parentManagedObject inManagedObejctContext:self.managedObjectContext];
    }];
    [self setupParent];
    [self setupFetchedResultsController];
}

- (void)setupParent {
    self.persistentStack = [[CBPresistentStack alloc] initWithStoreURL:[self storeURL] modelURL:[self modelURL]];
    self.store = [[CBStore alloc] init];
    self.store.managedObjectContext = self.persistentStack.managedObjectContext;
    self.parentManagedObject = self.store.managedObject;
}

- (NSURL*)storeURL
{
    NSURL* documentsDirectory = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:YES error:NULL];
    return [documentsDirectory URLByAppendingPathComponent:@"db.sqlite"];
}

- (NSURL*)modelURL
{
    return [[NSBundle mainBundle] URLForResource:@"CBStudyDemo" withExtension:@"momd"];
}

- (void)setupFetchedResultsController {
    self.fetchedResultsControllerDataSource = [[CBFetchedResultsControllerDataSource alloc] initWihTableView:self.tableView];
    self.fetchedResultsControllerDataSource.fetchedResultsController = [self.parentManagedObject childrenFetchedResultsController];
    self.fetchedResultsControllerDataSource.delegate = self;
    self.fetchedResultsControllerDataSource.reuseIdentifier = @"Cell";
}

- (NSManagedObjectContext *)managedObjectContext {
    return self.parentManagedObject.managedObjectContext;
}

- (void)setParentManagedObject:(CBManagedObject *)parentManagedObject {
    _parentManagedObject = parentManagedObject;
    self.navigationItem.title = parentManagedObject.title;
}

- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (NSUndoManager *)undoManager {
    return self.managedObjectContext.undoManager;
}

#pragma mark fetched results controller delegate

- (void)configureCell:(UITableViewCell *)cell withObejct:(id)object {
    CBManagedObject *item = object;
    cell.textLabel.text = item.title;
}

- (void)deleteObject:(id)object {
    CBManagedObject *item = object;
    NSString* actionName = [NSString stringWithFormat:NSLocalizedString(@"Delete \"%@\"", @"Delete undo action name"), item.title];
    [self.undoManager setActionName:actionName];
    [item.managedObjectContext deleteObject:item];
}

@end
