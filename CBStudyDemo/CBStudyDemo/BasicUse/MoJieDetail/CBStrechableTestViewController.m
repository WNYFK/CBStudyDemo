//
//  CBStrechableTestViewController.m
//  CBStudyDemo
//
//  Created by chenbin on 16/8/29.
//  Copyright © 2016年 ChenBin. All rights reserved.
//

#import "CBStrechableTestViewController.h"
#import "CBStrechableFirstViewController.h"
#import "CBStrechableSecViewController.h"
#import "CBStrechableScrollViewController.h"

@interface CBStrechableHeaderView : UIView
@end

@interface CBStrechableSegmentBaseView : UIView
@end

@interface CBStrechableTestViewController ()

@end

@implementation CBStrechableTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.viewControllers = @[[[CBStrechableFirstViewController alloc] init], [[CBStrechableSecViewController alloc] init], [[CBStrechableScrollViewController alloc] init]];
    self.commonHeaderView = [[CBStrechableHeaderView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 100)];
    self.commonHeaderView.backgroundColor = [UIColor yellowColor];
    self.commonSegmentView = [[CBStrechableSegmentBaseView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 60)];
    self.commonSegmentView.backgroundColor = [UIColor brownColor];
    
    self.navigationItem.rightBarButtonItems = @[[[UIBarButtonItem alloc] initWithTitle:@"删除头部" style:UIBarButtonItemStylePlain target:self
                                                                               action:@selector(deleteCommHeader)], [[UIBarButtonItem alloc] initWithTitle:@"添加头部" style:UIBarButtonItemStylePlain target:self
                                                                                                                                                    action:@selector(addCommonHeader)]];
    [self selectViewControllerWithIndex:1];
}

- (void)addCommonHeader {
    self.commonHeaderView = [[CBStrechableHeaderView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 200)];
}

- (void)deleteCommHeader {
    self.commonHeaderView = nil;
}

@end


@implementation CBStrechableHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupBaseSubViews];
    }
    return self;
}

- (void)setupBaseSubViews {
    self.backgroundColor = [UIColor yellowColor];
    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, 200, 30)];
    titleLab.text = @"公共头部啊啊啊";
    titleLab.textColor = [UIColor blackColor];
    [self addSubview:titleLab];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, titleLab.bottom + 20, 200, 60);
    [btn setTitle:@"btn 啊啊啊" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self addSubview:btn];
    [[btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        NSLog(@"公共头部btn点击啊啊啊啊");
    }];
}

@end

@implementation CBStrechableSegmentBaseView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, self.height)];
        titleLab.text = @"Segment啊啊啊啊";
        titleLab.textColor = [UIColor blackColor];
        [self addSubview:titleLab];
    }
    return self;
}

@end