//
//  GNTools.m
//  SuperApp
//
//  Created by wmz on 2021/6/24.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "GNStringUntils.h"


@implementation GNStringUntils

+ (NSString *)componentNum:(NSInteger)num string:(NSString *)string {
    if (!string)
        return @"";
    if (num <= 0 || (string.length < num))
        return string;
    NSString *tempStr = string;
    NSInteger size = (tempStr.length / num);
    NSMutableArray *tmpStrArr = [[NSMutableArray alloc] init];
    for (int n = 0; n < size; n++) {
        [tmpStrArr addObject:[tempStr substringWithRange:NSMakeRange(n * num, num)]];
    }
    [tmpStrArr addObject:[tempStr substringWithRange:NSMakeRange(size * num, (tempStr.length % num))]];
    tempStr = [tmpStrArr componentsJoinedByString:@" "];
    return tempStr;
}

+ (void)attributedString:(nonnull NSMutableAttributedString *)str color:(nullable UIColor *)textColor colorRange:(nullable NSString *)colorRange {
    [GNStringUntils attributedString:str color:textColor colorRange:colorRange font:nil fontRange:nil];
}

+ (void)attributedString:(nonnull NSMutableAttributedString *)str font:(nullable UIFont *)font fontRange:(nullable NSString *)fontRange {
    [GNStringUntils attributedString:str color:nil colorRange:nil font:font fontRange:fontRange];
}

+ (void)attributedString:(nonnull NSMutableAttributedString *)str center:(BOOL)center colorRange:(nullable NSString *)lineRange {
    if (!str || ![str isKindOfClass:NSMutableAttributedString.class])
        return;
    if (lineRange) {
        NSRange range = [str.string rangeOfString:lineRange];
        if (range.location != NSNotFound) {
            if (center) {
                [str addAttribute:NSStrikethroughStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:range];
            } else {
                [str addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:range];
            }
        }
    }
}

+ (void)attributedString:(nonnull NSMutableAttributedString *)str
                   color:(nullable UIColor *)textColor
              colorRange:(nullable NSString *)colorRange
                    font:(nullable UIFont *)font
               fontRange:(nullable NSString *)fontRange {
    if (!str || ![str isKindOfClass:NSMutableAttributedString.class])
        return;
    if (textColor && colorRange) {
        NSRange range = [str.string rangeOfString:colorRange];
        if (range.location != NSNotFound) {
            [str addAttribute:NSForegroundColorAttributeName value:textColor range:range];
        }
    }
    if (font && fontRange) {
        NSRange range = [str.string rangeOfString:fontRange];
        if (range.location != NSNotFound) {
            [str addAttribute:NSFontAttributeName value:font range:range];
        }
    }
}

+ (void)attributedString:(nonnull NSMutableAttributedString *)str lineSpacing:(CGFloat)lineSpacing colorRange:(nullable NSString *)colorRange {
    if (!str || ![str isKindOfClass:NSMutableAttributedString.class])
        return;
    if (lineSpacing && colorRange) {
        NSRange range = [str.string rangeOfString:colorRange];
        if (range.location != NSNotFound) {
            NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
            paragraphStyle.lineSpacing = lineSpacing;
            [str addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:range];
        }
    }
}

+ (NSString *)removeSuffix:(NSString *)numberStr {
    if (numberStr.length > 1) {
        if ([numberStr componentsSeparatedByString:@"."].count == 2) {
            NSString *last = [numberStr componentsSeparatedByString:@"."].lastObject;
            if ([last isEqualToString:@"00"]) {
                numberStr = [numberStr substringToIndex:numberStr.length - (last.length + 1)];
                return numberStr;
            } else {
                if ([[last substringFromIndex:last.length - 1] isEqualToString:@"0"]) {
                    numberStr = [numberStr substringToIndex:numberStr.length - 1];
                    return numberStr;
                }
            }
        }
    }
    return numberStr;
}

///判断元素是否相同
+ (BOOL)array:(NSArray *)array1 isEqualTo:(NSArray *)array2 {
    if (array1.count != array2.count)
        return NO;
    for (int i = 0; i < array1.count; i++) {
        if (![array1[i] isEqual:array2[i]])
            return NO;
    }
    return YES;
}

+ (void)addSeeMoreButton:(YYLabel *)label
                    more:(NSString *)more
               moreColor:(UIColor *)moreColor
                  before:(nullable NSString *)before
               tapAction:(void (^)(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect))tapAction {
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@", before ? before : @"", more ? more : @""]];
    if (tapAction) {
        YYTextHighlight *hi = [YYTextHighlight new];
        [hi setColor:label.textColor];
        hi.tapAction = tapAction;
        [text yy_setTextHighlight:hi range:[text.string rangeOfString:more]];
    }
    [text yy_setColor:moreColor range:[text.string rangeOfString:more]];
    text.yy_font = label.font;
    YYLabel *seeMore = YYLabel.new;
    seeMore.attributedText = text;
    [seeMore sizeToFit];
    NSMutableAttributedString *truncationToken = [NSMutableAttributedString yy_attachmentStringWithContent:seeMore contentMode:UIViewContentModeCenter attachmentSize:seeMore.frame.size
                                                                                               alignToFont:text.yy_font
                                                                                                 alignment:YYTextVerticalAlignmentCenter];
    label.truncationToken = truncationToken;
}

+ (void)changeLineSpaceForLabel:(UILabel *)label WithSpace:(float)space {
    NSString *labelText = label.text;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:labelText];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:space];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [labelText length])];
    label.attributedText = attributedString;
    [label sizeToFit];
}

+ (void)changeWordSpaceForLabel:(UILabel *)label WithSpace:(float)space {
    NSString *labelText = label.text;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:labelText attributes:@{NSKernAttributeName: @(space)}];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [labelText length])];
    label.attributedText = attributedString;
    [label sizeToFit];
}

+ (void)changeSpaceForLabel:(UILabel *)label withLineSpace:(float)lineSpace WordSpace:(float)wordSpace {
    NSString *labelText = label.text;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:labelText attributes:@{NSKernAttributeName: @(wordSpace)}];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:lineSpace];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [labelText length])];
    label.attributedText = attributedString;
    [label sizeToFit];
}

@end
