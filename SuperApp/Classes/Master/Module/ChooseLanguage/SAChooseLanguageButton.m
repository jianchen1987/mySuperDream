//
//  SAChooseLanguageButton.m
//  SuperApp
//
//  Created by VanJay on 2020/9/4.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAChooseLanguageButton.h"
#import <HDKitCore/HDFrameLayout.h>


@interface SAChooseLanguageButton ()
@property (nonatomic, strong) CAGradientLayer *gradientLayer;       ///< 渐变图层
@property (nonatomic, nullable, copy) NSArray *gradientLayerColors; ///< 渐变图层 colors
@end


@implementation SAChooseLanguageButton
- (void)updateBackgroundWithGradientLayerColors:(NSArray *)gradientLayerColors {
    self.gradientLayerColors = gradientLayerColors;

    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];

    CAGradientLayer * (^setGradientLayerWithPath)(UIBezierPath *) = ^CAGradientLayer *(UIBezierPath *path) {
        if (self.gradientLayer) {
            [self.gradientLayer removeFromSuperlayer];
            self.gradientLayer = nil;
        }
        CAShapeLayer *gradientLayerMaskLayer = [CAShapeLayer layer];
        gradientLayerMaskLayer.path = path.CGPath;

        CAGradientLayer *gradientLayer = [CAGradientLayer layer];
        gradientLayer.startPoint = CGPointMake(1, 0.5);
        gradientLayer.endPoint = CGPointMake(0, 0.5);
        gradientLayer.locations = @[@(0), @(1.0f)];
        gradientLayer.mask = gradientLayerMaskLayer;
        gradientLayer.frame = path.bounds;
        gradientLayer.colors = self.gradientLayerColors;
        self.gradientLayer = gradientLayer;
        return gradientLayer;
    };
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:5];
    CAGradientLayer *gradientLayer = setGradientLayerWithPath(path);
    [self.layer insertSublayer:gradientLayer atIndex:0];
}

- (void)layoutSubviews {
    [super layoutSubviews];

    [self.imageView hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
        make.size.hd_equalTo(CGSizeMake(20, 20));
        make.left.hd_equalTo(7);
        make.top.hd_equalTo(7);
    }];
    [self.titleLabel hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
        make.top.hd_equalTo(self.imageView.bottom).offset(3);
        make.centerX.hd_equalTo(CGRectGetWidth(self.frame) * 0.5);
    }];
}
@end
