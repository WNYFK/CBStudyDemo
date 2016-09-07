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

@property (nonatomic, strong) UIPanGestureRecognizer *horizontalPanGestureRecognizer;
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
    self.horizontalPanGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    [self addGestureRecognizer:self.horizontalPanGestureRecognizer];
    
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self];
    self.animator.delegate = self;
    self.dynamicItem = [[CBDynamicItem alloc] init];
}

- (void)handlePanGesture:(UIPanGestureRecognizer *)panGesture {
    NSLog(@"PanGesture");
    switch (panGesture.state) {
        case UIGestureRecognizerStateBegan:
            [self.animator removeAllBehaviors];
            break;
            
        case UIGestureRecognizerStateChanged:
            
            break;
            
        case UIGestureRecognizerStateEnded:
            
            break;
            
        case UIGestureRecognizerStatePossible:
            
            break;
            
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
