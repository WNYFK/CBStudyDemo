//
//  CBDynamicView.m
//  CBStudyDemo
//
//  Created by ChenBin on 16/9/6.
//  Copyright © 2016年 ChenBin. All rights reserved.
//

#import "CBDynamicView.h"

static CGFloat rubberBandRate(CGFloat offset) {
    
    const CGFloat constant = 0.15f;
    const CGFloat dimension = 10.0f;
    const CGFloat startRate = 0.85f;
    // 计算拖动视图translation的增量比率，起始值为startRate（此时offset为0）；随着frame超出的距离offset的增大，增量比率减小
    CGFloat result = dimension * startRate / (dimension + constant * fabs(offset));
    return result;
}

@interface CBDynamicItem : NSObject <UIDynamicItem>

@property (nonatomic, readwrite) CGPoint center;
@property (nonatomic, readonly) CGRect bounds;
@property (nonatomic, readwrite) CGAffineTransform transform;

@end

@interface CBDynamicView ()<UIDynamicAnimatorDelegate>

@property (nonatomic, strong) UIPanGestureRecognizer *panGestureRecognizer;
@property (nonatomic, strong) UIDynamicAnimator *animator;
@property (nonatomic, strong) UIDynamicItemBehavior *decelerationBehavior;
@property (nonatomic, strong) UIAttachmentBehavior *springBehavior;
@property (nonatomic, strong) CBDynamicItem *dynamicItem;
@property (nonatomic, assign) CGRect newFrame;
@property (nonatomic, assign) BOOL tracking;
@property (nonatomic, assign) BOOL dragging;
@property (nonatomic, assign) BOOL decelerating;

@end

static void * CBHeaderViewPanGestureRecognizerStateContext = &CBHeaderViewPanGestureRecognizerStateContext;


@implementation CBDynamicView

- (void)dealloc {
    [self.panGestureRecognizer removeObserver:self forKeyPath:@"state"];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    // pan gesture
    self.panGestureRecognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handlePanGesture:)];
    [self addGestureRecognizer:_panGestureRecognizer];
    [self.panGestureRecognizer addObserver:self forKeyPath:@"state" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:CBHeaderViewPanGestureRecognizerStateContext];
    // animator
    self.animator = [[UIDynamicAnimator alloc]initWithReferenceView:self];
    self.animator.delegate = self;
    self.dynamicItem = [[CBDynamicItem alloc]init];
}

- (void)handlePanGesture:(UIPanGestureRecognizer *)panGestureRecognizer {
    
    switch (panGestureRecognizer.state) {
            // remove animator
        case UIGestureRecognizerStateBegan:
        {
            [self endDecelerating];
            self.tracking = YES;
        }
            // change offset and add RubberBanding effect
        case UIGestureRecognizerStateChanged:
        {
            self.tracking = YES;
            self.dragging = YES;
            CGRect frame  = self.frame;
            CGPoint translation = [panGestureRecognizer translationInView:self.superview];
            CGFloat newFrameOrginY = frame.origin.x + translation.x;
            CGPoint minFrameOrgin  = [self minFrameOrgin];
            CGPoint maxFrameOrgin  = [self maxFrameOrgin];
            
            CGFloat minFrameOrginY = minFrameOrgin.y;
            CGFloat maxFrameOrginY = maxFrameOrgin.y;
            CGFloat constrainedOrignY = fmax(minFrameOrginY, fmin(newFrameOrginY, maxFrameOrginY));
            CGFloat rubberBandedRate  = rubberBandRate(newFrameOrginY - constrainedOrignY);
            
            frame.origin  = CGPointMake(frame.origin.x + translation.y * rubberBandedRate, frame.origin.y);
            self.newFrame = frame;
            
            [panGestureRecognizer setTranslation:CGPointMake(translation.x, 0) inView:self.superview];
        }
            break;
        case UIGestureRecognizerStateEnded:
        {
            self.tracking = NO;
            self.dragging = NO;
            CGPoint velocity = [panGestureRecognizer velocityInView:self];
            // only support vertical
            velocity.y = 0;
            
            self.dynamicItem.center = self.frame.origin;
            self.decelerationBehavior = [[UIDynamicItemBehavior alloc] initWithItems:@[self.dynamicItem]];
            [_decelerationBehavior addLinearVelocity:velocity forItem:self.dynamicItem];
            _decelerationBehavior.resistance = 2;
            
            __weak typeof(self) weakSelf = self;
            _decelerationBehavior.action = ^{
                CGPoint center = weakSelf.dynamicItem.center;
                center.y       = weakSelf.frame.origin.y;
                CGRect frame   = weakSelf.frame;
                frame.origin   = center;
                weakSelf.newFrame = frame;
            };
            
            [self.animator addBehavior:_decelerationBehavior];
        }
            break;
            
        default:
        {
            self.tracking = NO;
            self.dragging = NO;
        }
            break;
    }
    
    if (_delegate && [_delegate respondsToSelector:@selector(headerView:didPan:)]) {
        [_delegate headerView:self didPan:panGestureRecognizer];
    }
}

- (void)setNewFrame:(CGRect)frame {
    [self setFrame:frame];
    
    CGPoint minFrameOrgin = [self minFrameOrgin];
    CGPoint maxFrameOrgin = [self maxFrameOrgin];
    
    BOOL outsideFrameMinimum = frame.origin.y < minFrameOrgin.y;
    BOOL outsideFrameMaximum = frame.origin.y > maxFrameOrgin.y;
    
    if ((outsideFrameMinimum || outsideFrameMaximum) &&
        (_decelerationBehavior && !_springBehavior)) {
        
        CGPoint target = frame.origin;
        if (outsideFrameMinimum) {
            target.x = fmax(target.x, minFrameOrgin.x);
            target.y = 0;
        } else if (outsideFrameMaximum) {
            target.x = fmin(target.x, maxFrameOrgin.x);
            target.y = 0;
        }
        
        self.springBehavior = [[UIAttachmentBehavior alloc] initWithItem:self.dynamicItem attachedToAnchor:target];
        // Has to be equal to zero, because otherwise the frame wouldn't exactly match the target's position.
        _springBehavior.length = 0;
        // These two values were chosen by trial and error.
        _springBehavior.damping = 1;
        _springBehavior.frequency = 2;
        
        [self.animator addBehavior:_springBehavior];
    }
    
    if (_delegate && [_delegate respondsToSelector:@selector(headerViewDidFrameChanged:)]) {
        [_delegate headerViewDidFrameChanged:self];
    }
}

- (CGPoint)minFrameOrgin {
    CGPoint orgin = CGPointMake(0, 0);
    if (_delegate && [_delegate respondsToSelector:@selector(minHeaderViewFrameOrgin)]) {
        orgin = [_delegate minHeaderViewFrameOrgin];
    }
    return orgin;
}

- (CGPoint)maxFrameOrgin {
    CGPoint orgin = CGPointMake(0, 0);
    if (_delegate && [_delegate respondsToSelector:@selector(maxHeaderViewFrameOrgin)]) {
        orgin = [_delegate maxHeaderViewFrameOrgin];
    }
    return orgin;
}

- (void)endDecelerating {
    [self.animator removeAllBehaviors];
    [self setDecelerationBehavior:nil];
    [self setSpringBehavior:nil];
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView * view = [super hitTest:point withEvent:event];
    // tap outside of the header view
    if (!CGRectContainsPoint(self.bounds, point)) {
        [self endDecelerating];
    }
    // tap inside of the header view
    else {
        // return self to response this event,when the header is decelerating.
        if (self.decelerating) {
            return self;
        }
    }
    return view;
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if (context == CBHeaderViewPanGestureRecognizerStateContext) {
        if (_delegate && [_delegate respondsToSelector:@selector(headerView:didPanGestureRecognizerStateChanged:)]) {
            [_delegate headerView:self didPanGestureRecognizerStateChanged:object];
        }
    }
}

#pragma mark - UIDynamicAnimatorDelegate

- (void)dynamicAnimatorWillResume:(UIDynamicAnimator *)animator {
    self.decelerating = YES;
}

- (void)dynamicAnimatorDidPause:(UIDynamicAnimator *)animator {
    self.decelerating = NO;
}

@end


