//
//  CBDynamicCell.m
//  CBStudyDemo
//
//  Created by ChenBin on 16/9/6.
//  Copyright © 2016年 ChenBin. All rights reserved.
//

#import "CBDynamicCell.h"
#import "CBDynamicView.h"
#import "CBHorizontalSwipView.h"

@interface CBDynamicCell ()

@property (nonatomic, strong) CBHorizontalSwipView *dynamicView;
@property (nonatomic, strong) UIView *leftContentView;
@property (nonatomic, strong) UILabel *firstColumnLab;

@end

@implementation CBDynamicCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupSubView];
    }
    return self;
}

- (void)setRow:(NSInteger)row {
    self.firstColumnLab.text = [NSString stringWithFormat:@"第一个:%ld",(long)row];
}

- (void)setupSubView {
    self.leftContentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 60)];
    self.leftContentView.backgroundColor = [UIColor whiteColor];
    
    self.firstColumnLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.leftContentView.width, self.leftContentView.height)];
    self.firstColumnLab.textColor = [UIColor blackColor];
    [self.leftContentView addSubview:self.firstColumnLab];
    
    self.dynamicView = [[CBHorizontalSwipView alloc] initWithFrame:CGRectMake(self.leftContentView.right, 0, 700, self.leftContentView.height)];
    for (int i = 0; i < 5; i++) {
        UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(i * 100 + (i == 0 ? 0 : 20), 0, 100, self.dynamicView.height)];
        titleLab.text = [NSString stringWithFormat:@"啊啊aaaaaa：%d",i];
        [self.dynamicView addSubview:titleLab];
    }
    [self.contentView addSubview:self.dynamicView];
    [self.contentView addSubview:self.leftContentView];
    
}

@end
