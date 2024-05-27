//
//  GNTheme.h
//  SuperApp
//
//  Created by wmz on 2021/5/28.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "GNStringUntils.h"
#import "HDCommonDefines.h"
#import <HDUIKit/HDUIKit.h>

// 字符串为空
#ifndef GNStringNotEmpty
#define GNStringNotEmpty(__string) (__string != nil && ([__string isKindOfClass:NSString.class]) && (__string.length))
#endif

// 字符串设置不为空
#ifndef GNFillEmpty
#define GNFillEmpty(__string) (__string != nil ? __string : @"")
#endif

// 字符串设置不为空
#ifndef GNFillEmptySpace
#define GNFillEmptySpace(__string) (__string != nil ? __string : @" ")
#endif

// 金钱统一处理
#ifndef GNFillMonEmpty
#define GNFillMonEmpty(__string) (__string != nil ? [NSString stringWithFormat:@"$%0.2f", __string.doubleValue] : @" ")

#endif

NS_ASSUME_NONNULL_BEGIN


@interface HDAppThemeColor (GNTheme)
/// 渐变色
typedef enum : NSInteger {
    GNGradientChangeDirectionLevel,              /// 水平方向渐变
    GNGradientChangeDirectionVertical,           /// 垂直方向渐变
    GNGradientChangeDirectionUpwardDiagonalLine, /// 主对角线方向渐变
    GNGradientChangeDirectionDownDiagonalLine,   /// 副对角线方向渐变
} GNGradientChangeDirection;
/// white
@property (nonatomic, strong, readonly) UIColor *gn_whiteColor;
/// 333333
@property (nonatomic, strong, readonly) UIColor *gn_333Color;
/// 666666
@property (nonatomic, strong, readonly) UIColor *gn_666Color;
/// 999999
@property (nonatomic, strong, readonly) UIColor *gn_999Color;
/// bgColor
@property (nonatomic, strong, readonly) UIColor *gn_mainBgColor;
/// 主题色
@property (nonatomic, strong, readonly) UIColor *gn_mainColor;
/// 红色主题
@property (nonatomic, strong, readonly) UIColor *gn_mainRedColor;
/// 灰色背景
@property (nonatomic, strong, readonly) UIColor *gn_grayBgColor;
/// 线颜色
@property (nonatomic, strong, readonly) UIColor *gn_lineColor;
/// 主题色44透明度
@property (nonatomic, strong, readonly) UIColor *gn_mainColor70;
/// FFFCFC
@property (nonatomic, strong, readonly) UIColor *gn_FFFCFC;
/// C1C1C1
@property (nonatomic, strong, readonly) UIColor *gn_C1C1C1;
/// B6B6B6
@property (nonatomic, strong, readonly) UIColor *gn_B6B6B6;
/// B5B5B5
@property (nonatomic, strong, readonly) UIColor *gn_B5B5B5;
/// 000000
@property (nonatomic, strong, readonly) UIColor *gn_000000;
/// 888888
@property (nonatomic, strong, readonly) UIColor *gn_888888;
/// bbbbbb
@property (nonatomic, strong, readonly) UIColor *gn_BBBBBB;
/// cccccc
@property (nonatomic, strong, readonly) UIColor *gn_cccccc;
/// warn
@property (nonatomic, strong, readonly) UIColor *gn_warn;
/// safe
@property (nonatomic, strong, readonly) UIColor *gn_safe;
/// FDF8E5
@property (nonatomic, strong, readonly) UIColor *gn_tipBg;

/// 渐变色
- (UIImage *)gn_ImageGradientChangeWithSize:(CGSize)size direction:(GNGradientChangeDirection)direction colors:(NSArray *)colors;
- (UIColor *)gn_ColorGradientChangeWithSize:(CGSize)size direction:(GNGradientChangeDirection)direction colors:(NSArray *)colors;
- (UIImage *)gn_ImageGradientChangeWithSize:(CGSize)size direction:(GNGradientChangeDirection)direction startColor:(UIColor *)startcolor endColor:(UIColor *)endColor;
- (UIColor *)gn_ColorGradientChangeWithSize:(CGSize)size direction:(GNGradientChangeDirection)direction startColor:(UIColor *)startcolor endColor:(UIColor *)endColor;
@end


@interface HDAppThemeValue (GNTheme)
/// 左边距
@property (nonatomic, assign, readonly) CGFloat gn_marginL;
/// 上边距
@property (nonatomic, assign, readonly) CGFloat gn_marginT;
/// 间距
@property (nonatomic, assign, readonly) CGFloat gn_offset;
/// 8圆角
@property (nonatomic, assign, readonly) CGFloat gn_radius8;
/// 6圆角
@property (nonatomic, assign, readonly) CGFloat gn_radius6;
/// 4圆角
@property (nonatomic, assign, readonly) CGFloat gn_radius4;
/// 线
@property (nonatomic, assign, readonly) CGFloat gn_line;
/// 1px
@property (nonatomic, assign, readonly) CGFloat gn_border;

@end


@interface HDAppThemeFont (GNTheme)
/// 15号
@property (nonatomic, strong, readonly) UIFont *gn_15;
/// 14号
@property (nonatomic, strong, readonly) UIFont *gn_14;
/// 13号
@property (nonatomic, strong, readonly) UIFont *gn_13;
/// 12号
@property (nonatomic, strong, readonly) UIFont *gn_12;
/// 一级标题
@property (nonatomic, strong, readonly) UIFont *gn1;
/// 二级标题
@property (nonatomic, strong, readonly) UIFont *gn2;
/// 三级标题
@property (nonatomic, strong, readonly) UIFont *gn3;
/// 标准字
@property (nonatomic, strong, readonly) UIFont *gn4;
/// 次要内容
@property (nonatomic, strong, readonly) UIFont *gn5;

- (NSMutableDictionary *)space:(double)space font:(UIFont *)font;
- (UIFont *)gn_ForSize:(CGFloat)size;
- (UIFont *)gn_thinForSize:(CGFloat)size;
- (UIFont *)gn_boldForSize:(CGFloat)size;
- (UIFont *)gn_ForSize:(CGFloat)size weight:(UIFontWeight)weight;
@end

NS_ASSUME_NONNULL_END
