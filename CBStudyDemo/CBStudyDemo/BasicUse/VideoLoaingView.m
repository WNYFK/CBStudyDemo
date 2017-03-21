//
//  VideoLoaingView.m
//  XiangKanProject
//
//  Created by garin on 2017/2/21.
//  Copyright © 2017年 XiaoMi. All rights reserved.
//

#import "VideoLoaingView.h"

#define VideoLoadingViewTag  1000

@interface VideoLoaingView (){
    CAReplicatorLayer *replicatorLayer;
}

@property (nonatomic,strong) CALayer *spotLayer;
@property (nonatomic,strong) UIColor *tColor;
@property (nonatomic,assign) BOOL isAnimating;

@end

@implementation VideoLoaingView

//默认居中对齐的
+(VideoLoaingView *) startAnimationOnView:(UIView *) baseView withSize:(CGSize) size{

    VideoLoaingView *indicator = [baseView viewWithTag:VideoLoadingViewTag];
    if (!indicator) {
        indicator = [[VideoLoaingView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height) withTintColor:[UIColor redColor]];
        [baseView addSubview:indicator];
    }else{
        [baseView bringSubviewToFront:indicator];
    }
    
    [indicator mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.center.equalTo(baseView);
        make.size.mas_equalTo(size);
    }];
    
    [indicator startAnimating];
    
    return indicator;
}

+(void) stopVideoAnimatioOnView:(UIView *) baseView{
    VideoLoaingView *indicator = [baseView viewWithTag:VideoLoadingViewTag];
    [indicator stopAnimating];
    [indicator removeFromSuperview];
}

-(instancetype) initWithFrame:(CGRect) frame withTintColor:(UIColor*) color{
    
    if (self = [super initWithFrame:frame]) {
        self.tColor = color;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillEnterBackground) name:UIApplicationWillResignActiveNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillBecomeActive) name:UIApplicationWillEnterForegroundNotification object:nil];
    }
    
    return self;
}

-(void) startAnimating{
    
    self.isAnimating = YES;
    self.layer.sublayers = nil;
    
    replicatorLayer = [CAReplicatorLayer layer];
    replicatorLayer.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    replicatorLayer.backgroundColor = [UIColor clearColor].CGColor;
    [self.layer addSublayer:replicatorLayer];
    
    NSInteger numOfDot = 15;
    replicatorLayer.instanceCount = numOfDot;
    CGFloat angle = (M_PI * 2)/numOfDot;
    replicatorLayer.instanceTransform = CATransform3DMakeRotation(angle, 0, 0, 1);
    replicatorLayer.instanceDelay = 1.5/numOfDot;
    
    self.spotLayer = [CALayer layer];
    self.spotLayer.bounds = CGRectMake(0, 0, self.frame.size.width/6, self.frame.size.width/6);
    self.spotLayer.position = CGPointMake(self.frame.size.width/2, 5);
    self.spotLayer.cornerRadius = self.spotLayer.bounds.size.width/2;
    self.spotLayer.backgroundColor = self.tColor.CGColor;
    self.spotLayer.transform = CATransform3DMakeScale(0.1, 0.1, 0.1);
    
    [replicatorLayer addSublayer:self.spotLayer];
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animation.fromValue = @1;
    animation.toValue = @0.1;
    animation.duration = 1.5;
    animation.repeatCount = CGFLOAT_MAX;
    
    [self.spotLayer addAnimation:animation forKey:@"animation"];
}

-(void) stopAnimating{
    
//    [self.spotLayer removeAnimationForKey:@"animation"];
//    self.spotLayer.speed = 0;
    CFTimeInterval paused_time = [replicatorLayer convertTime:CACurrentMediaTime() fromLayer:nil];
    replicatorLayer.speed = 0.0;
    replicatorLayer.timeOffset = paused_time;
}

- (void)appWillEnterBackground{
    [self stopAnimating];
}

- (void)appWillBecomeActive{

//    [self startAnimating];
    CFTimeInterval paused_time = [replicatorLayer timeOffset];
    replicatorLayer.speed = 1.0f;
    replicatorLayer.timeOffset = 0.0f;
    replicatorLayer.beginTime = 0.0f;
    CFTimeInterval time_since_pause = [replicatorLayer convertTime:CACurrentMediaTime() fromLayer:nil] - paused_time;
    replicatorLayer.beginTime = time_since_pause;
}

@end
