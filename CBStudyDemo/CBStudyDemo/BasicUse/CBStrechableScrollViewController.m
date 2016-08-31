//
//  CBStrechableScrollViewController.m
//  CBStudyDemo
//
//  Created by chenbin on 16/8/31.
//  Copyright © 2016年 ChenBin. All rights reserved.
//

#import "CBStrechableScrollViewController.h"

@interface CBStrechableScrollViewController ()

@property (nonatomic, strong) UIScrollView *scrollView;

@end

@implementation CBStrechableScrollViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupSubViews];
}

- (UIScrollView *)contentScrollView {
    return self.scrollView;
}

- (void)selectedViewControllerWithIndex:(NSUInteger)index viewController:(UIViewController *)viewController {
    
}

- (void)setupSubViews {
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.scrollView];
    self.scrollView.contentSize = CGSizeMake(self.view.width, 2 * self.view.height);
    UILabel *lab1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 100, self.view.width, 40)];
    lab1.backgroundColor = [UIColor orangeColor];
    lab1.text = @"我是scrollView 啊啊啊啊啊";
    [self.scrollView addSubview:lab1];
    
    UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(0, lab1.bottom + 20, self.view.width, 100)];
    view1.backgroundColor = [UIColor redColor];
    [self.scrollView addSubview:view1];
    
    UIView *view2 = [[UIView alloc] initWithFrame:CGRectMake(0, view1.bottom + 20, self.view.width, 200)];
    view2.backgroundColor = [UIColor greenColor];
    [self.scrollView addSubview:view2];
    
    UIView *view3 = [[UIView alloc] initWithFrame:CGRectMake(0, view2.bottom + 20, self.view.width, 300)];
    view3.backgroundColor = [UIColor yellowColor];
    [self.scrollView addSubview:view3];
    
}
@end
