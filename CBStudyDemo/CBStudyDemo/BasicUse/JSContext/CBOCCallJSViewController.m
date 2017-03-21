//
//  CBOCCallJSViewController.m
//  CBStudyDemo
//
//  Created by ChenBin on 2016/12/30.
//  Copyright © 2016年 ChenBin. All rights reserved.
//

#import "CBOCCallJSViewController.h"
#import "VideoLoaingView.h"
#import <JavaScriptCore/JavaScriptCore.h>

@interface CBOCCallJSViewController ()<UIWebViewDelegate>

@property (nonatomic, assign) int index;
@property (nonatomic, strong) JSContext *jsContext;

@property (nonatomic, strong) VideoLoaingView *loadingView;

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
    self.view.backgroundColor = [UIColor whiteColor];
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
    self.loadingView = [VideoLoaingView startAnimationOnView:self.view withSize:CGSizeMake(200, 200)];
    
    UIButton *startLoadBtn = [UIButton createButtonWithTitle:@"开始" frame:CGRectMake(0, 300, 100, 50) callBack:^(UIButton *button) {
        [self.loadingView startAnimating];
    }];
    [self.view addSubview:startLoadBtn];
    
    UIButton *stopLoadBtn = [UIButton createButtonWithTitle:@"停止" frame:CGRectMake(startLoadBtn.right + 30, startLoadBtn.top, startLoadBtn.width, startLoadBtn.height) callBack:^(UIButton *button) {
        [self.loadingView stopAnimating];
    }];
    [self.view addSubview:stopLoadBtn];
}

- (void)test {
    
}

- (NSString *)loadJSFile:(NSString *)fileName {
    NSString *path = [[NSBundle mainBundle] pathForResource:fileName ofType:@"js"];
    NSString *jsScript = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    return jsScript;
}

@end
