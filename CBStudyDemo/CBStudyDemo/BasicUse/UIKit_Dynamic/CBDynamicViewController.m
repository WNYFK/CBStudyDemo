//
//  CBDynamicViewController.m
//  CBStudyDemo
//
//  Created by ChenBin on 16/9/6.
//  Copyright © 2016年 ChenBin. All rights reserved.
//

#import "CBDynamicViewController.h"
#import "CBDynamicCell.h"
#import "CBDynamicView.h"
#import "CBHorizontalSwipView.h"

@interface CBDynamicViewController ()<UITableViewDelegate, UITableViewDataSource, CBHorizontalScrollDelegate>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation CBDynamicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
}

#pragma mark tableView delegate and datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"cellIdentifier";
    CBDynamicCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[CBDynamicCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.dynamicView.delegate = self;
    }
    cell.row = indexPath.row;
    return cell;
}

#pragma mark headerViewDelegate

- (CGPoint)minDynamicViewPosition {
    return CGPointZero;
}

- (CGPoint)maxDynamicViewPosition {
    return CGPointZero;
}

- (void)headerViewDidFrameChanged:(UIView *)headerView {
    NSArray<CBDynamicCell *> *visibleCells = self.tableView.visibleCells;
    [visibleCells enumerateObjectsUsingBlock:^(CBDynamicCell * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.dynamicView != headerView) {
            obj.dynamicView.frame = headerView.frame;
        }
    }];
}

- (void)headerView:(CBDynamicView *)headerView didPan:(UIPanGestureRecognizer *)pan {
    
}

- (void)headerView:(CBDynamicView *)headerView didPanGestureRecognizerStateChanged:(UIPanGestureRecognizer *)pan {
    
}

@end
