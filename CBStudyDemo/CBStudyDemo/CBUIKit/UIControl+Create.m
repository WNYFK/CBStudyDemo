//
//  UIControl+Create.m
//  CBStudyDemo
//
//  Created by ChenBin on 16/9/9.
//  Copyright © 2016年 ChenBin. All rights reserved.
//

#import "UIControl+Create.h"

@interface UIControl ()

@property (nonatomic, copy) CBControlClickCallBackBlock callBack;

@end

@implementation UIControl (Create)

+ (instancetype)createControlWithCallBack:(CBControlClickCallBackBlock)callBack {
    UIControl *control = [[UIControl alloc] init];
    control.callBack = callBack;
    [control addTarget:self action:@selector(controlTaget:) forControlEvents:UIControlEventTouchUpInside];
    return control;
}

+ (void)controlTaget:(UIControl *)control {
    if (control.callBack) {
        control.callBack(control);
    }
}

- (void)setCallBack:(CBControlClickCallBackBlock)callBack {
    objc_setAssociatedObject(self, @selector(callBack), callBack, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (CBControlClickCallBackBlock)callBack {
    return objc_getAssociatedObject(self, @selector(callBack));
}

@end
