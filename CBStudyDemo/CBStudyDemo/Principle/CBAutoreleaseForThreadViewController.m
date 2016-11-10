//
//  CBAutoreleaseForThreadViewController.m
//  CBStudyDemo
//
//  Created by ChenBin on 2016/11/9.
//  Copyright © 2016年 ChenBin. All rights reserved.
//

#import "CBAutoreleaseForThreadViewController.h"

@interface CBAutoreleaseThreadTest : NSObject

@property (nonatomic, strong) NSString *title;

+ (instancetype)threadTestObject;

@end

@interface CBAutoreleaseForThreadViewController ()

@property (nonatomic, weak) CBAutoreleaseThreadTest *threadTestObj1;
@property (nonatomic, strong) CBAutoreleaseThreadTest *threadTestObj2;

@end

@implementation CBAutoreleaseForThreadViewController

- (void)dealloc {
    NSLog(@"%@", self.threadTestObj2.title);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    @weakify(self);
    UIButton *startTestBtn = [UIButton createButtonWithTitle:@"thread autorelease" frame:CGRectMake(10, 100, 100, 50) callBack:^(UIButton *button) {
        @strongify(self);
        [NSThread detachNewThreadSelector:@selector(threadTestMethod) toTarget:self withObject:nil];
    }];
    [self.view addSubview:startTestBtn];
    
    UIButton *logBtn = [UIButton createButtonWithTitle:@"logout" frame:CGRectMake(startTestBtn.right + 10, startTestBtn.top, 100, 50) callBack:^(UIButton *button) {
        @strongify(self);
        NSLog(@"title1: %@",self.threadTestObj1.title);
        NSLog(@"title2: %@", self.threadTestObj2.title);
    }];
    [self.view addSubview:logBtn];
}

- (void)threadTestMethod {
    self.threadTestObj1 = [CBAutoreleaseThreadTest threadTestObject];
    CBAutoreleaseThreadTest *tmpObj2 = [[CBAutoreleaseThreadTest alloc] init];
    tmpObj2.title = @"ThreadAutorelease2";
    self.threadTestObj2 = tmpObj2;
    NSLog(@"title1: %@", self.threadTestObj1.title);
    NSLog(@"title2: %@", self.threadTestObj2.title);
    dispatch_async(dispatch_get_main_queue(), ^{
        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(100, 200, 100, 30)];
        lab.text = @"asdfasdfasdf";
        [self.view addSubview:lab];
    });
}


@end


@implementation CBAutoreleaseThreadTest

- (void)dealloc {
    NSLog(@"%@",self.title);
}

+ (instancetype)threadTestObject {
    CBAutoreleaseThreadTest *testObj = [[self alloc] init];
    testObj.title = @"threadTestObject";
    return testObj;
}


@end
