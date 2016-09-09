//
//  UIBarButtonItem+Create.h
//  CBStudyDemo
//
//  Created by ChenBin on 16/9/9.
//  Copyright © 2016年 ChenBin. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CBBarButtonItemClickCallBackBlock)(UIBarButtonItem *buttonItem);

@interface UIBarButtonItem (Create)

+ (instancetype)creatBarButtonWithTitle:(NSString *)title callBack:(CBBarButtonItemClickCallBackBlock)callback;


@end
