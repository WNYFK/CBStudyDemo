//
//  CBStrechableFirstViewController.m
//  CBStudyDemo
//
//  Created by chenbin on 16/8/29.
//  Copyright © 2016年 ChenBin. All rights reserved.
//

#import "CBStrechableFirstViewController.h"

@interface CBStrechableFirstViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation CBStrechableFirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - 64) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 200)];
    headerView.backgroundColor = [UIColor orangeColor];
    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 100, 200, 30)];
    titleLab.text = @"tableview 1的私有header啊啊啊";
    titleLab.textColor = [UIColor blackColor];
    [headerView addSubview:titleLab];
    self.tableView.tableHeaderView = headerView;
}

#pragma mark CBStrechableHeaderProtocol 

- (UIScrollView *)contentScrollView {
    return self.tableView;
}

- (void)selectedViewControllerWithIndex:(NSUInteger)index viewController:(UIViewController *)viewController {
    NSLog(@"选中：%lu", (unsigned long)index);
}

#pragma mark UITableViewDelegate and UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"tableView1===Cell:%ld",(long)indexPath.row];
    return cell;
}

@end
