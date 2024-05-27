//
//  UIColor+Extend.m
//  SuperApp
//
//  Created by 张杰 on 2022/8/18.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "UIColor+Extend.h"


@implementation UIColor (Extend)
+ (instancetype)tn_colorGradientChangeWithSize:(CGSize)size direction:(TNGradientChangeDirection)direction startColor:(UIColor *)startcolor endColor:(UIColor *)endColor {
    if (CGSizeEqualToSize(size, CGSizeZero) || !startcolor || !endColor) {
        return nil;
    }
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = CGRectMake(0, 0, size.width, size.height);

    CGPoint startPoint = CGPointZero;
    if (direction == TNGradientChangeDirectionDownDiagonalLine) {
        startPoint = CGPointMake(0.0, 1.0);
    }
    gradientLayer.startPoint = startPoint;

    CGPoint endPoint = CGPointZero;
    switch (direction) {
        case TNGradientChangeDirectionLevel:
            endPoint = CGPointMake(1.0, 0.0);
            break;
        case TNGradientChangeDirectionVertical:
            endPoint = CGPointMake(0.0, 1.0);
            break;
        case TNGradientChangeDirectionUpwardDiagonalLine:
            endPoint = CGPointMake(1.0, 1.0);
            break;
        case TNGradientChangeDirectionDownDiagonalLine:
            endPoint = CGPointMake(1.0, 0.0);
            break;
        default:
            break;
    }
    gradientLayer.endPoint = endPoint;

    gradientLayer.colors = @[(__bridge id)startcolor.CGColor, (__bridge id)endColor.CGColor];
    UIGraphicsBeginImageContext(size);
    [gradientLayer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return [UIColor colorWithPatternImage:image];
}
@end
