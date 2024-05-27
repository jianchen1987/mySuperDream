//
//  SAAppTheme.h
//  SuperApp
//
//  Created by VanJay on 2020/7/11.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <HDUIKit/HDUIKit.h>

NS_ASSUME_NONNULL_BEGIN


@interface HDAppThemeColor (SuperApp)
/// 超 A 主色调，#FC2040
@property (nonatomic, strong, readonly) UIColor *sa_C1;
/// #FF777777
@property (nonatomic, strong, readonly) UIColor *sa_C2;
///  标题色 #333333
@property (nonatomic, strong, readonly) UIColor *sa_C333;
/// 辅助色 #666666
@property (nonatomic, strong, readonly) UIColor *sa_C666;
/// 辅助色 #999999
@property (nonatomic, strong, readonly) UIColor *sa_C999;
/// 背景色 #F3F4FA
@property (nonatomic, strong, readonly) UIColor *sa_backgroundColor;
/// 分割线色 #E9EAEF
@property (nonatomic, strong, readonly) UIColor *sa_separatorLineColor;
/// 警告色 #E9605B
@property (nonatomic, strong, readonly) UIColor *sa_warningColor;
/// 搜索框文本色  #CCCCCC
@property (nonatomic, strong, readonly) UIColor *sa_searchBarTextColor;

- (UIColor *)sa_colorWithHexString:(NSString *)hexString;

@end


@interface UIColor (SuperApp)
/// 超 A 主色调，#FC2040
@property (class, strong, readonly) UIColor *sa_C1;
/// #FF777777
@property (class, strong, readonly) UIColor *sa_C2;
///  标题色 #333333
@property (class, strong, readonly) UIColor *sa_C333;
/// 辅助色 #666666
@property (class, strong, readonly) UIColor *sa_C666;
/// 辅助色 #999999
@property (class, strong, readonly) UIColor *sa_C999;
/// 背景色 #F3F4FA
@property (class, strong, readonly) UIColor *sa_backgroundColor;
/// 分割线色 #E9EAEF
@property (class, strong, readonly) UIColor *sa_separatorLineColor;
/// 警告色 #E9605B
@property (class, strong, readonly) UIColor *sa_warningColor;
/// 搜索框文本色  #CCCCCC
@property (class, strong, readonly) UIColor *sa_searchBarTextColor;

@end


@interface HDAppThemeFont (SuperApp)
/// Regular20
- (UIFont *)sa_standard20;
/// Regular16
- (UIFont *)sa_standard16;
/// Regular14
- (UIFont *)sa_standard14;
/// Regular12
- (UIFont *)sa_standard12;
/// Regular11
- (UIFont *)sa_standard11;

/// Medium20
- (UIFont *)sa_standard20M;
/// Medium16
- (UIFont *)sa_standard16M;
/// Medium14
- (UIFont *)sa_standard14M;
/// Medium12
- (UIFont *)sa_standard12M;
/// Medium11
- (UIFont *)sa_standard11M;

/// Semibold20
- (UIFont *)sa_standard20SB;
/// Semibold16
- (UIFont *)sa_standard16SB;
/// Semibold14
- (UIFont *)sa_standard14SB;
/// Semibold12
- (UIFont *)sa_standard12SB;
/// Semibold11
- (UIFont *)sa_standard11SB;

/// Bold20
- (UIFont *)sa_standard20B;
/// Bold16
- (UIFont *)sa_standard16B;
/// Bold14
- (UIFont *)sa_standard14B;
/// Bold12
- (UIFont *)sa_standard12B;
/// Bold11
- (UIFont *)sa_standard11B;

/// Heavy20
- (UIFont *)sa_standard20H;
/// Heavy16
- (UIFont *)sa_standard16H;
/// Heavy14
- (UIFont *)sa_standard14H;
/// Heavy12
- (UIFont *)sa_standard12H;
/// Heavy11
- (UIFont *)sa_standard11H;

/// DIN-Black
- (UIFont *)sa_fontDINBlack:(CGFloat)fontSize;
/// DIN-Bold
- (UIFont *)sa_fontDINBold:(CGFloat)fontSize;
/// DIN-Light
- (UIFont *)sa_fontDINLight:(CGFloat)fontSize;
/// DIN-Medium
- (UIFont *)sa_fontDINMedium:(CGFloat)fontSize;

/// NotoSansKhmerUI
- (UIFont *)sa_fontNotoSansKhmerUI_Bold:(CGFloat)fontSize;

- (UIFont *)sa_fontNotoSansKhmerUI_Regular:(CGFloat)fontSize;

@end

NS_ASSUME_NONNULL_END
