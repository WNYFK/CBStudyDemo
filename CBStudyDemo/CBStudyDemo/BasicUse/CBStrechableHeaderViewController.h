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

@end

@protocol CBStrechableHandleDelegate <NSObject>

- (void)selectedViewControllerWithIndex:(NSUInteger)index viewController:(UIViewController<CBStrechableHeaderProtocol> *)viewController;

@end

@interface CBStrechableHeaderViewController : CBBaseViewController

@property (nonatomic, weak) id<CBStrechableHandleDelegate> delegate;
@property (nonatomic, copy) NSArray<UIViewController<CBStrechableHeaderProtocol> *> *viewControllers;
@property (nonatomic, strong) UIView *commonHeaderView;
@property (nonatomic, strong) UIView *commonSegmentView;

- (void)selectViewControllerWithIndex:(NSUInteger)index;

@end
