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

@end

@implementation CBStrechableHeaderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.commonContentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 0)];
    [self.commonContentView addSubview:self.commonHeaderView];
    [self.commonContentView addSubview:self.commonSegmentView];
    self.commonHeaderView.y = 0;
    self.commonSegmentView.y = self.commonHeaderView.bottom;
    self.commonContentView.height = self.commonSegmentView.bottom;
    
    self.horizontalScrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    self.horizontalScrollView.delegate = self;
    self.horizontalScrollView.pagingEnabled = YES;
    [self.view addSubview:self.horizontalScrollView];
    self.horizontalScrollView.contentSize = CGSizeMake(self.horizontalScrollView.width * self.viewControllers.count, self.horizontalScrollView.height);
    
    [self.viewControllers enumerateObjectsUsingBlock:^(UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self addChildViewController:obj];
        id<CBStrechableHeaderProtocol> delegate = (id<CBStrechableHeaderProtocol>)obj;
        if ([delegate respondsToSelector:@selector(contentScrollView)]) {
            [self.horizontalScrollView addSubview:obj.view];
            [obj didMoveToParentViewController:self];
            obj.view.x = idx * self.horizontalScrollView.width;
            UIScrollView *ctScrollView = [delegate contentScrollView];
            ctScrollView.contentInset = UIEdgeInsetsMake(self.commonContentView.height, 0, 0, 0);
        }
    }];
    [self updateHeaderToCurScrollView];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.viewControllers enumerateObjectsUsingBlock:^(UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        id<CBStrechableHeaderProtocol> delegate = (id<CBStrechableHeaderProtocol>)obj;
        if ([delegate respondsToSelector:@selector(contentScrollView)]) {
            UIScrollView *ctScrollView = [delegate contentScrollView];
            [self addObserverSubViewControllerScrollView:ctScrollView];
        }
    }];
}

- (void)addObserverSubViewControllerScrollView:(UIScrollView *)scrollView {
    @weakify(self);
    [RACObserve(scrollView, contentOffset) subscribeNext:^(NSValue *x) {
        @strongify(self);
        CGPoint point = [x CGPointValue];
        if (point.y - scrollView.contentInset.top > self.commonHeaderView.height) {
            self.commonContentView.y = point.y - scrollView.contentInset.top - self.commonHeaderView.height;
        } else {
            self.commonHeaderView.y = -scrollView.contentInset.top;
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

- (void)updateHeaderToCurScrollView {
    UIViewController *curViewController = self.viewControllers[self.curSelectedIndex];
    id<CBStrechableHeaderProtocol> delegate = (id<CBStrechableHeaderProtocol>)curViewController;
    if ([delegate respondsToSelector:@selector(contentScrollView)]) {
        UIScrollView *curScrollView = [delegate contentScrollView];
        [curScrollView addSubview:self.commonContentView];
        self.commonContentView.x = 0;
        if (curScrollView.contentOffset.y - curScrollView.contentInset.top > self.commonHeaderView.height) {
            self.commonContentView.y = curScrollView.contentOffset.y - curScrollView.contentInset.top - self.commonContentView.height;
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
        if ((int)scrollView.contentOffset.x % (int)scrollView.width == 0.0) {
            self.curSelectedIndex = scrollView.contentOffset.x / scrollView.width;
            [self updateHeaderToCurScrollView];
        }
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (scrollView == self.horizontalScrollView) {
        if (self.commonContentView.superview != self.horizontalScrollView) {
            
            CGFloat y = -((UIScrollView *)self.commonContentView.superview).contentOffset.y;
            if (-y > self.commonHeaderView.height) {
                y = -self.commonHeaderView.height;
            }
            [self.horizontalScrollView addSubview:self.commonContentView];
            self.commonContentView.y = y;
            self.commonContentView.x = scrollView.contentOffset.x;
            [self.horizontalScrollView bringSubviewToFront:self.commonContentView];
        }
    }
}

@end
