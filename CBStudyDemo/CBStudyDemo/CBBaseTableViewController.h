//
//  CBBaseTableViewController.h
//  CBStudyDemo
//
//  Created by ChenBin on 16/8/12.
//  Copyright © 2016年 ChenBin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CBSectionItem;
@interface CBBaseTableViewController : UIViewController

@property (nonatomic, strong) NSMutableArray<CBSectionItem *> *dataArr;
@property (nonatomic, readonly) UITableView *tableView;

@end
