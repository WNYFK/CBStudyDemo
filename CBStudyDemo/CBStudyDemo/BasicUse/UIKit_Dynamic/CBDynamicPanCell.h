//
//  CBDynamicPanCell.h
//  CBStudyDemo
//
//  Created by ChenBin on 16/9/7.
//  Copyright © 2016年 ChenBin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CBHorizontalSwipView;

@interface CBDynamicPanCell : UITableViewCell

@property (nonatomic, strong, readonly) CBHorizontalSwipView *dynamicView;

@end
