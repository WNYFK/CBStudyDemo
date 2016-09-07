//
//  CBHorizontalView.h
//  CBStudyDemo
//
//  Created by ChenBin on 16/9/6.
//  Copyright © 2016年 ChenBin. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CBHorizontalScrollDelegate <NSObject>

- (CGPoint)minDynamicViewPosition;
- (CGPoint)maxDynamicViewPosition;

@optional
- (void)dynamicViewPositionChanged:(UIView *)dynamicView;

@end

@interface CBHorizontalSwipView : UIView

@property (nonatomic, strong, readonly) UIPanGestureRecognizer *horizontalPanGestureRecognizer;
@property (nonatomic, weak) id<CBHorizontalScrollDelegate> delegate;

@end
