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

@property (nonatomic, strong) UIScrollView *dynamicView;
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
    
    self.dynamicView = [[UIScrollView alloc] initWithFrame:CGRectMake(self.leftContentView.right, 0, [UIScreen mainScreen].bounds.size.width - self.leftContentView.width, self.leftContentView.height)];
    self.dynamicView.showsHorizontalScrollIndicator = NO;
    self.dynamicView.contentSize = CGSizeMake(600, 0);
    
    UILongPressGestureRecognizer *longPressGessture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    [self.dynamicView addGestureRecognizer:longPressGessture];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHandle:)];
    [self.dynamicView addGestureRecognizer:tap];
    for (int i = 0; i < 5; i++) {
        UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(i * 100 + (i == 0 ? 0 : 20), 0, 100, self.dynamicView.height)];
        titleLab.text = [NSString stringWithFormat:@"啊啊aaaaaa：%d",i];
        [self.dynamicView addSubview:titleLab];
    }
    [self.contentView addSubview:self.dynamicView];
    [self.contentView addSubview:self.leftContentView];
    
}

- (void)tapHandle:(UITapGestureRecognizer *)tapGesture {
    NSLog(@"点击啊");
}

- (void)longPress:(UILongPressGestureRecognizer *)longPressGesture {
    NSLog(@"长按");
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *view = [super hitTest:point withEvent:event];
    NSLog(@"%ld",(long)event.type);
    if (view == self.dynamicView) {
        return nil;
    }
    return self;
}

@end
