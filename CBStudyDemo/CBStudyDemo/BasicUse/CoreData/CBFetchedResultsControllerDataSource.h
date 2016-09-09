//
//  CBFetchedResultsControllerDataSource.h
//  CBStudyDemo
//
//  Created by ChenBin on 16/9/9.
//  Copyright © 2016年 ChenBin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class NSFetchedResultsController;

@protocol CBFetchedResultsControllerDataSourceDelegate <NSObject>

- (void)configureCell:(UITableViewCell *)cell withObejct:(id)object;
- (void)deleteObject:(id)object;

@end

@interface CBFetchedResultsControllerDataSource : NSObject<UITableViewDataSource, NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, weak) id<CBFetchedResultsControllerDataSourceDelegate> delegate;
@property (nonatomic, copy) NSString *reuseIdentifier;
@property (nonatomic, assign) BOOL paused;

- (instancetype)initWihTableView:(UITableView *)tableView;
- (instancetype)selectedItem;

@end
