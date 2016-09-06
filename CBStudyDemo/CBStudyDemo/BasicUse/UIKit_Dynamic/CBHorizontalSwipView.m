//
//  CBHorizontalView.m
//  CBStudyDemo
//
//  Created by ChenBin on 16/9/6.
//  Copyright © 2016年 ChenBin. All rights reserved.
//

#import "CBHorizontalSwipView.h"
#import "CBDynamicItem.h"

@interface CBHorizontalSwipView ()<UIDynamicAnimatorDelegate>

@property (nonatomic, strong) UISwipeGestureRecognizer *horizontalSwipGestureRecognizer;
@property (nonatomic, strong) UIDynamicAnimator *animator;
@property (nonatomic, strong) UIPushBehavior *pushBehavior;
@property (nonatomic, strong) UIDynamicItemBehavior *decelerationBehavior;
@property (nonatomic, strong) CBDynamicItem *dynamicItem;
@property (nonatomic, assign) CGRect newFrame;

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
    self.animator.delegate = self;
    self.dynamicItem = [[CBDynamicItem alloc] init];
}

- (void)handleSwipGesture:(UISwipeGestureRecognizer *)swipGesture {
    CGPoint point1 = [swipGesture locationInView:self];
    NSLog(@"啊啊啊啊:%f",point1.x);

    switch (swipGesture.state) {
        case UIGestureRecognizerStateBegan: {
            [self endDecelerating];
        }
        case UIGestureRecognizerStateChanged: {
            CGRect frame = self.frame;
            CGPoint minPosition = [self minDynamicViewPosition];
            CGPoint maxPosition = [self maxDynamicViewPosition];
            
        }
        case UIGestureRecognizerStateEnded: {
            CGPoint point = [swipGesture locationInView:self];
            point.y = 0;
            self.dynamicItem.center = self.frame.origin;
            self.decelerationBehavior = [[UIDynamicItemBehavior alloc] initWithItems:@[self.dynamicItem]];
            [self.decelerationBehavior addLinearVelocity:point forItem:self.dynamicItem];
            self.decelerationBehavior.resistance = 2;
            __weak typeof(self) weakSelf = self;
            self.decelerationBehavior.action = ^{
                CGPoint center = weakSelf.dynamicItem.center;
                center.y = weakSelf.frame.origin.y;
                CGRect frame = weakSelf.frame;
                frame.origin = center;
                weakSelf.newFrame = frame;
            };
            
            [self.animator addBehavior:self.decelerationBehavior];
        }
        default:
            break;
    }
}

- (void)setNewFrame:(CGRect)newFrame {
    self.frame = newFrame;
    CGPoint minPosition = [self minDynamicViewPosition];
    CGPoint maxPosition = [self maxDynamicViewPosition];
    
    BOOL outsideFrameMinPoint = newFrame.origin.x < minPosition.x;
    BOOL outsideFrameMaxPoint = newFrame.origin.x > maxPosition.x;
    
    if ((outsideFrameMinPoint || outsideFrameMaxPoint) && self.decelerationBehavior) {
        
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(dynamicViewPositionChanged:)]) {
        [self.delegate dynamicViewPositionChanged:self];
    }
    
}

- (void)endDecelerating {
    [self.animator removeAllBehaviors];
    self.decelerationBehavior = nil;
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

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
}

@end
