//
//  VideoLoaingView.h
//  XiangKanProject
//
//  Created by garin on 2017/2/21.
//  Copyright © 2017年 XiaoMi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VideoLoaingView : UIView

+(VideoLoaingView *) startAnimationOnView:(UIView *) baseView withSize:(CGSize) size;

-(void) startAnimating;

-(void) stopAnimating;

@end
