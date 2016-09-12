//
//  CBCoreDataFirstUseViewController.m
//  CBStudyDemo
//
//  Created by ChenBin on 16/9/12.
//  Copyright © 2016年 ChenBin. All rights reserved.
//

#import "CBCoreDataFirstUseViewController.h"
#import "CBCoreDataConnect.h"
#import "User.h"

@interface CBCoreDataFirstUseViewController ()

@property (nonatomic, strong) CBCoreDataConnect *coreDataConnect;

@end

@implementation CBCoreDataFirstUseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"";
    CBSectionItem *sectionItem = [[CBSectionItem alloc] init];
    [self.dataArr addObject:sectionItem];
    
    self.coreDataConnect = [[CBCoreDataConnect alloc] init];
    NSArray<User *> *users = [self.coreDataConnect fetchWithEntityName:@"User" predicate:nil];
    [users enumerateObjectsUsingBlock:^(User * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [sectionItem.cellItems addObject:[[CBSkipItem alloc] initWithTitle:obj.name destinationClass:nil]];
    }];
    
    UIBarButtonItem *addBarButtonItem = [UIBarButtonItem creatBarButtonWithTitle:@"添加" callBack:^(UIBarButtonItem *buttonItem) {
        NSString *name = [NSString stringWithFormat:@"chenbin:%lu",sectionItem.cellItems.count + 1];
        NSString *result = [NSString stringWithFormat:@"添加失败--%@", name];
        if ([self.coreDataConnect insertEntityName:@"User" attributeInfo:@{@"name": name}] ) {
            [sectionItem.cellItems addObject:[[CBSkipItem alloc] initWithTitle:name destinationClass:nil]];
            [self.tableView reloadData];
            result = [NSString stringWithFormat:@"添加成功--%@",name];
        }
        [CRToastManager showNotificationWithMessage:result completionBlock:nil];
    }];
    
    UIBarButtonItem *deleteBarButtonItem = [UIBarButtonItem creatBarButtonWithTitle:@"删除" callBack:^(UIBarButtonItem *buttonItem) {
        if (sectionItem.cellItems.count == 0) return;
        NSInteger row = (sectionItem.cellItems.count > 1) ? rand() % (sectionItem.cellItems.count - 1) : 0;
        CBSkipItem *cellItem = [sectionItem.cellItems objectAtIndex: row];
        NSString *result = @"删除失败";
        if ([self.coreDataConnect deleteWithEntityName:@"User" predicate:[NSString stringWithFormat:@"name = '%@'",cellItem.title]]) {
            [sectionItem.cellItems removeObjectAtIndex:row];
            [self.tableView reloadData];
            result = [NSString stringWithFormat:@"成功删除第%ld",(long)row];
        }
        [CRToastManager showNotificationWithMessage:result completionBlock:nil];
    }];
    
    UIBarButtonItem *updateBarButtonItem = [UIBarButtonItem creatBarButtonWithTitle:@"更新" callBack:^(UIBarButtonItem *buttonItem) {
        if (sectionItem.cellItems.count == 0) return;
        CBSkipItem *cellItem = [sectionItem.cellItems objectAtIndex: (sectionItem.cellItems.count > 1) ? rand() % (sectionItem.cellItems.count - 1) : 0];
        NSString *newTitle = [cellItem.title stringByAppendingString:@"3"];
        NSString *result = [NSString stringWithFormat:@"更新失败--%@",cellItem.title];
        if ([self.coreDataConnect updateWithEntityName:@"User" predicate:[NSString stringWithFormat:@"name = '%@'",cellItem.title] attributeInfo:@{@"name" : newTitle}]) {
            cellItem.title = newTitle;
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
            result = [NSString stringWithFormat:@"更新成功--%@",newTitle];
        }
        [CRToastManager showNotificationWithMessage:result completionBlock:nil];
    }];
    self.navigationItem.rightBarButtonItems = @[addBarButtonItem, deleteBarButtonItem, updateBarButtonItem];
}
@end
