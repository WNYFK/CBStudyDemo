//
//  UIBarButtonItem+Create.m
//  CBStudyDemo
//
//  Created by ChenBin on 16/9/9.
//  Copyright © 2016年 ChenBin. All rights reserved.
//

#import "UIBarButtonItem+Create.h"
#import <objc/runtime.h>

@interface UIBarButtonItem ()

@property (nonatomic, copy) CBBarButtonItemClickCallBackBlock callBack;

@end

@implementation UIBarButtonItem (Create)

+ (instancetype)creatBarButtonWithTitle:(NSString *)title callBack:(CBBarButtonItemClickCallBackBlock)callback {
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:self action:@selector(barButtonClicked:)];
    barButtonItem.callBack = [callback copy];
    return barButtonItem;
}

+ (void)barButtonClicked:(UIBarButtonItem *)barButton {
    if (barButton.callBack) {
        barButton.callBack(barButton);
    }
}

- (void)setCallBack:(CBBarButtonItemClickCallBackBlock)callBack {
    objc_setAssociatedObject(self, @selector(callBack), callBack, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (CBBarButtonItemClickCallBackBlock )callBack {
    return objc_getAssociatedObject(self, @selector(callBack));
}

@end
