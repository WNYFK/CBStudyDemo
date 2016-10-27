//
//  MYPScrollViewPagingViewController.m
//  CBStudyDemo
//
//  Created by ChenBin on 16/9/28.
//  Copyright © 2016年 ChenBin. All rights reserved.
//

#import "MYPScrollViewPagingViewController.h"

@interface MYPScrollViewPagingViewController ()<UIScrollViewDelegate>

@property (strong, nonatomic) UIScrollView *scrollView;

@end

@implementation MYPScrollViewPagingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    self.scrollView.delegate = self;
    self.scrollView.bounces = NO;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.contentSize = CGSizeMake(self.scrollView.width * 3, self.scrollView.height);
    [self.view addSubview:self.scrollView];
    
    UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.scrollView.width, self.scrollView.height)];
    view1.backgroundColor = [UIColor redColor];
    [self.scrollView addSubview:view1];
    
    UIView *view2 = [[UIView alloc] initWithFrame:CGRectMake(view1.right, 0, self.scrollView.width, self.scrollView.height)];
    view2.backgroundColor = [UIColor greenColor];
    [self.scrollView addSubview:view2];
    
    UIView *view3 = [[UIView alloc] initWithFrame:CGRectMake(view2.right, 0, self.scrollView.width, self.scrollView.height)];
    view3.backgroundColor = [UIColor yellowColor];
    [self.scrollView addSubview:view3];
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem creatBarButtonWithTitle:@"点击" callBack:^(UIBarButtonItem *buttonItem) {
        [self.scrollView setContentOffset:CGPointMake(10, 10)];
    }];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSLog(@"");
}

@end
