//
//  HDAppTheme+YumNow.m
//  SuperApp
//
//  Created by wmz on 2022/3/2.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "HDAppTheme+YumNow.h"
#import <HDKitCore/HDKitCore.h>

static WMAppThemeColor *_wmColor;
static WMAppThemeFont *_wmFont;
static WMAppThemeValue *_wmValue;


@implementation WMAppThemeColor

- (UIColor *)bg3 {
    return UIColor.whiteColor;
}

- (UIColor *)B0 {
    return [UIColor hd_colorWithHexString:@"#000000"];
}

- (UIColor *)B3 {
    return [UIColor hd_colorWithHexString:@"#333333"];
}

- (UIColor *)B6 {
    return [UIColor hd_colorWithHexString:@"#666666"];
}

- (UIColor *)B9 {
    return [UIColor hd_colorWithHexString:@"#999999"];
}

- (UIColor *)F6F6F6 {
    return [UIColor hd_colorWithHexString:@"#F6F6F6"];
}

- (UIColor *)F5F5F5 {
    return [UIColor hd_colorWithHexString:@"#F5F5F5"];
}

- (UIColor *)F2F2F2 {
    return [UIColor hd_colorWithHexString:@"#F2F2F2"];
}

- (UIColor *)F1F1F1 {
    return [UIColor hd_colorWithHexString:@"#F1F1F1"];
}

- (UIColor *)mainRed {
    return [UIColor hd_colorWithHexString:@"#FC2040"];
}

- (UIColor *)B1B1B1 {
    return [UIColor hd_colorWithHexString:@"#B1B1B1"];
}

- (UIColor *)lineColor {
    return [UIColor hd_colorWithHexString:@"#F2F2F2"];
}

- (UIColor *)lineColor1 {
    return [UIColor hd_colorWithHexString:@"#3A3838"];
}

- (UIColor *)lineColorE9 {
    return [UIColor hd_colorWithHexString:@"#E9EAEF"];
}

- (UIColor *)ffffff {
    return [UIColor hd_colorWithHexString:@"#ffffff"];
}

- (UIColor *)FDF8E5 {
    return [UIColor hd_colorWithHexString:@"#FDF8E5"];
}

- (UIColor *)CCCCCC {
    return [UIColor hd_colorWithHexString:@"#CCCCCC"];
}

- (UIColor *)bgGray {
    return [UIColor hd_colorWithHexString:@"#F3F4FA"];
}

- (UIColor *)white {
    return UIColor.whiteColor;
}

@end


@implementation WMAppThemeFont

- (UIFont *)standard13 {
    return [self wm_ForSize:13.0];
}

- (UIFont *)wm_ForMoneyDinSize:(CGFloat)size {
    return [self wm_ForSize:size fontName:@"DINPro-Medium"];
}

- (UIFont *)wm_ForSize:(CGFloat)size fontName:(NSString *)fontName {
    size = FontSize(size);
    return [UIFont fontWithName:fontName size:size];
}

- (UIFont *)wm_ForSize:(CGFloat)size weight:(UIFontWeight)weight {
    size = FontSize(size);
    return [UIFont systemFontOfSize:size weight:weight];
}

- (UIFont *)wm_ForSize:(CGFloat)size {
    size = FontSize(size);
    return [UIFont systemFontOfSize:size];
}

- (UIFont *)wm_thinForSize:(CGFloat)size {
    size = FontSize(size);
    return [UIFont systemFontOfSize:size weight:UIFontWeightThin];
}

- (UIFont *)wm_boldForSize:(CGFloat)size {
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


@implementation WMAppThemeValue

- (CGFloat)Left15 {
    return kRealWidth(15);
}

- (CGFloat)line {
    return ((0.6) * (kWidthCoefficientTo6S));
}

@end


@implementation HDAppTheme (YumNow)

+ (WMAppThemeColor *)WMColor {
    if (!_wmColor) {
        _wmColor = [WMAppThemeColor new];
    }
    return _wmColor;
}

+ (WMAppThemeFont *)WMFont {
    if (!_wmFont) {
        _wmFont = [WMAppThemeFont new];
    }
    return _wmFont;
}

+ (WMAppThemeValue *)WMValue {
    if (!_wmValue) {
        _wmValue = [WMAppThemeValue new];
    }
    return _wmValue;
}

@end
