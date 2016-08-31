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
@property (nonatomic, assign) NSInteger curSelectedIndex;
@property (nonatomic, assign) BOOL isEndDraging;
@property (nonatomic, strong) NSMutableArray<NSNumber *> *originSubSViewInsetTopValueArr;

@end

@implementation CBStrechableHeaderViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.curSelectedIndex = -1;
    }
    return self;
}

- (NSMutableArray<NSNumber *> *)originSubSViewInsetTopValueArr {
    if (!_originSubSViewInsetTopValueArr) {
        _originSubSViewInsetTopValueArr = [NSMutableArray array];
    }
    return _originSubSViewInsetTopValueArr;
}

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
        _horizontalScrollView.scrollsToTop = NO;
        _horizontalScrollView.showsHorizontalScrollIndicator = NO;
        [self.view addSubview:_horizontalScrollView];
    }
    return _horizontalScrollView;
}

- (void)setViewControllers:(NSArray<UIViewController<CBStrechableHeaderProtocol> *> *)viewControllers {
    if (_viewControllers == viewControllers) return;
    _viewControllers = viewControllers;
    [self.originSubSViewInsetTopValueArr removeAllObjects];
    self.horizontalScrollView.contentSize = CGSizeMake(self.horizontalScrollView.width * viewControllers.count, self.horizontalScrollView.height);
    [self.viewControllers enumerateObjectsUsingBlock:^(UIViewController<CBStrechableHeaderProtocol> * _Nonnull vc, NSUInteger idx, BOOL * _Nonnull stop) {
        [self addChildViewController:vc];
        if ([vc respondsToSelector:@selector(contentScrollView)]) {
            [self.horizontalScrollView addSubview:vc.view];
            [vc didMoveToParentViewController:self];
            vc.view.x = idx * self.horizontalScrollView.width;
            UIScrollView *ctScrollView = [vc contentScrollView];
            ctScrollView.scrollsToTop = NO;
            [self.originSubSViewInsetTopValueArr addObject:@(ctScrollView.contentInset.top)];
        }
    }];
    [self.viewControllers enumerateObjectsUsingBlock:^(UIViewController<CBStrechableHeaderProtocol> * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self addObserverSubViewController:obj];
    }];
}

- (void)setCommonHeaderView:(UIView *)commonHeaderView {
    if (_commonHeaderView != commonHeaderView) {
        [_commonHeaderView removeFromSuperview];
        _commonHeaderView = commonHeaderView != nil ? commonHeaderView : [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.horizontalScrollView.width, 0)];
        [self.commonContentView addSubview:commonHeaderView];
        [self checkHeaderPosition];
    } else if (_commonHeaderView.height != commonHeaderView.height) {
        [self checkHeaderPosition];
    }
}

- (void)setCommonSegmentView:(UIView *)commonSegmentView {
    if (_commonSegmentView != commonSegmentView) {
        [_commonSegmentView removeFromSuperview];
        _commonSegmentView = commonSegmentView != nil ? commonSegmentView : [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.horizontalScrollView.width, 0)];
        [self.commonContentView addSubview:commonSegmentView];
        [self checkHeaderPosition];
    } else if (_commonSegmentView.height != commonSegmentView.height) {
        [self checkHeaderPosition];
    }
}

- (void)checkHeaderPosition {
    self.commonHeaderView.y = 0;
    self.commonSegmentView.y = self.commonHeaderView.bottom;
    if (self.commonContentView.height != self.commonSegmentView.bottom) {
        self.commonContentView.height = self.commonSegmentView.bottom;
        [self updateSubScrollViewContentInset];
    }
}

- (void)updateSubScrollViewContentInset {
    [self.viewControllers enumerateObjectsUsingBlock:^(UIViewController<CBStrechableHeaderProtocol> * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIScrollView *ctScrollView = [obj contentScrollView];
        if ([ctScrollView isKindOfClass:[UIScrollView class]]) {
            CGFloat top = 0;
            if (self.originSubSViewInsetTopValueArr.count > idx) {
                top = [self.originSubSViewInsetTopValueArr[idx] floatValue];
            } else {
                top = ctScrollView.contentInset.top;
                [self.originSubSViewInsetTopValueArr addObject:@(top)];
            }
            ctScrollView.contentInset = UIEdgeInsetsMake(top + self.commonContentView.height, ctScrollView.contentInset.left, ctScrollView.contentInset.bottom, ctScrollView.contentInset.right);
            ctScrollView.contentOffset = CGPointMake(0, -ctScrollView.contentInset.top);
        }
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    @weakify(self);
    [[[self rac_signalForSelector:@selector(viewDidAppear:)] take:1] subscribeNext:^(id x) {
        @strongify(self);
        [self updateHeaderToCurScrollView:self.curSelectedIndex > 0 ? self.curSelectedIndex : 0];
    }];
}

- (void)addObserverSubViewController:(UIViewController<CBStrechableHeaderProtocol> *)viewController {
    id<CBStrechableHeaderProtocol> vcDelegate = (id<CBStrechableHeaderProtocol>)viewController;
    if ([vcDelegate respondsToSelector:@selector(contentScrollView)]) {
        @weakify(self);
        UIScrollView *scrollView = [vcDelegate contentScrollView];
        [RACObserve(scrollView, contentOffset) subscribeNext:^(NSValue *value) {
            @strongify(self);
            if ([self.viewControllers indexOfObject:viewController] != self.curSelectedIndex) return;
            CGPoint point = [value CGPointValue];
            CGFloat top = scrollView.contentInset.top;
            self.commonContentView.y = point.y + top > self.commonHeaderView.height ? point.y - self.commonHeaderView.height : -top;
            [scrollView bringSubviewToFront:self.commonContentView];
            [self.viewControllers enumerateObjectsUsingBlock:^(UIViewController<CBStrechableHeaderProtocol> * _Nonnull vc, NSUInteger idx, BOOL * _Nonnull stop) {
                if (self.curSelectedIndex != idx && [vc respondsToSelector:@selector(contentScrollView)]) {
                    UIScrollView *ctScrollView = [vc contentScrollView];
                    ctScrollView.contentOffset = point;
                }
            }];
        }];
    }
}

- (void)updateHeaderToCurScrollView:(NSInteger)index {
    if (self.curSelectedIndex >= 0) {
        UIViewController<CBStrechableHeaderProtocol> *lastViewController = self.viewControllers[self.curSelectedIndex];
        lastViewController.contentScrollView.scrollsToTop = NO;
    }
    UIViewController<CBStrechableHeaderProtocol> *curViewController = self.viewControllers[index];
    if ([curViewController respondsToSelector:@selector(contentScrollView)]) {
        UIScrollView *curScrollView = [curViewController contentScrollView];
        curScrollView.scrollsToTop = YES;
        if (curScrollView != self.commonHeaderView.superview) {
            [curScrollView addSubview:self.commonContentView];
            self.commonContentView.x = 0;
            CGPoint point = curScrollView.contentOffset;
            CGFloat top = curScrollView.contentInset.top;
            self.commonContentView.y = point.y + top > self.commonHeaderView.height ? point.y - self.commonHeaderView.height : -top;
            [curScrollView bringSubviewToFront:self.commonContentView];
            if ([self.delegate respondsToSelector:@selector(selectedViewControllerWithIndex:viewController:)]) {
                [self.delegate selectedViewControllerWithIndex:index viewController:curViewController];
            }
        }
    }
    self.curSelectedIndex = index;
}

- (void)selectViewControllerWithIndex:(NSUInteger)index {
    if (index < self.viewControllers.count && self.curSelectedIndex != index) {
        [self updateHeaderToCurScrollView:index];
    }
}

#pragma mark scrollView delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.horizontalScrollView) {
        CGFloat x = scrollView.contentOffset.x;
        self.commonContentView.x = x > 0 ? x : 0;
        if (self.isEndDraging && (int)scrollView.contentOffset.x % (int)scrollView.width <= 1) {
            NSUInteger newPageIndex = floor((scrollView.contentOffset.x - scrollView.frame.size.width / 2)) / scrollView.frame.size.width + 1;
            [self updateHeaderToCurScrollView:newPageIndex];
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
        y = y < - self.commonHeaderView.height ? -self.commonHeaderView.height : y;
        [self.horizontalScrollView addSubview:self.commonContentView];
        self.commonContentView.y = y;
        self.commonContentView.x = scrollView.contentOffset.x;
        [self.horizontalScrollView bringSubviewToFront:self.commonContentView];
        self.isEndDraging = NO;
    }
}

@end
