//
//  CBGestureScrollView.m
//  CBStudyDemo
//
//  Created by chenbin on 16/9/5.
//  Copyright © 2016年 ChenBin. All rights reserved.
//

#import "CBGestureScrollView.h"
#import <UIKit/UIGestureRecognizerSubclass.h>

@interface CBGestureScrollView ()<UIGestureRecognizerDelegate, UIScrollViewDelegate>

@end

@implementation CBGestureScrollView

- (void)didMoveToSuperview {
    self.panGestureRecognizer.delegate = self;
    self.delegate = self;
}

#pragma mark uiscrollview delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    NSLog(@"%s",__FUNCTION__);
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    NSLog(@"%s",__FUNCTION__);
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    NSLog(@"%s",__FUNCTION__);
}
#pragma mark UIGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    NSLog(@"%s",__FUNCTION__);
    return [super gestureRecognizerShouldBegin:gestureRecognizer];
//    return NO;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceivePress:(UIPress *)press {
    NSLog(@"%s",__FUNCTION__);
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRequireFailureOfGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    NSLog(@"%s",__FUNCTION__);
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    NSLog(@"%s",__FUNCTION__);
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    NSLog(@"%s",__FUNCTION__);
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    NSLog(@"%s",__FUNCTION__);
    return YES;
}

#pragma mark touch

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSLog(@"%s",__FUNCTION__);
    [super touchesBegan:touches withEvent:event];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSLog(@"%s",__FUNCTION__);
    [super touchesMoved:touches withEvent:event];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSLog(@"%s",__FUNCTION__);
    [super touchesEnded:touches withEvent:event];
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSLog(@"%s",__FUNCTION__);
    [super touchesCancelled:touches withEvent:event];
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    NSLog(@"%s", __FUNCTION__);
    return [super hitTest:point withEvent:event];
}


@end
