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

@interface CBStrechableHeaderView : UIView

@end

@interface CBStrechableSegmentBaseView : UIView

@end

@interface CBStrechableTestViewController ()

@end

@implementation CBStrechableTestViewController

- (void)viewDidLoad {
    self.viewControllers = @[[[CBStrechableFirstViewController alloc] init], [[CBStrechableSecViewController alloc] init]];
    self.commonHeaderView = [[CBStrechableHeaderView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 200)];
    self.commonHeaderView.backgroundColor = [UIColor yellowColor];
    self.commonSegmentView = [[CBStrechableSegmentBaseView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 60)];
    self.commonSegmentView.backgroundColor = [UIColor orangeColor];
    [super viewDidLoad];
}

@end


@implementation CBStrechableHeaderView



@end

@implementation CBStrechableSegmentBaseView



@end