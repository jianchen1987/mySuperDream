//
//  NSMutableAttributedString+Highlight.m
//  SuperApp
//
//  Created by xixi_wen on 2022/1/8.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "NSMutableAttributedString+Highlight.h"


@implementation NSMutableAttributedString (Highlight)

+ (NSMutableAttributedString *)highLightString:(NSString *)string inWholeString:(NSString *)wholeString highLightFont:(UIFont *)highLightFont highLightColor:(UIColor *)highLightColor {
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@", wholeString]];
    if (!highLightFont || !highLightColor || !string) {
        return attributeString;
    }

    NSRange range = [wholeString rangeOfString:string];
    if (range.location != NSNotFound) {
        [attributeString addAttribute:NSForegroundColorAttributeName value:highLightColor range:NSMakeRange(range.location, string.length)];

        [attributeString addAttribute:NSFontAttributeName value:highLightFont range:NSMakeRange(range.location, string.length)];
    }
    return attributeString;
}

+ (NSMutableAttributedString *)highLightString:(NSString *)string
                                 inWholeString:(NSString *)wholeString
                                 highLightFont:(UIFont *)highLightFont
                                highLightColor:(UIColor *)highLightColor
                                       norFont:(UIFont *)norFont
                                      norColor:(UIColor *)norColor {
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@", wholeString]
                                                                                        attributes:@{NSForegroundColorAttributeName: norColor, NSFontAttributeName: norFont}];
    if (!highLightFont || !highLightColor || !string) {
        return attributeString;
    }

    NSRange range = [wholeString rangeOfString:string];
    if (range.location != NSNotFound) {
        [attributeString addAttribute:NSForegroundColorAttributeName value:highLightColor range:NSMakeRange(range.location, string.length)];

        [attributeString addAttribute:NSFontAttributeName value:highLightFont range:NSMakeRange(range.location, string.length)];
    }
    return attributeString;
}
@end
