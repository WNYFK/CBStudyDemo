//
//  CBDynamicView.h
//  CBStudyDemo
//
//  Created by ChenBin on 16/9/6.
//  Copyright © 2016年 ChenBin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CBDynamicView;
@protocol CBHeaderViewDelegate <NSObject>

- (CGPoint)minHeaderViewFrameOrgin;
- (CGPoint)maxHeaderViewFrameOrgin;

@optional
- (void)headerViewDidFrameChanged:(CBDynamicView *)headerView;
- (void)headerView:(CBDynamicView *)headerView didPan:(UIPanGestureRecognizer *)pan;
- (void)headerView:(CBDynamicView *)headerView didPanGestureRecognizerStateChanged:(UIPanGestureRecognizer *)pan;

@end

@interface CBDynamicView : UIView

@property (nonatomic, weak) id<CBHeaderViewDelegate> delegate;

@end
