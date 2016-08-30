//
//  CBStrechableHeaderViewController.h
//  CBStudyDemo
//
//  Created by chenbin on 16/8/29.
//  Copyright © 2016年 ChenBin. All rights reserved.
//

#import "CBBaseViewController.h"

@protocol CBStrechableHeaderProtocol <NSObject>

- (UIScrollView *)contentScrollView;

- (void)selectedViewControllerWithIndex:(NSUInteger)index viewController:(UIViewController *)viewController;

@end

@interface CBStrechableHeaderViewController : CBBaseViewController

@property (nonatomic, copy) NSArray<UIViewController *> *viewControllers;

- (void)selectViewControllerWithIndex:(NSUInteger)index;
- (void)updateCommonHeader:(UIView *)headerView segmentView:(UIView *)segment;

@end
