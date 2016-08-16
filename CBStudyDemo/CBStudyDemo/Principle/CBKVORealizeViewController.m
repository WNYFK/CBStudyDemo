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


static NSArray *ClassMethodNames(Class c)
{
    NSMutableArray *array = [NSMutableArray array];
    
    unsigned int methodCount = 0;
    Method *methodList = class_copyMethodList(c, &methodCount);
    unsigned int i;
    for(i = 0; i < methodCount; i++)
        [array addObject: NSStringFromSelector(method_getName(methodList[i]))];
    free(methodList);
    
    return array;
}

static void PrintDescription(NSString *name, id obj) {
    
    NSString *str = [NSString stringWithFormat:@"%@: %@ \n\tNSObject class %s\n\t libobjc class %@\n\t implements methods <%@>", name,
                     obj,
                     class_getName([obj class]),
                     object_getClass(obj),
                     [ClassMethodNames([obj class]) componentsJoinedByString:@", "]
                     ];
    
    printf("%s\n", [str UTF8String]);
}

@interface CBKVORealizeViewController ()

@property (nonatomic, strong) CBKVOTestClassOne *x;
@property (nonatomic, strong) CBKVOTestClassOne *control;

@end

@implementation CBKVORealizeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *printRealizeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    printRealizeBtn.frame = CGRectMake(50, 100, 100, 50);
    [printRealizeBtn setTitle:@"查看KVO" forState:UIControlStateNormal];
    [self.view addSubview:printRealizeBtn];
    [printRealizeBtn addTarget:self action:@selector(seeKVORealize) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)seeKVORealize {
    self.x = [[CBKVOTestClassOne alloc] init];
    self.control = [[CBKVOTestClassOne alloc] init];
    
    NSLog(@"\n=========================\n");
    PrintDescription(@"x", self.x);
    NSLog(@"\n=========================\n");
    [self.x addObserver:self.x forKeyPath:@"x" options:NSKeyValueObservingOptionNew context:NULL];
    PrintDescription(@"x", self.x);
    
    NSLog(@"Using NSObject methods, normal setX: is  %p, overridden setX: is %p\n",[self.control methodForSelector:@selector(setX:)], method_getImplementation(class_getInstanceMethod(class_getSuperclass(object_getClass(self.x)), @selector(setX:))));
    NSLog(@"Using libobjc functions, normal setX: is %p, overridden setX: is %p\n", method_getImplementation(class_getInstanceMethod(object_getClass(self.control), @selector(setX:))), method_getImplementation(class_getInstanceMethod(object_getClass(self.x), @selector(setX:))));
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    
}

@end













