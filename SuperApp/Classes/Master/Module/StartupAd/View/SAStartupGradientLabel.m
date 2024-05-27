//
//  SAStartupGradientLabel.m
//  SuperApp
//
//  Created by Tia on 2022/12/14.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SAStartupGradientLabel.h"


@implementation SAStartupGradientLabel

- (instancetype)init {
    if (self = [super init]) {
        CAGradientLayer *gl = (CAGradientLayer *)self.layer;
        gl.startPoint = CGPointMake(0.5, 0);
        gl.endPoint = CGPointMake(0.5, 1);
        gl.colors = @[
            (__bridge id)[UIColor colorWithRed:255 / 255.0 green:222 / 255.0 blue:110 / 255.0 alpha:1.0].CGColor,
            (__bridge id)[UIColor colorWithRed:255 / 255.0 green:107 / 255.0 blue:7 / 255.0 alpha:1.0].CGColor
        ];
        gl.locations = @[@(0), @(1.0f)];
    }
    return self;
}

+ (Class)layerClass {
    return CAGradientLayer.class;
}

@end
