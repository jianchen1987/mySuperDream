//
//  GNTheme.m
//  SuperApp
//
//  Created by wmz on 2021/5/28.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "GNTheme.h"
#import <HDKitCore/HDKitCore.h>


@implementation HDAppThemeColor (GNTheme)

- (UIColor *)gn_mainColor {
    return [UIColor hd_colorWithHexString:@"#FC2040"];
}

- (UIColor *)gn_mainRedColor {
    return [UIColor hd_colorWithHexString:@"#FC2040"];
}

- (UIColor *)gn_whiteColor {
    return [UIColor hd_colorWithHexString:@"#FFFFFF"];
}

- (UIColor *)gn_mainColor70 {
    return [UIColor hd_colorWithHexString:@"#70FC2040"];
}

- (UIColor *)gn_mainBgColor {
    return [UIColor hd_colorWithHexString:@"#F3F4FA"];
}

- (UIColor *)gn_grayBgColor {
    return [UIColor hd_colorWithHexString:@"#EFEFEF"];
}

- (UIColor *)gn_lineColor {
    return [UIColor hd_colorWithHexString:@"#E9EAEF"];
}

- (UIColor *)gn_333Color {
    return [UIColor hd_colorWithHexString:@"#333333"];
}

- (UIColor *)gn_666Color {
    return [UIColor hd_colorWithHexString:@"#666666"];
}

- (UIColor *)gn_999Color {
    return [UIColor hd_colorWithHexString:@"#999999"];
}

- (UIColor *)gn_FFFCFC {
    return [UIColor hd_colorWithHexString:@"#FFFCFC"];
}

- (UIColor *)gn_C1C1C1 {
    return [UIColor hd_colorWithHexString:@"#C1C1C1"];
}

- (UIColor *)gn_B6B6B6 {
    return [UIColor hd_colorWithHexString:@"#B6B6B6"];
}

- (UIColor *)gn_B5B5B5 {
    return [UIColor hd_colorWithHexString:@"#B5B5B5"];
}

- (UIColor *)gn_BBBBBB {
    return [UIColor hd_colorWithHexString:@"#BBBBBB"];
}

- (UIColor *)gn_000000 {
    return [UIColor hd_colorWithHexString:@"#000000"];
}

- (UIColor *)gn_888888 {
    return [UIColor hd_colorWithHexString:@"#888888"];
}

- (UIColor *)gn_cccccc {
    return [UIColor hd_colorWithHexString:@"#cccccc"];
}

- (UIColor *)gn_warn {
    return [UIColor hd_colorWithHexString:@"#E9605B"];
}

- (UIColor *)gn_safe {
    return [UIColor hd_colorWithHexString:@"#9ED24B"];
}

- (UIColor *)gn_tipBg {
    return [UIColor hd_colorWithHexString:@"#FDF8E5"];
}

- (UIImage *)gn_ImageGradientChangeWithSize:(CGSize)size direction:(GNGradientChangeDirection)direction colors:(NSArray *)colors {
    if (CGSizeEqualToSize(size, CGSizeZero) || HDIsArrayEmpty(colors))
        return nil;
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = CGRectMake(0, 0, size.width, size.height);
    CGPoint startPoint = CGPointZero;
    if (direction == GNGradientChangeDirectionDownDiagonalLine) {
        startPoint = CGPointMake(0.0, 1.0);
    }
    gradientLayer.startPoint = startPoint;
    CGPoint endPoint = CGPointZero;
    switch (direction) {
        case GNGradientChangeDirectionLevel:
            endPoint = CGPointMake(1.0, 0.0);
            break;
        case GNGradientChangeDirectionVertical:
            endPoint = CGPointMake(0.0, 1.0);
            break;
        case GNGradientChangeDirectionUpwardDiagonalLine:
            endPoint = CGPointMake(1.0, 1.0);
            break;
        case GNGradientChangeDirectionDownDiagonalLine:
            endPoint = CGPointMake(1.0, 0.0);
            break;
        default:
            break;
    }
    gradientLayer.endPoint = endPoint;
    NSMutableArray *marr = NSMutableArray.new;
    for (UIColor *col in colors) {
        [marr addObject:(__bridge id)col.CGColor];
    }
    gradientLayer.colors = marr;
    UIGraphicsBeginImageContext(size);
    [gradientLayer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
- (UIColor *)gn_ColorGradientChangeWithSize:(CGSize)size direction:(GNGradientChangeDirection)direction colors:(NSArray *)colors {
    return [UIColor colorWithPatternImage:[self gn_ImageGradientChangeWithSize:size direction:direction colors:colors]];
}

- (UIImage *)gn_ImageGradientChangeWithSize:(CGSize)size direction:(GNGradientChangeDirection)direction startColor:(UIColor *)startcolor endColor:(UIColor *)endColor {
    if (!startcolor || !endColor)
        return nil;
    return [self gn_ImageGradientChangeWithSize:size direction:direction colors:@[startcolor, endColor]];
}
- (UIColor *)gn_ColorGradientChangeWithSize:(CGSize)size direction:(GNGradientChangeDirection)direction startColor:(UIColor *)startcolor endColor:(UIColor *)endColor {
    return [UIColor colorWithPatternImage:[self gn_ImageGradientChangeWithSize:size direction:direction startColor:startcolor endColor:endColor]];
}
@end


@implementation HDAppThemeValue (GNTheme)
- (CGFloat)gn_line {
    return ((0.5) * (kWidthCoefficientTo6S));
}
- (CGFloat)gn_border {
    return ((1.0) * (kWidthCoefficientTo6S));
}
- (CGFloat)gn_offset {
    return kRealHeight(7);
}
- (CGFloat)gn_marginL {
    return kRealWidth(12);
}
- (CGFloat)gn_marginT {
    return kRealHeight(10);
}
- (CGFloat)gn_radius6 {
    return kRealHeight(6);
}
- (CGFloat)gn_radius8 {
    return kRealHeight(8);
}
- (CGFloat)gn_radius4 {
    return kRealHeight(4);
}
@end


@implementation HDAppThemeFont (GNTheme)
- (UIFont *)gn_15 {
    return [self gn_ForSize:15.0];
}
- (UIFont *)gn_14 {
    return [self gn_ForSize:14.0];
}
- (UIFont *)gn_13 {
    return [self gn_ForSize:13.0];
}
- (UIFont *)gn_12 {
    return [self gn_ForSize:12.0];
}

- (NSMutableDictionary *)space:(double)space font:(UIFont *)font {
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    paragraphStyle.lineSpacing = space ?: 0.5 * font.pointSize;
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    [attributes setObject:paragraphStyle forKey:NSParagraphStyleAttributeName];
    return attributes;
}

- (UIFont *)gn1 {
    return [UIFont systemFontOfSize:FontSize(20) weight:UIFontWeightBold];
}

- (UIFont *)gn2 {
    return [UIFont systemFontOfSize:FontSize(15) weight:UIFontWeightBold];
}

- (UIFont *)gn3 {
    return [UIFont systemFontOfSize:FontSize(14) weight:UIFontWeightRegular];
}

- (UIFont *)gn4 {
    return [UIFont systemFontOfSize:FontSize(12) weight:UIFontWeightRegular];
}

- (UIFont *)gn5 {
    return [UIFont systemFontOfSize:FontSize(11) weight:UIFontWeightRegular];
}

- (UIFont *)gn_ForSize:(CGFloat)size {
    size = FontSize(size);
    return [UIFont systemFontOfSize:size weight:UIFontWeightRegular];
}

- (UIFont *)gn_thinForSize:(CGFloat)size {
    size = FontSize(size);
    return [UIFont systemFontOfSize:size weight:UIFontWeightThin];
}

- (UIFont *)gn_ForSize:(CGFloat)size weight:(UIFontWeight)weight {
    size = FontSize(size);
    return [UIFont systemFontOfSize:size weight:weight];
}

- (UIFont *)gn_boldForSize:(CGFloat)size {
    size = FontSize(size);
    return [UIFont systemFontOfSize:size weight:UIFontWeightBold];
}

static inline CGFloat FontSize(CGFloat fontSize) {
    if (kScreenWidth == 320) {
        return fontSize - 2;
    } else if (kScreenWidth >= 414) {
        return fontSize + 1;
    }
    return fontSize;
}

@end
