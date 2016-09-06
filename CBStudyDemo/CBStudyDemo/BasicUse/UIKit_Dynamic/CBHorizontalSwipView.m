//
//  CBHorizontalView.m
//  CBStudyDemo
//
//  Created by ChenBin on 16/9/6.
//  Copyright © 2016年 ChenBin. All rights reserved.
//

#import "CBHorizontalSwipView.h"
#import "CBDynamicItem.h"

@interface CBHorizontalSwipView ()

@property (nonatomic, strong) UISwipeGestureRecognizer *horizontalSwipGestureRecognizer;
@property (nonatomic, strong) UIDynamicAnimator *animator;
@property (nonatomic, strong) UIPushBehavior *pushBehavior;
@property (nonatomic, strong) UIDynamicItemBehavior *decelerationBehavior;
@property (nonatomic, strong) CBDynamicItem *dynamicItem;

@end

@implementation CBHorizontalSwipView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    self.horizontalSwipGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipGesture:)];
    self.horizontalSwipGestureRecognizer.direction = UISwipeGestureRecognizerDirectionLeft | UISwipeGestureRecognizerDirectionRight;
    [self addGestureRecognizer:self.horizontalSwipGestureRecognizer];
    
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self];
//    self.animator.delegate = self;
    self.dynamicItem = [[CBDynamicItem alloc] init];
}

- (void)handleSwipGesture:(UISwipeGestureRecognizer *)swipGesture {
    NSLog(@"左右滑动啊");
}

- (CGPoint)minDynamicViewPosition {
    CGPoint origin = CGPointZero;
    if (self.delegate && [self.delegate respondsToSelector:@selector(minDynamicViewPosition)]) {
        origin = [self.delegate minDynamicViewPosition];
    }
    return origin;
}

- (CGPoint)maxDynamicViewPosition {
    CGPoint origin = CGPointZero;
    if (self.delegate && [self.delegate respondsToSelector:@selector(maxDynamicViewPosition)]) {
        origin = [self.delegate maxDynamicViewPosition];
    }
    return origin;
}

@end
