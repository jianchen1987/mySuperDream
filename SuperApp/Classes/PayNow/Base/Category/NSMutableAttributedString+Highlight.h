//
//  NSMutableAttributedString+Highlight.h
//  SuperApp
//
//  Created by xixi_wen on 2022/1/8.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@interface NSMutableAttributedString (Highlight)

/// 高亮字体
/// @param string 需要高亮的字体
/// @param wholeString 高亮字体所在的整体字符串
/// @param highLightFont 高亮字体Font
/// @param highLightColor 高亮字体Color
+ (NSMutableAttributedString *)highLightString:(NSString *)string inWholeString:(NSString *)wholeString highLightFont:(UIFont *)highLightFont highLightColor:(UIColor *)highLightColor;

/// 高亮字体
/// @param string 需要高亮的字体
/// @param wholeString 高亮字体所在的整体字符串
/// @param highLightFont 高亮字体Font
/// @param highLightColor 高亮字体Color
/// @param norFont 默认的Font
/// @param norColor 默认的Color
+ (NSMutableAttributedString *)highLightString:(NSString *)string
                                 inWholeString:(NSString *)wholeString
                                 highLightFont:(UIFont *)highLightFont
                                highLightColor:(UIColor *)highLightColor
                                       norFont:(UIFont *)norFont
                                      norColor:(UIColor *)norColor;
@end

NS_ASSUME_NONNULL_END
