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
    [self updateCommonHeader:[[CBStrechableHeaderView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 200)] segmentView:[[CBStrechableSegmentBaseView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 60)] subViewControllers:@[[[CBStrechableFirstViewController alloc] init], [[CBStrechableSecViewController alloc] init], [[CBStrechableScrollViewController alloc] init]]];
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