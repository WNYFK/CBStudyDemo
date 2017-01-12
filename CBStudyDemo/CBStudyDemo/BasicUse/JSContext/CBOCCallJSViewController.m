//
//  CBOCCallJSViewController.m
//  CBStudyDemo
//
//  Created by ChenBin on 2016/12/30.
//  Copyright © 2016年 ChenBin. All rights reserved.
//

#import "CBOCCallJSViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>

@interface CBOCCallJSViewController ()<UIWebViewDelegate>

@property (nonatomic, assign) int index;
@property (nonatomic, strong) JSContext *jsContext;

@end

@implementation CBOCCallJSViewController

- (void)dealloc {
    NSLog(@"");
}

- (void)viewWillDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"adafs" object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"oc call js";
    self.jsContext = [[JSContext alloc] init];
    [self.jsContext evaluateScript:[self loadJSFile:@"test"]];
    self.index = 0;
    
    UILabel *showLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 250, 100, 50)];
    [self.view addSubview:showLab];
    
    UIButton *sendToJSBtn = [UIButton createButtonWithTitle:@"发消息给js" frame:CGRectMake(0, 100, 200, 50) callBack:^(UIButton *button) {
        JSValue *function = [self.jsContext objectForKeyedSubscript:@"factorial"];
        self.index += 1;
        JSValue *result = [function callWithArguments:@[@(self.index)]];
        showLab.text = [NSString stringWithFormat:@"%@", [result toNumber]];
    }];
    [self.view addSubview:sendToJSBtn];
}

- (void)test {
    
}

- (NSString *)loadJSFile:(NSString *)fileName {
    NSString *path = [[NSBundle mainBundle] pathForResource:fileName ofType:@"js"];
    NSString *jsScript = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    return jsScript;
}

@end
