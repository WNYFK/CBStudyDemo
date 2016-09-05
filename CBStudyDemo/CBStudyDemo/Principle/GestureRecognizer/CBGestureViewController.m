//
//  CBGestureViewController.m
//  CBStudyDemo
//
//  Created by chenbin on 16/9/3.
//  Copyright © 2016年 ChenBin. All rights reserved.
//

#import "CBGestureViewController.h"
#import "CBGestureScrollView.h"
#import "CBHorizontalView.h"

@interface CBGestureViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) CBGestureScrollView *contentScrollView;
@property (nonatomic, strong) UITableView *tableViewOne;
@property (nonatomic, strong) UITableView *tableViewTwo;
@property (nonatomic, strong) CBHorizontalView *horizontalView;
@property (nonatomic, strong) UIView *rightHorizontalView;

@end

@implementation CBGestureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.horizontalView = [[CBHorizontalView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 200)];
    self.horizontalView.backgroundColor = [UIColor yellowColor];
    [self.contentScrollView addSubview:self.horizontalView];
    
    self.tableViewOne = [[UITableView alloc] initWithFrame:CGRectMake(0, self.horizontalView.bottom, self.view.width, self.view.height - self.horizontalView.height) style:UITableViewStylePlain];
    self.tableViewOne.delegate = self;
    self.tableViewOne.dataSource = self;
    [self.contentScrollView addSubview:self.tableViewOne];
    
    self.rightHorizontalView = [[UIView alloc] initWithFrame:CGRectMake(self.horizontalView.right, 0, self.view.width, 300)];
    self.rightHorizontalView.backgroundColor = [UIColor orangeColor];
    [self.contentScrollView addSubview:self.rightHorizontalView];
    
    self.tableViewTwo = [[UITableView alloc] initWithFrame:CGRectMake(self.tableViewOne.right, self.rightHorizontalView.bottom, self.view.width, self.contentScrollView.height - self.rightHorizontalView.bottom) style:UITableViewStylePlain];
    self.tableViewTwo.delegate = self;
    self.tableViewTwo.dataSource = self;
    [self.contentScrollView addSubview:self.tableViewTwo];
}

- (CBGestureScrollView *)contentScrollView {
    if (!_contentScrollView) {
        _contentScrollView = [[CBGestureScrollView alloc] initWithFrame:self.view.bounds];
        _contentScrollView.pagingEnabled = YES;
        _contentScrollView.contentSize = CGSizeMake(2 * CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds));
        [self.view addSubview:_contentScrollView];
    }
    return _contentScrollView;
}

#pragma mark tableview delegate and datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 100;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifer = @"cellIdentifer";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifer];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifer];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"cell: %ld",(long)indexPath.row];
    return cell;
}

@end
