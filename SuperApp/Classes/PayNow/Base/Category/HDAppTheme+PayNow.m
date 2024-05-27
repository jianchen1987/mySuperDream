//
//  HDAppTheme+PayNow.m
//  SuperApp
//
//  Created by xixi_wen on 2021/12/20.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "HDAppTheme+PayNow.h"
#import <HDKitCore/HDKitCore.h>


@implementation HDAppTheme (PayNow)

static PNAppThemeColor *_tinhNowColor;
static PNAppThemeFont *_tinhNowFont;
+ (PNAppThemeColor *)PayNowColor {
    if (_tinhNowColor == nil) {
        _tinhNowColor = [PNAppThemeColor new];
    }
    return _tinhNowColor;
}

+ (PNAppThemeFont *)PayNowFont {
    if (_tinhNowFont == nil) {
        _tinhNowFont = [PNAppThemeFont new];
    }
    return _tinhNowFont;
}
@end


@implementation PNAppThemeColor
/// 新的背景颜色
- (UIColor *)backgroundColor {
    return [UIColor hd_colorWithHexString:@"#F3F4FA"];
}

- (UIColor *)cF6F6F6 {
    return [UIColor hd_colorWithHexString:@"F6F6F6"];
}

- (UIColor *)cC4C5C8 {
    return [UIColor hd_colorWithHexString:@"C4C5C8"];
}

- (UIColor *)cC6C8CC {
    return [UIColor hd_colorWithHexString:@"C6C8CC"];
}

- (UIColor *)c9599A2 {
    return [UIColor hd_colorWithHexString:@"9599A2"];
}

- (UIColor *)cFC2040 { // 新主题颜色
    return [UIColor hd_colorWithHexString:@"FC2040"];
}

- (UIColor *)cFD7127 { // 旧主题颜色
    return [UIColor hd_colorWithHexString:@"FD7127"];
}

- (UIColor *)c2A251F {
    return [UIColor hd_colorWithHexString:@"2A251F"];
}

- (UIColor *)cF8F8F8 {
    return [UIColor hd_colorWithHexString:@"F8F8F8"];
}

- (UIColor *)c000000 {
    return [UIColor hd_colorWithHexString:@"000000"];
}

- (UIColor *)cFFFFFF {
    return [UIColor hd_colorWithHexString:@"FFFFFF"];
}

- (UIColor *)c333333 {
    return [UIColor hd_colorWithHexString:@"333333"];
}

- (UIColor *)c343B4D {
    return [UIColor hd_colorWithHexString:@"343B4D"];
}

- (UIColor *)cCCCCCC {
    return [UIColor hd_colorWithHexString:@"CCCCCC"];
}

- (UIColor *)c999999 {
    return [UIColor hd_colorWithHexString:@"999999"];
}

- (UIColor *)cADB6C8 {
    return [UIColor hd_colorWithHexString:@"ADB6C8"];
}

- (UIColor *)c666666 {
    return [UIColor hd_colorWithHexString:@"666666"];
}

- (UIColor *)cECECEC {
    return [UIColor hd_colorWithHexString:@"ECECEC"];
}

- (UIColor *)lineColor {
    return [UIColor hd_colorWithHexString:@"E9EAEF"];
}

- (UIColor *)placeholderColor {
    return [UIColor hd_colorWithHexString:@"D6D8DB"];
}

- (UIColor *)cD8DBE1 {
    return [UIColor hd_colorWithHexString:@"#D8DBE1"];
}

- (UIColor *)mainThemeColor {
    return [UIColor hd_colorWithHexString:@"#FC2040"];
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


@implementation PNAppThemeFont

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

- (UIFont *)standard16M {
    return [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
}

- (UIFont *)standard16B {
    return [UIFont boldSystemFontOfSize:16];
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

- (UIFont *)standard14B {
    return [UIFont boldSystemFontOfSize:14];
}

- (UIFont *)standard14M {
    return [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
}

- (UIFont *)standard18B {
    return [UIFont boldSystemFontOfSize:18];
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
- (UIFont *)fontBold:(CGFloat)fontSize {
    return [UIFont boldSystemFontOfSize:fontSize];
}

/// nunitoSans
- (UIFont *)nunitoSansRegular:(CGFloat)fontSize {
    return [UIFont fontWithName:@"NunitoSans-Regular" size:fontSize];
}

- (UIFont *)nunitoSansSemiBold:(CGFloat)fontSize {
    return [UIFont fontWithName:@"NunitoSans-SemiBold" size:fontSize];
}

/// - NID
- (UIFont *)fontDINBlack:(CGFloat)fontSize {
    return [UIFont fontWithName:@"DIN-Black" size:fontSize];
}

- (UIFont *)fontDINBold:(CGFloat)fontSize {
    return [UIFont fontWithName:@"DIN-Bold" size:fontSize];
}

- (UIFont *)fontDINLight:(CGFloat)fontSize {
    return [UIFont fontWithName:@"DIN-Light" size:fontSize];
}

- (UIFont *)fontDINMedium:(CGFloat)fontSize {
    return [UIFont fontWithName:@"DIN-Medium" size:fontSize];
}

@end
