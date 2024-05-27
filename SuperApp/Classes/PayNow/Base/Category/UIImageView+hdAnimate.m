//
//  UIImageView+hdAnimate.m
//  customer
//
//  Created by 陈剑 on 2018/7/5.
//  Copyright © 2018年 chaos network technology. All rights reserved.
//

#import "UIImageView+hdAnimate.h"


@implementation UIImageView (hdAnimate)

- (void)rotate360DegreeWithImageViewDuration:(NSInteger)sec {
    CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"]; //让其在z轴旋转
    rotationAnimation.toValue = [NSNumber numberWithFloat:M_PI * 2.0];                                     //旋转角度
    rotationAnimation.duration = sec;                                                                      //旋转周期
    rotationAnimation.cumulative = YES;                                                                    //旋转累加角度
    rotationAnimation.repeatCount = MAXFLOAT;                                                              //旋转次数
    [self.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}

- (void)stopDance {
    [self.layer removeAllAnimations];
}

@end
