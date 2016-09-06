//
//  CBDynamicCell.h
//  CBStudyDemo
//
//  Created by ChenBin on 16/9/6.
//  Copyright © 2016年 ChenBin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CBDynamicView;
@class CBHorizontalSwipView;

@interface CBDynamicCell : UITableViewCell

@property (nonatomic, assign) NSInteger row;
@property (nonatomic, strong, readonly) CBHorizontalSwipView *dynamicView;

@end
