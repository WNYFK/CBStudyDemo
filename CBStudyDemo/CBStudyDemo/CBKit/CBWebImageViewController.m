//
//  CBWebImageViewController.m
//  CBStudyDemo
//
//  Created by ChenBin on 16/8/17.
//  Copyright © 2016年 ChenBin. All rights reserved.
//

#import "CBWebImageViewController.h"
#import "CBWebImg/CBWebImageManager.h"
#import "UIImageView+CBWebCache.h"
#import "CBWebImg/CBImageCache.h"

@interface CBWebImageViewController ()

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *imgURLs;
@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation CBWebImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImageView *imgView1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100)];
    [self.view addSubview:imgView1];
    
//    [[CBWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:@"http://p0.meituan.net/mmc/1497bf7d9cc4bd6572440dca7d33a048204021.jpg"] progress:^(NSInteger receivedSize, NSInteger expectedSize) {
//        NSLog(@"imgView1 progress: %ld ====== %ld", (long)receivedSize, (long)expectedSize);
//    } completed:^(UIImage *image, NSData *data, CBImageCacheType cacheType, NSError *error, BOOL finished, NSURL *url) {
//        imgView1.image = image;
//    }];
    
    UIImageView *imgView2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, imgView1.bottom, imgView1.width, imgView1.height)];
    [self.view addSubview:imgView2];
//    [[CBWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:@"http://p0.meituan.net/mmc/1497bf7d9cc4bd6572440dca7d33a048204021.jpg"] progress:^(NSInteger receivedSize, NSInteger expectedSize) {
//        NSLog(@"imgView1 progress: %ld ====== %ld", (long)receivedSize, (long)expectedSize);
//    } completed:^(UIImage *image, NSData *data, CBImageCacheType cacheType, NSError *error, BOOL finished, NSURL *url) {
//        imgView2.image = image;
//    }];
//    [[CBWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:@"http://p1.meituan.net/mmc/5099eb79d36950700148466bcbf2df2755521.jpg"] progress:^(NSInteger receivedSize, NSInteger expectedSize) {
//        NSLog(@"imgView2 progress: %ld ===== %ld", receivedSize, expectedSize);
//    } completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
//        imgView2.image = image;
//    }];
    
    [[CBImageCache sharedImageCache] cleanDisk];
    [[CBImageCache sharedImageCache] clearMemory];
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, imgView2.bottom, imgView2.width, imgView2.height)];
    [self.imageView cb_setImageWithURL:[NSURL URLWithString:@"http://p0.meituan.net/mmc/1497bf7d9cc4bd6572440dca7d33a048204021.jpg"]];
    [self.view addSubview:self.imageView];
}

@end
