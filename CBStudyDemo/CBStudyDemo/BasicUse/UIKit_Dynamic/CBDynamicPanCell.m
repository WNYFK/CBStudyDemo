//
//  CBDynamicPanCell.m
//  CBStudyDemo
//
//  Created by ChenBin on 16/9/7.
//  Copyright © 2016年 ChenBin. All rights reserved.
//

#import "CBDynamicPanCell.h"
#import "CBHorizontalSwipView.h"

@interface CBDynamicPanCell ()

@property (nonatomic, strong) CBHorizontalSwipView *dynamicView;

@end
@implementation CBDynamicPanCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupSubView];
    }
    return self;
}

- (void)setupSubView {
    self.dynamicView = [[CBHorizontalSwipView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 60)];
    [self.contentView addSubview:self.dynamicView];
}

@end
