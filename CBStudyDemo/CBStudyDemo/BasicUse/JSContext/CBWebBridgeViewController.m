//
//  CBWebBridgeViewController.m
//  CBStudyDemo
//
//  Created by ChenBin on 2017/1/16.
//  Copyright © 2017年 ChenBin. All rights reserved.
//

#import "CBWebBridgeViewController.h"
#import "WebViewJavascriptBridge.h"

@interface CBWebBridgeViewController ()

@property (nonatomic, strong) WebViewJavascriptBridge *bridge;
@property (nonatomic, strong) UIWebView *webView;

@end

@implementation CBWebBridgeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.webView];

    
    
    self.bridge = [WebViewJavascriptBridge bridgeForWebView:self.webView];
    [self.bridge registerHandler:@"log" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"Log: %@", data);
    }];
    [self.bridge callHandler:@"log" data:nil responseCallback:^(id responseData) {
        NSLog(@"callHandler: %@", responseData);
    }];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://knb.i.test.meituan.com/page/38"]];
    [self.webView loadRequest:request];
   
}

@end
