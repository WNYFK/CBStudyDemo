//
//  CBStrechableHeaderViewController.m
//  CBStudyDemo
//
//  Created by chenbin on 16/8/29.
//  Copyright © 2016年 ChenBin. All rights reserved.
//

#import "CBStrechableHeaderViewController.h"

@interface CBStrechableHeaderViewController ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *horizontalScrollView;
@property (nonatomic, strong) UIView *commonContentView;
@property (nonatomic, assign) NSUInteger curSelectedIndex;
@property (nonatomic, strong) UIView *commonHeaderView;
@property (nonatomic, strong) UIView *commonSegmentView;
@property (nonatomic, copy) NSArray<UIViewController *> *viewControllers;
@property (nonatomic, assign) BOOL isEndDraging;

@end

@implementation CBStrechableHeaderViewController

- (UIView *)commonContentView {
    if (!_commonContentView) {
        _commonContentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 0)];
    }
    return _commonContentView;
}

- (UIScrollView *)horizontalScrollView {
    if (!_horizontalScrollView) {
        _horizontalScrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
        _horizontalScrollView.delegate = self;
        _horizontalScrollView.pagingEnabled = YES;
        _horizontalScrollView.bounces = NO;
        _horizontalScrollView.showsHorizontalScrollIndicator = NO;
        [self.view addSubview:_horizontalScrollView];
    }
    return _horizontalScrollView;
}

- (void)updateCommonHeader:(UIView *)headerView segmentView:(UIView *)segment subViewControllers:(NSArray<UIViewController *> *)viewControllers {
    self.viewControllers = viewControllers;
    self.commonHeaderView = headerView;
    self.commonHeaderView.backgroundColor = [UIColor redColor];
    self.commonSegmentView = segment;
    self.commonSegmentView.backgroundColor = [UIColor greenColor];
    [self.commonContentView addSubview:self.commonHeaderView];
    [self.commonContentView addSubview:self.commonSegmentView];
    self.commonHeaderView.y = 0;
    self.commonSegmentView.y = self.commonHeaderView.bottom;
    self.commonContentView.height = self.commonSegmentView.bottom;
    
    self.horizontalScrollView.contentSize = CGSizeMake(self.horizontalScrollView.width * viewControllers.count, self.horizontalScrollView.height);
    [viewControllers enumerateObjectsUsingBlock:^(UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self addChildViewController:obj];
        id<CBStrechableHeaderProtocol> delegate = (id<CBStrechableHeaderProtocol>)obj;
        if ([delegate respondsToSelector:@selector(contentScrollView)]) {
            [self.horizontalScrollView addSubview:obj.view];
            [obj didMoveToParentViewController:self];
            obj.view.x = idx * self.horizontalScrollView.width;
            UIScrollView *ctScrollView = [delegate contentScrollView];
            ctScrollView.contentInset = UIEdgeInsetsMake(self.commonHeaderView.height, ctScrollView.contentInset.left, ctScrollView.contentInset.bottom, ctScrollView.contentInset.right);
        }
    }];
    [self.viewControllers enumerateObjectsUsingBlock:^(UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self addObserverSubViewController:obj];
    }];
    [self updateHeaderToCurScrollView];  
}

- (void)addObserverSubViewController:(UIViewController *)viewController {
    id<CBStrechableHeaderProtocol> delegate = (id<CBStrechableHeaderProtocol>)viewController;
    if ([delegate respondsToSelector:@selector(contentScrollView)]) {
        @weakify(self);
        UIScrollView *scrollView = [delegate contentScrollView];
        [RACObserve(scrollView, contentOffset) subscribeNext:^(NSValue *value) {
            @strongify(self);
            if ([self.viewControllers indexOfObject:viewController] != self.curSelectedIndex) return;
            CGPoint point = [value CGPointValue];
            if ((point.y + scrollView.contentInset.top) >  self.commonHeaderView.height) {
                self.commonContentView.y = point.y - self.commonHeaderView.height;
            } else {
                self.commonContentView.y = -scrollView.contentInset.top;
            }
            [scrollView bringSubviewToFront:self.commonContentView];
            [self.viewControllers enumerateObjectsUsingBlock:^(UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (self.curSelectedIndex != idx) {
                    id<CBStrechableHeaderProtocol> delegate = (id<CBStrechableHeaderProtocol>)obj;
                    if ([delegate respondsToSelector:@selector(contentScrollView)]) {
                        UIScrollView *ctScrollView = [delegate contentScrollView];
                        ctScrollView.contentOffset = point;
                    }
                }
            }];
        }];
    }
}

- (void)updateHeaderToCurScrollView {
    UIViewController *curViewController = self.viewControllers[self.curSelectedIndex];
    id<CBStrechableHeaderProtocol> delegate = (id<CBStrechableHeaderProtocol>)curViewController;
    if ([delegate respondsToSelector:@selector(contentScrollView)]) {
        UIScrollView *curScrollView = [delegate contentScrollView];
        [curScrollView addSubview:self.commonContentView];
        self.commonContentView.x = 0;
        CGPoint point = curScrollView.contentOffset;
        if ((point.y + curScrollView.contentInset.top) >  self.commonHeaderView.height) {
            self.commonContentView.y = point.y - self.commonHeaderView.height;
        } else {
            self.commonContentView.y = -curScrollView.contentInset.top;
        }
        [curScrollView bringSubviewToFront:self.commonContentView];
    }
    if ([delegate respondsToSelector:@selector(selectedViewControllerWithIndex:viewController:)]) {
        [delegate selectedViewControllerWithIndex:self.curSelectedIndex viewController:curViewController];
    }
}

- (void)selectViewControllerWithIndex:(NSUInteger)index {
    if (index < self.viewControllers.count && self.curSelectedIndex != index) {
        self.curSelectedIndex = index;
        [self updateHeaderToCurScrollView];
    }
}

#pragma mark scrollView delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.horizontalScrollView) {
        CGFloat x = scrollView.contentOffset.x;
        self.commonContentView.x = x > 0 ? x : 0;
        if (self.isEndDraging && (int)scrollView.contentOffset.x % (int)scrollView.width <= 1) {
            NSUInteger newPageIndex = floor((scrollView.contentOffset.x - scrollView.frame.size.width / 2)) / scrollView.frame.size.width + 1;
            self.curSelectedIndex = newPageIndex;
            [self updateHeaderToCurScrollView];
        }
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    self.isEndDraging = YES;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (scrollView == self.horizontalScrollView && self.commonContentView.superview != self.horizontalScrollView) {
        UIScrollView *superScrollView = (UIScrollView *)self.commonContentView.superview;
        CGFloat y = -(superScrollView.contentOffset.y + superScrollView.contentInset.top);
        if (y < -self.commonHeaderView.height) {
            y = -self.commonHeaderView.height;
        }
        [self.horizontalScrollView addSubview:self.commonContentView];
        self.commonContentView.y = y;
        self.commonContentView.x = scrollView.contentOffset.x;
        [self.horizontalScrollView bringSubviewToFront:self.commonContentView];
        self.isEndDraging = NO;
    }
}

@end
