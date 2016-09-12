//
//  UIButton+Create.m
//  CBStudyDemo
//
//  Created by ChenBin on 16/9/9.
//  Copyright © 2016年 ChenBin. All rights reserved.
//

#import "UIButton+Create.h"

@interface UIButton ()

@property (nonatomic, copy) CBButtonClickCallBackBlock callBack;

@end

@implementation UIButton (Create)

+ (instancetype)createButtonWithTitle:(NSString *)title frame:(CGRect)frame callBack:(CBButtonClickCallBackBlock)callBack {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn.frame = frame;
    [btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    btn.callBack = callBack;
    return btn;
}

+ (void)btnClicked:(UIButton *)btn {
    if (btn.callBack) {
        btn.callBack(btn);
    }
}

- (void)setCallBack:(CBButtonClickCallBackBlock)callBack {
    objc_setAssociatedObject(self, @selector(callBack), callBack, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (CBButtonClickCallBackBlock)callBack {
    return objc_getAssociatedObject(self, @selector(callBack));
}

@end
