//
//  CBTouchTestViewController.m
//  CBStudyDemo
//
//  Created by chenbin on 16/9/6.
//  Copyright © 2016年 ChenBin. All rights reserved.
//

#import "CBTouchTestViewController.h"

@interface CBTouchView : UIScrollView

@end

@interface CBTouchTestViewController ()

@end

@implementation CBTouchTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CBTouchView *touchView = [[CBTouchView alloc] initWithFrame:self.view.bounds];
    touchView.contentSize = CGSizeMake(self.view.width, self.view.height);
    [self.view addSubview:touchView];
}
@end


@implementation CBTouchView

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    NSLog(@"touchesBegan:%f====%f",[touch locationInView:self].x, [touch locationInView:self].y);
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    NSLog(@"touchesMoved:%f====%f",[touch locationInView:self].x, [touch locationInView:self].y);
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    NSLog(@"touchesEnded:%f====%f",[touch locationInView:self].x, [touch locationInView:self].y);
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    NSLog(@"touchesCancelled:%f====%f",[touch locationInView:self].x, [touch locationInView:self].y);
}

- (void)touchesEstimatedPropertiesUpdated:(NSSet *)touches {
    UITouch *touch = [touches anyObject];
    NSLog(@"touchesEstimatedPropertiesUpdated:%f====%f",[touch locationInView:self].x, [touch locationInView:self].y);
}

@end