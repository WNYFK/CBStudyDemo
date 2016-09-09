//
//  UIControl+Create.h
//  CBStudyDemo
//
//  Created by ChenBin on 16/9/9.
//  Copyright © 2016年 ChenBin. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CBControlClickCallBackBlock)(UIControl *control);

@interface UIControl (Create)

+ (instancetype)createControlWithCallBack:(CBControlClickCallBackBlock)callBack;

@end
