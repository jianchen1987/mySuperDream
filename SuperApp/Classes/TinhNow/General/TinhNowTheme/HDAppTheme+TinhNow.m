//
//  HDAppTheme+TNAppTheme.m
//  SuperApp
//
//  Created by seeu on 2020/6/16.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "HDAppTheme+TinhNow.h"
#import <HDKitCore/HDKitCore.h>


@implementation HDAppTheme (TinhNow)

static THAppThemeColor *_tinhNowColor;
static THAppThemeFont *_tinhNowFont;
+ (THAppThemeColor *)TinhNowColor {
    if (_tinhNowColor == nil) {
        _tinhNowColor = [THAppThemeColor new];
    }
    return _tinhNowColor;
}

+ (THAppThemeFont *)TinhNowFont {
    if (_tinhNowFont == nil) {
        _tinhNowFont = [THAppThemeFont new];
    }
    return _tinhNowFont;
}

@end


@implementation THAppThemeColor
- (UIColor *)c5E6681 {
    return [UIColor hd_colorWithHexString:@"5E6681"];
}
- (UIColor *)cD6DBE8 {
    return [UIColor hd_colorWithHexString:@"D6DBE8"];
}

- (UIColor *)cFF8F1A {
    return [UIColor hd_colorWithHexString:@"FF8F1A"];
}

- (UIColor *)c5d667f {
    return [UIColor hd_colorWithHexString:@"5d667f"];
}

- (UIColor *)c14B96D {
    return [UIColor hd_colorWithHexString:@"14B96D"];
}

- (UIColor *)cFFFFFF {
    return [UIColor hd_colorWithHexString:@"FFFFFF"];
}

- (UIColor *)cFA3A18 {
    return [UIColor hd_colorWithHexString:@"FA3A18"];
}

- (UIColor *)c222222 {
    return [UIColor hd_colorWithHexString:@"222222"];
}

- (UIColor *)c343B4D {
    return [UIColor hd_colorWithHexString:@"343B4D"];
}

- (UIColor *)cADB6C8 {
    return [UIColor hd_colorWithHexString:@"ADB6C8"];
}

- (UIColor *)cF5F7FA {
    return [UIColor hd_colorWithHexString:@"F5F7FA"];
}

- (UIColor *)cFF2323 {
    return [UIColor hd_colorWithHexString:@"FF2323"];
}

- (UIColor *)cFF8824 {
    return [UIColor hd_colorWithHexString:@"FF8824"];
}

- (UIColor *)c585858 {
    return [UIColor hd_colorWithHexString:@"585858"];
}

- (UIColor *)c666666 {
    return [UIColor hd_colorWithHexString:@"666666"];
}

- (UIColor *)cFFF3E8 {
    return [UIColor hd_colorWithHexString:@"FFF3E8"];
}

- (UIColor *)lineColor {
    return [UIColor hd_colorWithHexString:@"EBEDF0"];
}

- (UIColor *)C1 {
    return [UIColor hd_colorWithHexString:@"#FD8824"];
}

- (UIColor *)C2 {
    return [UIColor hd_colorWithHexString:@"#FFC95F"];
}

- (UIColor *)C3 {
    return [UIColor hd_colorWithHexString:@"#F83E00"];
}

- (UIColor *)G1 {
    return [UIColor hd_colorWithHexString:@"#343b4d"];
}

- (UIColor *)G2 {
    return [UIColor hd_colorWithHexString:@"#5d667f"];
}

- (UIColor *)G3 {
    return [UIColor hd_colorWithHexString:@"#adb6c8"];
}

- (UIColor *)G4 {
    return [UIColor hd_colorWithHexString:@"#E4E5EA"];
}

- (UIColor *)G5 {
    return [UIColor hd_colorWithHexString:@"#f5f7fa"];
}

- (UIColor *)G6 {
    return [UIColor hd_colorWithHexString:@"#f8f8fa"];
}
- (UIColor *)G7 {
    return [UIColor hd_colorWithHexString:@"#EBEDF0"];
}

- (UIColor *)R1 {
    return [UIColor hd_colorWithHexString:@"#FF2323"];
}

- (UIColor *)R2 {
    return [UIColor hd_colorWithHexString:@"#F52138"];
}

- (UIColor *)R3 {
    return [UIColor hd_colorWithHexString:@"#FF9457"];
}

- (UIColor *)R4 {
    return [UIColor hd_colorWithHexString:@"#FF0000"];
}

@end


@implementation THAppThemeFont

- (UIFont *)standard20 {
    return [UIFont systemFontOfSize:20];
}

- (UIFont *)standard20B {
    return [UIFont boldSystemFontOfSize:20];
}

- (UIFont *)standard17 {
    return [UIFont systemFontOfSize:17];
}

- (UIFont *)standard16 {
    return [UIFont systemFontOfSize:16];
}

- (UIFont *)standard15 {
    return [UIFont systemFontOfSize:15];
}

- (UIFont *)standard15B {
    return [UIFont boldSystemFontOfSize:15];
}

- (UIFont *)standard14 {
    return [UIFont systemFontOfSize:14];
}

- (UIFont *)standard13 {
    return [UIFont systemFontOfSize:13];
}

- (UIFont *)standard12 {
    return [UIFont systemFontOfSize:12];
}

- (UIFont *)standard11 {
    return [UIFont systemFontOfSize:11];
}

- (UIFont *)standard12B {
    return [UIFont boldSystemFontOfSize:12];
}

- (UIFont *)standard18B {
    return [UIFont boldSystemFontOfSize:18];
}

- (UIFont *)standard14M {
    return [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
}

- (UIFont *)standard15M {
    return [UIFont systemFontOfSize:15 weight:UIFontWeightMedium];
}

- (UIFont *)standard17M {
    return [UIFont systemFontOfSize:17 weight:UIFontWeightMedium];
}

- (UIFont *)standard17B {
    return [UIFont systemFontOfSize:17 weight:UIFontWeightSemibold];
}

- (UIFont *)standard20M {
    return [UIFont systemFontOfSize:20 weight:UIFontWeightMedium];
}

- (UIFont *)standard12M {
    return [UIFont systemFontOfSize:12.f weight:UIFontWeightMedium];
}

- (UIFont *)fontSemibold:(CGFloat)fontSize {
    return [UIFont fontWithName:@"PingFangSC-Semibold" size:fontSize];
}

- (UIFont *)fontRegular:(CGFloat)fontSize {
    return [UIFont fontWithName:@"PingFangSC-Regular" size:fontSize];
}

- (UIFont *)fontMedium:(CGFloat)fontSize {
    return [UIFont fontWithName:@"PingFangSC-Medium" size:fontSize];
}
- (UIFont *)fontLight:(CGFloat)fontSize {
    return [UIFont fontWithName:@"PingFangSC-Light" size:fontSize];
}
@end
