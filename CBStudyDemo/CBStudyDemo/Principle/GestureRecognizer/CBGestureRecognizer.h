//
//  CBGestureRecognizer.h
//  CBStudyDemo
//
//  Created by chenbin on 16/9/4.
//  Copyright © 2016年 ChenBin. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, CBGestureRecognizerType) {
    CBGestureRecognizerTypeNone,
    CBGestureRecognizerTypeTap,
    CBGestureRecognizerTypeSwipToRight,
    CBGestureRecognizerTypeSwipToLeft,
    CBGestureRecognizerTypeSwipToUp,
    CBGestureRecognizerTypeSwipToDown,
    CBGestureRecognizerTypeSwipToOtherDirection
};

@interface CBGestureRecognizer : UIGestureRecognizer

@property(nonatomic, assign, readonly) CBGestureRecognizerType gestureRecognizerType;

@end
