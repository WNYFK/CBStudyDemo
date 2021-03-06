//
//  CBBasicUseViewController.m
//  CBStudyDemo
//
//  Created by ChenBin on 16/8/12.
//  Copyright © 2016年 ChenBin. All rights reserved.
//

#import "CBBasicUseViewController.h"
#import "CBNSRunLoopViewController.h"
#import "CBCFRunLoopViewController.h" 
#import "CBRunTimeVIewController.h"
#import "CBCoreDataViewController.h"
#import "CBCoreDataThirdLibUseViewController.h"
#import "CBGCDViewController.h"
#import "CBOperationViewController.h"
#import "CBThreadViewController.h"
#import "CBMoGuJieDetailViewController.h"
#import "CBStrechableTestViewController.h"
#import "CBRACViewController.h"
#import "CBDynamicViewController.h"
#import "CBRACTestVIewController.h"
#import "CBCompositeRACViewController.h"
#import "CBCoreDataFirstUseViewController.h"
#import "CBCoreDataMultiThreadUseViewController.h"
#import "CBMasonryViewController.h"
#import "CBTestViewController.h"
#import "CBJSCallOCViewController.h"
#import "CBOCCallJSViewController.h"
#import "CBJSUseViewController.h"
#import "CBWebBridgeViewController.h"

@interface CBBasicUseViewController ()


@end

@implementation CBBasicUseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"基本用法";
    [self setupBaseData];
}

- (void)setupBaseData {
    CBSectionItem *testSectionItem = [[CBSectionItem alloc] initWithTitle:@"测试页"];
    [self.dataArr addObject:testSectionItem];
    [testSectionItem.cellItems addObject:[[CBSkipItem alloc] initWithTitle:@"测试" destinationClass:[CBTestViewController class]]];
    
    CBSectionItem *jsContextSectionItem = [[CBSectionItem alloc] initWithTitle:@"JSContext"];
    [self.dataArr addObject:jsContextSectionItem];
    [jsContextSectionItem.cellItems addObject:[[CBSkipItem alloc] initWithTitle:@"js call oc" destinationClass:[CBJSCallOCViewController class]]];
    [jsContextSectionItem.cellItems addObject:[[CBSkipItem alloc] initWithTitle:@"oc call js" destinationClass:[CBOCCallJSViewController class]]];
    [jsContextSectionItem.cellItems addObject:[[CBSkipItem alloc] initWithTitle:@"webview 使用" destinationClass:[CBJSUseViewController class]]];
    [jsContextSectionItem.cellItems addObject:[[CBSkipItem alloc] initWithTitle:@"webview bridge使用" destinationClass:[CBWebBridgeViewController class]]];
    
    CBSectionItem *runloopSectionItem = [[CBSectionItem alloc] initWithTitle:@"RunLoop"];
    [runloopSectionItem.cellItems addObject:[[CBSkipItem alloc] initWithTitle:@"NSRunLoop" destinationClass:[CBNSRunLoopViewController class]]];
    [runloopSectionItem.cellItems addObject:[[CBSkipItem alloc] initWithTitle:@"CFRunLoop" destinationClass:[CBCFRunLoopViewController class]]];
    [self.dataArr addObject:runloopSectionItem];
    
    CBSectionItem *multiThreadSectionItem = [[CBSectionItem alloc] initWithTitle:@"Multi-Thread"];
    [multiThreadSectionItem.cellItems addObject:[[CBSkipItem alloc] initWithTitle:@"GCD" destinationClass:[CBGCDViewController class]]];
    [multiThreadSectionItem.cellItems addObject: [[CBSkipItem alloc] initWithTitle:@"Operation" destinationClass:[CBOperationViewController class]]];
    [multiThreadSectionItem.cellItems addObject: [[CBSkipItem alloc] initWithTitle:@"Thread" destinationClass:[CBThreadViewController class]]];
    [self.dataArr addObject:multiThreadSectionItem];
    
    CBSectionItem *runtimeSectionItem = [[CBSectionItem alloc] initWithTitle:@"Runtime"];
    [runtimeSectionItem.cellItems addObject:[[CBSkipItem alloc] initWithTitle:@"运行时" destinationClass:[CBRunTimeVIewController class]]];
    [self.dataArr addObject:runtimeSectionItem];
    
    CBSectionItem *coreDataSectionItem = [[CBSectionItem alloc] initWithTitle:@"CoreData"];
    [coreDataSectionItem.cellItems addObject:[[CBSkipItem alloc] initWithTitle:@"CoreData基本用法" destinationClass:[CBCoreDataFirstUseViewController class]]];
    [coreDataSectionItem.cellItems addObject:[[CBSkipItem alloc] initWithTitle:@"CoreData多线程" destinationClass:[CBCoreDataMultiThreadUseViewController class]]];
    [coreDataSectionItem.cellItems addObject:[[CBSkipItem alloc] initWithTitle:@"CoreData 使用" destinationClass:[CBCoreDataViewController class]]];
    [coreDataSectionItem.cellItems addObject:[[CBSkipItem alloc] initWithTitle:@"CoreData 第三方库使用" destinationClass:[CBCoreDataThirdLibUseViewController class]]];
    [self.dataArr addObject:coreDataSectionItem];
    
    CBSectionItem *mgjDetailStructureItem = [[CBSectionItem alloc] initWithTitle:@"蘑菇街、微博个人详情页结构相关"];
    [mgjDetailStructureItem.cellItems addObject:[[CBSkipItem alloc] initWithTitle:@"蘑菇街详情页结构" destinationClass:[CBMoGuJieDetailViewController class]]];
    [mgjDetailStructureItem.cellItems addObject:[[CBSkipItem alloc] initWithTitle:@"结构测试" destinationClass:[CBStrechableTestViewController class]]];
    [self.dataArr addObject:mgjDetailStructureItem];
    
    CBSectionItem *RACSectionItem = [[CBSectionItem alloc] initWithTitle:@"RAC相关"];
    [RACSectionItem.cellItems addObject:[[CBSkipItem alloc] initWithTitle:@"RAC基础使用" destinationClass:[CBRACViewController class]]];
    [RACSectionItem.cellItems addObject:[[CBSkipItem alloc] initWithTitle:@"RAC使用" destinationClass:[CBRACTestVIewController class]]];
    [RACSectionItem.cellItems addObject:[[CBSkipItem alloc] initWithTitle:@"RAC综合使用" destinationClass:[CBCompositeRACViewController class]]];
    [self.dataArr addObject:RACSectionItem];
    
    CBSectionItem *KitDynamicSectionItem = [[CBSectionItem alloc] initWithTitle:@"Kit_Dynamic"];
    [KitDynamicSectionItem.cellItems addObject:[[CBSkipItem alloc] initWithTitle:@"dynamic" destinationClass:[CBDynamicViewController class]]];
    [self.dataArr addObject:KitDynamicSectionItem];
    
    CBSectionItem *AutolayoutSectionItem = [[CBSectionItem alloc] initWithTitle:@"Autolayout"];
    [AutolayoutSectionItem.cellItems addObject:[[CBSkipItem alloc] initWithTitle:@"masonry" destinationClass:[CBMasonryViewController class]]];
    [self.dataArr addObject:AutolayoutSectionItem];
    
}

@end
