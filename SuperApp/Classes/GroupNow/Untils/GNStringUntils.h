//
//  GNTools.h
//  SuperApp
//
//  Created by wmz on 2021/6/24.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <YYText/YYText.h>

NS_ASSUME_NONNULL_BEGIN


@interface GNStringUntils : NSObject
/// 字符串分割方法
///@param num 分割的位数
///@param string 分割的字符串
///@return 分割完的字符串
+ (NSString *)componentNum:(NSInteger)num string:(NSString *)string;

///富文本
///@param str 富文本
///@param textColor 颜色
///@param colorRange 颜色范围
+ (void)attributedString:(nonnull NSMutableAttributedString *)str color:(nullable UIColor *)textColor colorRange:(nullable NSString *)colorRange;

///富文本
///@param str 富文本
///@param font 字体
///@param fontRange  字体范围
+ (void)attributedString:(nonnull NSMutableAttributedString *)str font:(nullable UIFont *)font fontRange:(nullable NSString *)fontRange;

///富文本划线
///@param str 富文本
///@param center 中划线 否则为下划线
///@param lineRange 划线范围
+ (void)attributedString:(nonnull NSMutableAttributedString *)str center:(BOOL)center colorRange:(nullable NSString *)lineRange;

///富文本
///@param str 富文本
///@param textColor 字体颜色
///@param colorRange 字体颜色范围
///@param font 字体
///@param fontRange  字体范围
+ (void)attributedString:(nonnull NSMutableAttributedString *)str
                   color:(nullable UIColor *)textColor
              colorRange:(nullable NSString *)colorRange
                    font:(nullable UIFont *)font
               fontRange:(nullable NSString *)fontRange;

///富文本划线
///@param str 富文本
///@param lineSpacing 行距
///@param colorRange 范围
+ (void)attributedString:(nonnull NSMutableAttributedString *)str lineSpacing:(CGFloat)lineSpacing colorRange:(nullable NSString *)colorRange;

/// 去除多余的0
///@param numberStr 传入的字符串
+ (NSString *)removeSuffix:(NSString *)numberStr;

///判断元素是否相同
+ (BOOL)array:(NSArray *)array1 isEqualTo:(NSArray *)array2;

///末尾添加全文按钮
///@param label label
///@param more 更多的内容
///@param before more前面的文本
///@param moreColor color
///@param tapAction 点击回调
+ (void)addSeeMoreButton:(YYLabel *)label
                    more:(NSString *)more
               moreColor:(UIColor *)moreColor
                  before:(nullable NSString *)before
               tapAction:(void (^)(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect))tapAction;

/// 改变行间距
+ (void)changeLineSpaceForLabel:(UILabel *)label WithSpace:(float)space;

///改变字间距
+ (void)changeWordSpaceForLabel:(UILabel *)label WithSpace:(float)space;

///改变行间距和字间距
+ (void)changeSpaceForLabel:(UILabel *)label withLineSpace:(float)lineSpace WordSpace:(float)wordSpace;

@end

NS_ASSUME_NONNULL_END
