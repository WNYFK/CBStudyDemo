//
//  UIButton+Create.h
//  CBStudyDemo
//
//  Created by ChenBin on 16/9/9.
//  Copyright © 2016年 ChenBin. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CBButtonClickCallBackBlock)(UIButton *button);

@interface UIButton (Create)

+ (instancetype)createButtonWithTitle:(NSString *)title frame:(CGRect)frame callBack:(CBButtonClickCallBackBlock)callBack;

@end
