//
//  HDAppTheme+YumNow.h
//  SuperApp
//
//  Created by wmz on 2022/3/2.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "GNStringUntils.h"
#import "WMManage.h"
#import <HDUIKit/HDUIKit.h>

// 字符串设置不为空
#ifndef WMFillEmpty
#define WMFillEmpty(__string) (__string != nil ? __string : @"")
#endif

// 字符串设置不为空
#ifndef WMFillEmptySpace
#define WMFillEmptySpace(__string) (__string != nil ? __string : @" ")
#endif

// 金钱统一处理
#ifndef WMFillMonClearEmpty
#define WMFillMonClearEmpty(__string) (__string != nil ? [GNStringUntils removeSuffix:[NSString stringWithFormat:@"$%0.2f", __string.doubleValue]] : @" ")
#endif

#ifndef WMFillMonEmpty
#define WMFillMonEmpty(__string) (__string != nil ? [NSString stringWithFormat:@"$%0.2f", __string.doubleValue] : @" ")
#endif

NS_ASSUME_NONNULL_BEGIN


@interface WMAppThemeColor : NSObject
/// 000000
- (UIColor *)B0;
/// 333333
- (UIColor *)B3;
/// 666666
- (UIColor *)B6;
/// 999999
- (UIColor *)B9;
/// 3.0背景颜色
- (UIColor *)bg3;
/// F6F6F6
- (UIColor *)F6F6F6;
/// F2F2F2
- (UIColor *)F2F2F2;
/// F5F5F5
- (UIColor *)F5F5F5;
/// F1F1F1
- (UIColor *)F1F1F1;
/// 3.0主题红色
- (UIColor *)mainRed;
///#B1B1B1
- (UIColor *)B1B1B1;
/// lineColor
- (UIColor *)lineColor;
/// lineColor
- (UIColor *)lineColor1;
/// #E9EAEF
- (UIColor *)lineColorE9;
/// ffffff
- (UIColor *)ffffff;
/// FDF8E5
- (UIColor *)FDF8E5;
/// CCCCCC
- (UIColor *)CCCCCC;
/// F3F4FA
- (UIColor *)bgGray;
/// FFFFFF
- (UIColor *)white;

@end


@interface WMAppThemeFont : NSObject
- (UIFont *)standard13;
- (UIFont *)wm_ForSize:(CGFloat)size;
- (UIFont *)wm_thinForSize:(CGFloat)size;
- (UIFont *)wm_boldForSize:(CGFloat)size;
- (UIFont *)wm_ForSize:(CGFloat)size weight:(UIFontWeight)weight;
- (UIFont *)wm_ForSize:(CGFloat)size fontName:(NSString *)fontName;
- (UIFont *)wm_ForMoneyDinSize:(CGFloat)size;
@end


@interface WMAppThemeValue : NSObject
- (CGFloat)Left15;
- (CGFloat)line;
@end


@interface HDAppTheme (YumNow)
+ (WMAppThemeColor *)WMColor;
+ (WMAppThemeFont *)WMFont;
+ (WMAppThemeValue *)WMValue;
@end

NS_ASSUME_NONNULL_END
