//
//  CBJSUseViewController.m
//  CBStudyDemo
//
//  Created by ChenBin on 2017/1/11.
//  Copyright © 2017年 ChenBin. All rights reserved.
//

#import "CBJSUseViewController.h"

@interface CBJSUseViewController ()<UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *webView;

@end

@implementation CBJSUseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    self.webView.delegate = self;
    NSString *path = [[[NSBundle mainBundle] bundlePath]  stringByAppendingPathComponent:@"JSCallOC.html"];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL fileURLWithPath:path]];
    [self.webView loadRequest:request];
    [self.view addSubview:self.webView];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    static int count = 1;
    NSString *requestString = [[request.URL absoluteString] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSArray<NSString *> *components = [requestString componentsSeparatedByString:@":"];
    if (components.count > 1 && [components.firstObject isEqualToString:@"CBStudyDemo"]) {
        [CRToastManager showNotificationWithMessage:[NSString stringWithFormat:@"%@--%d",components[1], count++] completionBlock:nil];
        return NO;
    }
    
    return YES;
}



@end
