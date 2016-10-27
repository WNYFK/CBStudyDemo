//
//  CBMasonryViewController.m
//  CBStudyDemo
//
//  Created by ChenBin on 2016/10/27.
//  Copyright © 2016年 ChenBin. All rights reserved.
//

#import "CBMasonryViewController.h"

@interface CBMasonryViewController ()

@property (strong, nonatomic) UILabel *leftLabel;
@property (strong, nonatomic) UILabel *rightLabel;

@end

@implementation CBMasonryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem *leftAddBtnItem = [UIBarButtonItem creatBarButtonWithTitle:@"左加" callBack:^(UIBarButtonItem *buttonItem) {
        self.leftLabel.text = [NSString stringWithFormat:@"asdf%@",self.leftLabel.text];
    }];
    
    UIBarButtonItem *rightAddBtnItem = [UIBarButtonItem creatBarButtonWithTitle:@"右加" callBack:^(UIBarButtonItem *buttonItem) {
        self.rightLabel.text = [NSString stringWithFormat:@"左安安%@",self.rightLabel.text];
    }];
    self.navigationItem.rightBarButtonItems = @[leftAddBtnItem, rightAddBtnItem];
    
    self.leftLabel = [[UILabel alloc] init];
    self.leftLabel.numberOfLines = 0;
    self.leftLabel.text = @"左左左左";
    [self.view addSubview:self.leftLabel];
    
    self.rightLabel = [[UILabel alloc] init];
    self.rightLabel.numberOfLines = 0;
    self.rightLabel.text = @"asdfasdfasdfasdfsafasdfsadfasdf右有有有";
    [self.view addSubview:self.rightLabel];
    
    UIView *bottomView = [[UIView alloc] init];
    bottomView.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:bottomView];
    
    [self.leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@10);
        make.top.equalTo(@30);
        make.width.equalTo(@200);
    }];
    
    [self.rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.leftLabel.mas_right).offset(20);
        make.top.equalTo(self.leftLabel);
        make.right.equalTo(@(-20));
    }];
    
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@10);
        make.right.equalTo(@10);
        make.height.equalTo(@100);
        make.top.greaterThanOrEqualTo(self.leftLabel.mas_bottom).offset(10);
        make.top.greaterThanOrEqualTo(self.rightLabel.mas_bottom).offset(20);
    }];
    
}

@end
