//
//  CBGestureRecognizer.m
//  CBStudyDemo
//
//  Created by chenbin on 16/9/4.
//  Copyright © 2016年 ChenBin. All rights reserved.
//

#import "CBGestureRecognizer.h"
#import <UIKit/UIGestureRecognizerSubclass.h>
#import "CBGestureScrollView.h"

@interface CBGestureRecognizer ()

@property(nonatomic, assign) UIGestureRecognizerState state;
@property(nonatomic, assign) CBGestureRecognizerType gestureRecognizerType;

@end

@implementation CBGestureRecognizer
@synthesize state = _state;

- (instancetype)initWithTarget:(id)target action:(SEL)action
{
    if (self = [super initWithTarget:target action:action]) {
        [self commonInitialization];
    }
    return self;
}

- (void)awakeFromNib
{
    [self commonInitialization];
}

- (void)reset
{
    self.state = UIGestureRecognizerStatePossible;
}

- (void)commonInitialization
{
    self.cancelsTouchesInView = NO;
    self.delaysTouchesBegan = YES;
    
    self.state = UIGestureRecognizerStatePossible;
}

- (void)setState:(UIGestureRecognizerState)state
{
    [super setState:state];
    
    if (state == UIGestureRecognizerStateFailed)
        [self setEnableOtherGestureRecognizers:NO];
    else
        [self setEnableOtherGestureRecognizers:YES];
}

- (void)setEnableOtherGestureRecognizers:(BOOL)enabled
{
    if (self.view == nil)
        return;
    
    for (UIGestureRecognizer* recognizer in self.view.gestureRecognizers)
    {
        if (recognizer == self) continue;
        recognizer.enabled = enabled;
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    
    self.state = UIGestureRecognizerStatePossible;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    
    self.state = UIGestureRecognizerStateEnded;
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesCancelled:touches withEvent:event];
    self.state = UIGestureRecognizerStateCancelled;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];
    if (self.state != UIGestureRecognizerStatePossible) return;
    
    UITouch *touch = [touches anyObject];
    if (touch == nil) return;
    
    CGPoint location = [touch locationInView:self.view];
    CGPoint prevLocation = [touch previousLocationInView:self.view];
    NSLog(@"diffX:%f====diffY:%f",location.x - prevLocation.x, location.y - prevLocation.y);
    
    UIGestureRecognizerState newState = UIGestureRecognizerStatePossible;
    CBGestureScrollView *listView = (CBGestureScrollView *)self.view;
    
//    switch (self.type) {
//            
//        case MAYHorizontalListViewScrollRecognizerTypeFailedTouchingEdge: {
//            if (listView.contentOffset.x <= 0 && location.x > prevLocation.x) {
//                newState = UIGestureRecognizerStateFailed;
//            } else if (listView.contentOffset.x >= listView.contentSize.width - listView.width && (location.x < prevLocation.x)) {
//                newState = UIGestureRecognizerStateFailed;
//            }
//            break;
//        }
//        case MAYHorizontalListViewScrollRecognizerTypeAlwaysPossible:
//        default:
//            break;
//    }
    self.state = newState;
}

@end
