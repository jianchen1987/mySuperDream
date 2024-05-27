//
//  SAAppTheme.m
//  SuperApp
//
//  Created by VanJay on 2020/7/11.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAAppTheme.h"
#import <HDKitCore/UIColor+HDKitCore.h>


@implementation HDAppThemeColor (SuperApp)

- (UIColor *)sa_C1 {
    return [UIColor hd_colorWithHexString:@"#FC2040"];
}

- (UIColor *)sa_C2 {
    return [UIColor hd_colorWithHexString:@"#FF777777"];
}

- (UIColor *)sa_C333 {
    return [UIColor hd_colorWithHexString:@"#333333"];
}

- (UIColor *)sa_C666 {
    return [UIColor hd_colorWithHexString:@"#666666"];
}

- (UIColor *)sa_C999 {
    return [UIColor hd_colorWithHexString:@"#999999"];
}

- (UIColor *)sa_backgroundColor {
    return [UIColor hd_colorWithHexString:@"#F3F4FA"];
}

- (UIColor *)sa_separatorLineColor {
    return [UIColor hd_colorWithHexString:@"#E9EAEF"];
}

- (UIColor *)sa_warningColor {
    return [UIColor hd_colorWithHexString:@"#E9605B"];
}

- (UIColor *)sa_searchBarTextColor {
    return [UIColor hd_colorWithHexString:@"#CCCCCC"];
}

- (UIColor *)sa_colorWithHexString:(NSString *)hexString {
    return [UIColor hd_colorWithHexString:hexString];
}

@end


@implementation UIColor (SuperApp)

+ (UIColor *)sa_C1 {
    return [UIColor hd_colorWithHexString:@"#FC2040"];
}

+ (UIColor *)sa_C2 {
    return [UIColor hd_colorWithHexString:@"#FF777777"];
}

+ (UIColor *)sa_C333 {
    return [UIColor hd_colorWithHexString:@"#333333"];
}

+ (UIColor *)sa_C666 {
    return [UIColor hd_colorWithHexString:@"#666666"];
}

+ (UIColor *)sa_C999 {
    return [UIColor hd_colorWithHexString:@"#999999"];
}

+ (UIColor *)sa_backgroundColor {
    return [UIColor hd_colorWithHexString:@"#F3F4FA"];
}

+ (UIColor *)sa_separatorLineColor {
    return [UIColor hd_colorWithHexString:@"#E9EAEF"];
}

+ (UIColor *)sa_warningColor {
    return [UIColor hd_colorWithHexString:@"#E9605B"];
}

+ (UIColor *)sa_searchBarTextColor {
    return [UIColor hd_colorWithHexString:@"#CCCCCC"];
}

@end


@implementation HDAppThemeFont (SuperApp)

- (UIFont *)sa_standard20 {
    return [UIFont systemFontOfSize:20];
}
- (UIFont *)sa_standard16 {
    return [UIFont systemFontOfSize:16];
}
- (UIFont *)sa_standard14 {
    return [UIFont systemFontOfSize:14];
}
- (UIFont *)sa_standard12 {
    return [UIFont systemFontOfSize:12];
}
- (UIFont *)sa_standard11 {
    return [UIFont systemFontOfSize:11];
}

/// UIFontWeightMedium
- (UIFont *)sa_standard20M {
    return [UIFont systemFontOfSize:20 weight:UIFontWeightMedium];
}
- (UIFont *)sa_standard16M {
    return [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
}
- (UIFont *)sa_standard14M {
    return [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
}
- (UIFont *)sa_standard12M {
    return [UIFont systemFontOfSize:12 weight:UIFontWeightMedium];
}
- (UIFont *)sa_standard11M {
    return [UIFont systemFontOfSize:11 weight:UIFontWeightMedium];
}

/// UIFontWeightSemibold
- (UIFont *)sa_standard20SB {
    return [UIFont systemFontOfSize:20 weight:UIFontWeightSemibold];
}
- (UIFont *)sa_standard16SB {
    return [UIFont systemFontOfSize:16 weight:UIFontWeightSemibold];
}
- (UIFont *)sa_standard14SB {
    return [UIFont systemFontOfSize:14 weight:UIFontWeightSemibold];
}
- (UIFont *)sa_standard12SB {
    return [UIFont systemFontOfSize:12 weight:UIFontWeightSemibold];
}
- (UIFont *)sa_standard11SB {
    return [UIFont systemFontOfSize:11 weight:UIFontWeightSemibold];
}

/// UIFontWeightBold
- (UIFont *)sa_standard20B {
    return [UIFont systemFontOfSize:20 weight:UIFontWeightBold];
}
- (UIFont *)sa_standard16B {
    return [UIFont systemFontOfSize:16 weight:UIFontWeightBold];
}
- (UIFont *)sa_standard14B {
    return [UIFont systemFontOfSize:14 weight:UIFontWeightBold];
}
- (UIFont *)sa_standard12B {
    return [UIFont systemFontOfSize:12 weight:UIFontWeightBold];
}
- (UIFont *)sa_standard11B {
    return [UIFont systemFontOfSize:11 weight:UIFontWeightBold];
}

/// UIFontWeightHeavy
- (UIFont *)sa_standard20H {
    return [UIFont systemFontOfSize:20 weight:UIFontWeightHeavy];
}
- (UIFont *)sa_standard16H {
    return [UIFont systemFontOfSize:16 weight:UIFontWeightHeavy];
}
- (UIFont *)sa_standard14H {
    return [UIFont systemFontOfSize:14 weight:UIFontWeightHeavy];
}
- (UIFont *)sa_standard12H {
    return [UIFont systemFontOfSize:12 weight:UIFontWeightHeavy];
}
- (UIFont *)sa_standard11H {
    return [UIFont systemFontOfSize:11 weight:UIFontWeightHeavy];
}

/// DIN
- (UIFont *)sa_fontDINBlack:(CGFloat)fontSize {
    return [UIFont fontWithName:@"DIN-Black" size:fontSize];
}
- (UIFont *)sa_fontDINBold:(CGFloat)fontSize {
    return [UIFont fontWithName:@"DIN-Bold" size:fontSize];
}
- (UIFont *)sa_fontDINLight:(CGFloat)fontSize {
    return [UIFont fontWithName:@"DIN-Light" size:fontSize];
}
- (UIFont *)sa_fontDINMedium:(CGFloat)fontSize {
    return [UIFont fontWithName:@"DIN-Medium" size:fontSize];
}

- (UIFont *)sa_fontNotoSansKhmerUI_Bold:(CGFloat)fontSize {
    return [UIFont fontWithName:@"NotoSansKhmerUI-Bold" size:fontSize];
}

- (UIFont *)sa_fontNotoSansKhmerUI_Regular:(CGFloat)fontSize {
    return [UIFont fontWithName:@"NotoSansKhmerUI-Regular" size:fontSize];
}

@end
