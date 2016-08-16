//
//  CBKVORealizeViewController.m
//  CBStudyDemo
//
//  Created by ChenBin on 16/8/16.
//  Copyright © 2016年 ChenBin. All rights reserved.
//

#import "CBKVORealizeViewController.h"
#import "CBKVOTestClassOne.h"
#import <objc/runtime.h>
#import "NSObject+KVO.h"

@interface CBKVORealizeViewController ()

@property (nonatomic, strong) CBKVOTestClassOne *x;
@property (nonatomic, strong) CBKVOTestClassOne *control;

@end

@implementation CBKVORealizeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *systemRealizeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    systemRealizeBtn.frame = CGRectMake(50, 100, 100, 50);
    [systemRealizeBtn setTitle:@"查看KVO" forState:UIControlStateNormal];
    [self.view addSubview:systemRealizeBtn];
    [systemRealizeBtn addTarget:self action:@selector(seeKVORealize) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton *realizeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    realizeBtn.frame = CGRectMake(50, 200, 150, 50);
    [realizeBtn setTitle:@"自己实现KVO" forState:UIControlStateNormal];
    [self.view addSubview:realizeBtn];
    [realizeBtn addTarget:self action:@selector(realiseBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *changeValueBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    changeValueBtn.frame = CGRectMake(50, 300, 150, 50);
    [changeValueBtn setTitle:@"改变值" forState:UIControlStateNormal];
    [self.view addSubview:changeValueBtn];
    [changeValueBtn addTarget:self action:@selector(changeValueBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    
    self.x = [[CBKVOTestClassOne alloc] init];
    self.control = [[CBKVOTestClassOne alloc] init];
    self.control.str = @"asdfa";
}

- (void)changeValueBtnClicked {
    self.x.x += 1;
    self.control.str = [self.control.str stringByAppendingString:@"12"];
    self.control.x += 1;
    
    [self.control setValue:[self.control.str stringByAppendingString:@"123"] forKey:@"str"];
}

- (void)realiseBtnClicked {
    NSLog(@"=================:%s", __FUNCTION__);
    
    PrintDescription(@"x", self.control);
    
    [self.control CB_addObserver:self.control forKey:@"x" withBlock:^(id  _Nonnull observedObject, NSString * _Nonnull observedKey, id  _Nonnull oldValue, id  _Nonnull newValue) {
        NSLog(@"observer: %@\n observerKey: %@ \n oldValue: %@ \n newValue: %@", observedObject, observedKey, oldValue, newValue);
    }];
    [self.control CB_addObserver:self.control forKey:@"str" withBlock:^(id  _Nonnull observedObject, NSString * _Nonnull observedKey, id  _Nonnull oldValue, id  _Nonnull newValue) {
        NSLog(@"observer: %@\n observerKey: %@ \n oldValue: %@ \n newValue: %@", observedObject, observedKey, oldValue, newValue);
    }];
    PrintDescription(@"x", self.control);
    NSLog(@"Using NSObject methods, normal setX: is  %p, overridden setX: is %p\n",[self.control methodForSelector:@selector(setX:)], method_getImplementation(class_getInstanceMethod(class_getSuperclass(object_getClass(self.x)), @selector(setX:))));
    NSLog(@"Using libobjc functions, normal setX: is %p, overridden setX: is %p\n", method_getImplementation(class_getInstanceMethod(object_getClass(self.control), @selector(setX:))), method_getImplementation(class_getInstanceMethod(object_getClass(self.x), @selector(setX:))));
    
    NSLog(@"===============:%s", __FUNCTION__);
}

- (void)seeKVORealize {
    
    NSLog(@"\n=========================\n");
    PrintDescription(@"x", self.x);
    NSLog(@"\n=========================\n");
    [self.x addObserver:self.x forKeyPath:@"x" options:NSKeyValueObservingOptionNew context:NULL];
    PrintDescription(@"x", self.x);
    
    NSLog(@"Using NSObject methods, normal setX: is  %p, overridden setX: is %p\n",[self.control methodForSelector:@selector(setX:)], method_getImplementation(class_getInstanceMethod(class_getSuperclass(object_getClass(self.x)), @selector(setX:))));
    NSLog(@"Using libobjc functions, normal setX: is %p, overridden setX: is %p\n", method_getImplementation(class_getInstanceMethod(object_getClass(self.control), @selector(setX:))), method_getImplementation(class_getInstanceMethod(object_getClass(self.x), @selector(setX:))));
}

@end













