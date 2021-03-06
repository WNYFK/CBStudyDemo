//
//  CBAutoReleaseHomeViewController.m
//  CBStudyDemo
//
//  Created by ChenBin on 2016/11/7.
//  Copyright © 2016年 ChenBin. All rights reserved.
//

#import "CBAutoReleaseHomeViewController.h"
#import "CBAutoreleaseForThreadViewController.h"

typedef void(^CBTestBlock)();

@interface CBTestObject1 : NSObject

@property (nonatomic, strong) CBTestObject1 *testObj;

@property (nonatomic, copy) CBTestBlock testBlock1;
@property (nonatomic, copy) CBTestBlock testBlock2;

- (void)startTest;

@end

@interface CBAutoReleaseHomeViewController ()


@end

@implementation CBAutoReleaseHomeViewController

__weak NSString* reference = nil;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CBSectionItem *sectionItem = [[CBSectionItem alloc] init];
    [self.dataArr addObject:sectionItem];
    
    [sectionItem.cellItems addObject:[[CBSkipItem alloc] initWithTitle:@"autorelease for thread" destinationClass:[CBAutoreleaseForThreadViewController class]]];
//    
    CBTestObject1 *testObj1 = [[CBTestObject1 alloc] init];
    [testObj1 startTest];
//    CBTestObject *testObj2 = [[CBTestObject alloc] init];
//    
//    testObj1.testObj = testObj2;
//    testObj2.testObj = testObj1;
    
}


@end


@implementation CBTestObject1

- (void)dealloc {
    NSLog(@"CBTestObject dealloc");
}

- (void)startTest {
    @weakify(self);
    self.testBlock1 = ^{
        @strongify(self);
        self.testBlock2 = ^{
            @strongify(self);
            self.testObj = [[CBTestObject1 alloc] init];
        };
    };
    self.testBlock1();
}



@end
