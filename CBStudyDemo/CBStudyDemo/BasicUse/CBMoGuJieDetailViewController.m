//
//  CBMoGuJieDetailViewController.m
//  CBStudyDemo
//
//  Created by ChenBin on 16/8/29.
//  Copyright © 2016年 ChenBin. All rights reserved.
//

#import "CBMoGuJieDetailViewController.h"

@interface CBSegmentBaseView : UIView

@property (nonatomic, strong)UILabel *titleLab;

@end


@interface CBMoGuJieDetailViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIScrollView *horizontalScrollView;
@property (nonatomic, strong) NSArray<UITableView *> *allTableViewArr;
@property (nonatomic, assign) NSInteger curSelectedIndex;
@property (nonatomic, strong) UIView *commonHeaderView;
@property (nonatomic, strong) CBSegmentBaseView *segmentView;
@property (nonatomic, strong) UIView *tableViewHeaderView;

@end

@implementation CBMoGuJieDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableViewHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 300 + 40)];
    self.commonHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 300)];
    self.commonHeaderView.backgroundColor = [UIColor redColor];
    [self.tableViewHeaderView addSubview:self.commonHeaderView];
    
    self.segmentView = [[CBSegmentBaseView alloc] initWithFrame:CGRectMake(0, self.commonHeaderView.bottom, self.view.width, 40)];
    self.segmentView.backgroundColor = [UIColor greenColor];
    [self.tableViewHeaderView addSubview:self.segmentView];
    
    
    self.allTableViewArr = @[[self createTableView:1], [self createTableView:2], [self createTableView:3]];
    self.horizontalScrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    self.horizontalScrollView.pagingEnabled = YES;
    self.horizontalScrollView.contentSize = CGSizeMake(self.allTableViewArr.count * self.horizontalScrollView.width, self.horizontalScrollView.height);
    self.horizontalScrollView.backgroundColor = [UIColor clearColor];
    self.horizontalScrollView.delegate = self;
    self.horizontalScrollView.clipsToBounds = YES;
    [self.view addSubview:self.horizontalScrollView];
    [self.allTableViewArr enumerateObjectsUsingBlock:^(UITableView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.horizontalScrollView addSubview:obj];
        obj.frame = CGRectMake(idx * self.horizontalScrollView.width, 0, self.horizontalScrollView.width, self.horizontalScrollView.height);
        obj.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.horizontalScrollView.width, self.commonHeaderView.height + self.segmentView.height)];
    }];
    
    [self updateHeaderToCurTableView];
}

- (void)updateHeaderToCurTableView {
    UITableView *curTableView = self.allTableViewArr[self.curSelectedIndex];
    [curTableView addSubview:self.tableViewHeaderView];
    self.tableViewHeaderView.x = 0;
    if (curTableView.contentOffset.y > self.commonHeaderView.height) {
        self.tableViewHeaderView.y = curTableView.contentOffset.y - self.commonHeaderView.height;
    } else {
        self.tableViewHeaderView.y = 0;
    }
    [curTableView bringSubviewToFront:self.tableViewHeaderView];
    self.segmentView.titleLab.text = [NSString stringWithFormat:@"当前选中：%ld",self.curSelectedIndex + 1];
}


#pragma mark scrollview delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.horizontalScrollView) {
        CGFloat x = scrollView.contentOffset.x;
        self.tableViewHeaderView.x = x > 0 ? x : 0;
        if ((int)scrollView.contentOffset.x % (int)scrollView.width == 0.0) {
            self.curSelectedIndex = scrollView.contentOffset.x / scrollView.width;
            [self updateHeaderToCurTableView];
        }
    } else {
        if (scrollView.contentOffset.y > self.commonHeaderView.height) {
            self.tableViewHeaderView.y = scrollView.contentOffset.y - self.commonHeaderView.height;
        } else {
            self.tableViewHeaderView.y = 0;
        }
        [scrollView bringSubviewToFront:self.tableViewHeaderView];
        [self.allTableViewArr enumerateObjectsUsingBlock:^(UITableView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (self.curSelectedIndex != idx) {
                obj.contentOffset = scrollView.contentOffset;
            }
        }];
    }
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (scrollView == self.horizontalScrollView) {
        if (self.tableViewHeaderView.superview != self.horizontalScrollView) {
            
            CGFloat y = -((UIScrollView *)self.tableViewHeaderView.superview).contentOffset.y;
            if (-y > self.commonHeaderView.height) {
                y = -self.commonHeaderView.height;
            }
            [self.horizontalScrollView addSubview:self.tableViewHeaderView];
            self.tableViewHeaderView.y = y;
            self.tableViewHeaderView.x = scrollView.contentOffset.x;
            [self.horizontalScrollView bringSubviewToFront:self.tableViewHeaderView];
        }
    }
}

#pragma mark tableview delegate and datasource

- (UITableView *)createTableView:(NSInteger)tag {
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.tag = tag;
    tableView.backgroundColor = [UIColor clearColor];
    tableView.clipsToBounds = YES;
    return tableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 100;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"tableView%ld===Cell:%ld", (long)tableView.tag, (long)[indexPath row]];
    return cell;
}

@end

@implementation CBSegmentBaseView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.titleLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, frame.size.width, frame.size.height)];
        self.titleLab.textColor = [UIColor blackColor];
        [self addSubview:self.titleLab];
    }
    return self;
}

@end
