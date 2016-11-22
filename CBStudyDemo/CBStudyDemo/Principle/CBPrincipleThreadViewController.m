//
//  CBPrincipleThreadViewController.m
//  CBStudyDemo
//
//  Created by ChenBin on 2016/11/15.
//  Copyright © 2016年 ChenBin. All rights reserved.
//

#import "CBPrincipleThreadViewController.h"

@interface CBPrincipleThreadViewController ()

@end

@implementation CBPrincipleThreadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 30)];
    textField.borderStyle = UITextBorderStyleRoundedRect;
    [self.view addSubview:textField];
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, textField.bottom, self.view.width, 200)];
    scrollView.backgroundColor = [UIColor yellowColor];
    scrollView.alwaysBounceVertical = YES;
    scrollView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [self.view addSubview:scrollView];
}

@end
