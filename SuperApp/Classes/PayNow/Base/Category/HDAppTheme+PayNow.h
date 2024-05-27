//
//  HDAppTheme+PayNow.h
//  SuperApp
//
//  Created by xixi_wen on 2021/12/20.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import <HDUIKit/HDUIKit.h>

NS_ASSUME_NONNULL_BEGIN


@interface PNAppThemeColor : NSObject
/// 背景颜色 F3F4FA
- (UIColor *)backgroundColor;
- (UIColor *)cF6F6F6;
- (UIColor *)cC4C5C8;
- (UIColor *)cC6C8CC;
- (UIColor *)c9599A2;
- (UIColor *)cFC2040;
- (UIColor *)cFD7127;
- (UIColor *)c2A251F;
- (UIColor *)cF8F8F8;
- (UIColor *)c000000;
- (UIColor *)cFFFFFF;
- (UIColor *)c333333;
- (UIColor *)cCCCCCC;
- (UIColor *)c999999;
- (UIColor *)c343B4D;
- (UIColor *)cADB6C8;
- (UIColor *)c666666;
- (UIColor *)cECECEC;
- (UIColor *)lineColor;
- (UIColor *)placeholderColor;
- (UIColor *)cD8DBE1;

/** 新的主题色  FC2040 */
- (UIColor *)mainThemeColor;
/** #ff8812 */
- (UIColor *)C1;
/** #ffc95f */
- (UIColor *)C2;
/** #F83E00 */
- (UIColor *)C3;

/** #343b4d */
- (UIColor *)G1;
/** #5d667f */
- (UIColor *)G2;
/** #adb6c8 */
- (UIColor *)G3;
/** #E4E5EA */
- (UIColor *)G4;
/** #f5f7fa */
- (UIColor *)G5;
/** #f8f8fa */
- (UIColor *)G6;
/** #EBEDF0 */
- (UIColor *)G7;
/** FF2323*/
- (UIColor *)R1;
/** #F52138*/
- (UIColor *)R2;
/** #FF9457*/
- (UIColor *)R3;
/** #FF0000*/
- (UIColor *)R4;
@end


@interface PNAppThemeFont : NSObject
- (UIFont *)standard20;
- (UIFont *)standard20B;
- (UIFont *)standard17B;
- (UIFont *)standard17;
- (UIFont *)standard16;
- (UIFont *)standard16M;
- (UIFont *)standard16B;
- (UIFont *)standard15;
- (UIFont *)standard15B;
- (UIFont *)standard14;
- (UIFont *)standard13;
- (UIFont *)standard12;
- (UIFont *)standard12B;
- (UIFont *)standard14B;
- (UIFont *)standard14M;
- (UIFont *)standard18B;
- (UIFont *)standard11;
- (UIFont *)standard15M; //中号字体
- (UIFont *)standard17M; //中号字体
- (UIFont *)standard20M; //中号字体
- (UIFont *)standard12M;

- (UIFont *)fontSemibold:(CGFloat)fontSize;
- (UIFont *)fontRegular:(CGFloat)fontSize;
- (UIFont *)fontMedium:(CGFloat)fontSize;
- (UIFont *)fontBold:(CGFloat)fontSize;

- (UIFont *)nunitoSansRegular:(CGFloat)fontSize;
- (UIFont *)nunitoSansSemiBold:(CGFloat)fontSize;

- (UIFont *)fontDINBlack:(CGFloat)fontSize;
- (UIFont *)fontDINBold:(CGFloat)fontSize;
- (UIFont *)fontDINLight:(CGFloat)fontSize;
- (UIFont *)fontDINMedium:(CGFloat)fontSize;

@end


@interface HDAppTheme (PayNow)

+ (PNAppThemeColor *)PayNowColor;
+ (PNAppThemeFont *)PayNowFont;

@end

NS_ASSUME_NONNULL_END
