//
//  CBRACViewController.m
//  CBStudyDemo
//
//  Created by chenbin on 16/9/3.
//  Copyright © 2016年 ChenBin. All rights reserved.
//

#import "CBRACViewController.h"

@interface CBRACViewController ()

@property (nonatomic, strong) UIViewController *viewController;

@end

@implementation CBRACViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton* (^createBtn)(NSString *title, SEL btnClickedSEL) = ^UIButton*(NSString *title, SEL btnClickedSEL) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(100, 30, 100, 50);
        [btn setTitle:title forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn addTarget:self action:btnClickedSEL forControlEvents:UIControlEventTouchUpInside];
        return btn;
    };
    
    UIButton *btn1 = createBtn(@"btn1", @selector(btnClicked:));
    btn1.tag = 1;
    btn1.frame = CGRectMake(10, 30, 100, 50);
    [self.view addSubview:btn1];
    
    UIButton *btn2 = createBtn(@"btn2", @selector(btn2Clicked:));
    btn2.tag = 2;
    btn2.frame = CGRectMake(10, btn1.bottom + 20, 100, 50);
    [self.view addSubview:btn2];
    
    UIButton *btn3 = createBtn(@"btn3", @selector(btn3Clicked:));
    btn3.tag = 3;
    btn3.frame = CGRectMake(10, btn2.bottom + 20, 100, 50);
    [self.view addSubview:btn3];
    
    //btn2 的执行必须等到btn1执行过一次才可执行
    [[[[[self rac_signalForSelector:@selector(btnClicked:)] take:1] mapReplace:[RACSignal empty]] concat:[self rac_signalForSelector:@selector(btn2Clicked:)]] subscribeNext:^(UIButton *btn) {
        NSLog(@"RAC 1 Test");
    }];
    
    [[[[[[self rac_signalForSelector:@selector(btnClicked:)] take:1] mapReplace:[RACSignal empty]] concat] concat:[self rac_signalForSelector:@selector(btn2Clicked:)]] subscribeNext:^(UIButton *btn) {
        NSLog(@"RAC 2 Test");
    }];
    
    //btn1 点击后如果30秒内没点击，则调用timeOutLog
    RACSignal *timeOutSingle = [[[[RACSignal empty]
                                  throttle:20]
                                 concat:[RACSignal return:@NO]]
                                startWith:@YES];
    RACSignal *btn1ClickedSingle = [[[self rac_signalForSelector:@selector(btnClicked:)]
                                    mapReplace:@YES]
                                    startWith:@NO];
    [[[[[[[RACSignal combineLatest:@[timeOutSingle, btn1ClickedSingle]]
          and]
         ignore:@NO]
        take:1]
       delay:0.5]
      skip:1] subscribeNext:^(id x) {
        NSLog(@"aaaa:%@",x);
    }];
    
    [timeOutSingle subscribeNext:^(id x) {
        NSLog(@"bbbbb:%@",x);
    }];
    
    RACSignal *single1 = [[[[RACSignal return:@"gggggg"] delay:10] mapReplace:[RACSignal empty]] concat];
    RACSignal *single2 = [[[RACSignal return:@"hhhhhh"] delay:5] repeat];
    [[single1 concat:single2] subscribeNext:^(id x) {
        NSLog(@"mmmmm:%@",x);
    }];
}

- (void)timeOutLog {
    NSLog(@"timerOut:%@", [NSDate date]);
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSLog(@"viewDidAppear");
}

- (void)btnClicked:(UIButton *)btn {
    NSLog(@"btn1:%@", [NSDate date]);
}


- (void)btn2Clicked:(UIButton *)btn {
    NSLog(@"btn2");
}

- (void)btn3Clicked:(UIButton *)btn {
    NSLog(@"btn3");
}
@end
