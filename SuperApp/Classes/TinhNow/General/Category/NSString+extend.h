//
//  NSString+extend.h
//  SuperApp
//
//  Created by xixi on 2021/3/31.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@interface NSString (extend)

/// 高亮字体
/// @param lightString 高亮字体
/// @param longString 整段文字
/// @param lightFont 高亮字体的 font
/// @param lightColor 高亮字体的 color
/// 举个栗子： longString = @"我是wownow" , lightString = "wownow"
+ (NSMutableAttributedString *)highLightString:(NSString *)lightString inLongString:(NSString *)longString font:(UIFont *)lightFont color:(UIColor *)lightColor;
/// 高亮字体
/// @param lightString 高亮字体
/// @param longString 整段文字
/// @param lightFont 高亮字体的 font
/// @param lightColor 高亮字体的 color
/// @param norFont 原字体的 font
/// @param norColor 原字体的 color
/// 举个栗子： longString = @"我是wownow" , lightString = "wownow"
+ (NSMutableAttributedString *)highLightString:(NSString *)lightString
                                  inLongString:(NSString *)longString
                                          font:(UIFont *)lightFont
                                         color:(UIColor *)lightColor
                                       norFont:(UIFont *)norFont
                                      norColor:(UIColor *)norColor;
/// 改变字体大小
/// @param fontString 需要改变的文本
/// @param font 字体
- (NSMutableAttributedString *)changeFontString:(NSString *)fontString font:(UIFont *)font;

/// 过滤掉 柬埔寨号码 的855 区号
- (NSString *)filterCambodiaPhoneNum;

/// 字符串 补齐小数点位数
- (NSString *)stringCompletionPointZero:(NSInteger)count;
/// 生成随机字符串
/// @param len 随机字符串位数
+ (NSString *)randonStringWithLength:(NSInteger)len;
@end

NS_ASSUME_NONNULL_END
