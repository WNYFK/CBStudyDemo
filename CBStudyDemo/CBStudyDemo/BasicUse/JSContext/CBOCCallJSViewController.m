//
//  CBOCCallJSViewController.m
//  CBStudyDemo
//
//  Created by ChenBin on 2016/12/30.
//  Copyright © 2016年 ChenBin. All rights reserved.
//

#import "CBOCCallJSViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>

@protocol CBJSExport <JSExport>

JSExportAs(calculateForJS, - (void)handleFactorialCalculateWithNumber:(NSNumber *)number);
- (void)pushViewController:(NSString *)view title:(NSString *)title;

@end

@interface CBOCCallJSViewController ()<UIWebViewDelegate, CBJSExport>

@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) JSContext *jsContext;

@end

@implementation CBOCCallJSViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"js call oc";
    self.webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    self.webView.delegate = self;
    [self.view addSubview:self.webView];
    
    NSString *path = [[[NSBundle mainBundle] bundlePath]  stringByAppendingPathComponent:@"JSCallOC.html"];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL fileURLWithPath:path]];
    [self.webView loadRequest:request];
}

#pragma mark -- UIWebViewDelegate

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    self.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    
    self.jsContext = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    
    self.jsContext.exceptionHandler = ^(JSContext *context, JSValue *exception) {
        context.exception = exception;
        NSLog(@"异常：%@",exception);
    };
    
    self.jsContext[@"native"] = self;
    self.jsContext[@"log"] = ^(NSString *str) {
        NSLog(@"log: %@",str);
    };
    
    self.jsContext[@"alert"] = ^(NSString *str) {
        NSLog(@"alert");
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"msg from js" message:str delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    };
    
    self.jsContext[@"addSubView"] = ^(NSString *viewName) {
        NSLog(@"addSubview 啊");
    };
    self.jsContext[@"mutiParams"] = ^(NSString *a, NSString *b, NSString *c) {
        NSLog(@"mutiParams: %@===%@===%@",a, b, c);
    };
}

#pragma mark CBJSExport

- (void)pushViewController:(NSString *)view title:(NSString *)title {
    Class secondClass = NSClassFromString(view);
    UIViewController *secondVC = [[secondClass alloc] init];
    secondVC.title = title;
    [self.navigationController pushViewController:secondVC animated:YES];
}

- (void)handleFactorialCalculateWithNumber:(NSNumber *)number {
    NSLog(@"当前js数值: %@", number);
    NSNumber *resultNum = @(number.integerValue + 2);
    [self.jsContext[@"showResult"] callWithArguments:@[resultNum]];
    
}
@end
