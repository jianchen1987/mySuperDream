//
//  NSString+extend.m
//  SuperApp
//
//  Created by xixi on 2021/3/31.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "NSString+extend.h"


@implementation NSString (extend)

+ (NSMutableAttributedString *)highLightString:(NSString *)lightString inLongString:(NSString *)longString font:(UIFont *)lightFont color:(UIColor *)lightColor {
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@", longString]];
    if (!lightFont || !lightColor || !lightString) {
        return attributeString;
    }

    NSRange range = [longString rangeOfString:lightString];
    if (range.location != NSNotFound) {
        [attributeString addAttribute:NSForegroundColorAttributeName value:lightColor range:NSMakeRange(range.location, lightString.length)];

        [attributeString addAttribute:NSFontAttributeName value:lightFont range:NSMakeRange(range.location, lightString.length)];
    }
    return attributeString;
}

+ (NSMutableAttributedString *)highLightString:(NSString *)lightString
                                  inLongString:(NSString *)longString
                                          font:(UIFont *)lightFont
                                         color:(UIColor *)lightColor
                                       norFont:(UIFont *)norFont
                                      norColor:(UIColor *)norColor {
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@", longString]
                                                                                        attributes:@{NSForegroundColorAttributeName: norColor, NSFontAttributeName: norFont}];
    ;
    if (!lightFont || !lightColor || !lightString) {
        return attributeString;
    }
    NSRange range = [longString rangeOfString:lightString];
    if (range.location != NSNotFound) {
        [attributeString addAttribute:NSForegroundColorAttributeName value:lightColor range:NSMakeRange(range.location, lightString.length)];

        [attributeString addAttribute:NSFontAttributeName value:lightFont range:NSMakeRange(range.location, lightString.length)];
    }
    return attributeString;
}
+ (NSString *)randonStringWithLength:(NSInteger)len {
    NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    NSMutableString *randomString = [NSMutableString stringWithCapacity:len];
    for (int i = 0; i < len; i++) {
        [randomString appendFormat:@"%C", [letters characterAtIndex:arc4random_uniform((int)[letters length])]];
    }
    return randomString;
}

- (NSMutableAttributedString *)changeFontString:(NSString *)fontString font:(UIFont *)font {
    if (self == nil || self.length == 0) {
        return nil;
    }
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:self];
    NSRange range = [self rangeOfString:fontString];
    if (range.location != NSNotFound) {
        [attributeString addAttribute:NSFontAttributeName value:font range:NSMakeRange(range.location, fontString.length)];
    }
    return attributeString;
}
- (NSString *)filterCambodiaPhoneNum {
    NSString *phoneNum = self;
    if (!phoneNum || phoneNum.length <= 0) {
        return phoneNum;
    }
    // 号码去空格，否则生成 url 为 nil
    phoneNum = [phoneNum stringByReplacingOccurrencesOfString:@" " withString:@""];
    phoneNum = [phoneNum stringByReplacingOccurrencesOfString:@"<" withString:@""];
    phoneNum = [phoneNum stringByReplacingOccurrencesOfString:@">" withString:@""];
    phoneNum = [phoneNum stringByReplacingOccurrencesOfString:@"(" withString:@""];
    phoneNum = [phoneNum stringByReplacingOccurrencesOfString:@")" withString:@""];
    phoneNum = [phoneNum stringByReplacingOccurrencesOfString:@"+" withString:@""];
    phoneNum = [phoneNum stringByReplacingOccurrencesOfString:@"-" withString:@""];
    if ([phoneNum hasPrefix:@"855"]) {
        phoneNum = [phoneNum substringFromIndex:3];
        if (![phoneNum hasPrefix:@"0"]) {
            // 按需求方要求，去掉855 补0
            phoneNum = [@"0" stringByAppendingString:phoneNum];
        }
    }
    return phoneNum;
}
- (NSString *)stringCompletionPointZero:(NSInteger)count {
    NSString *str = self;
    if (!str || str.length <= 0) {
        return str;
    }
    NSArray *array = [str componentsSeparatedByString:@"."];
    if (array.count > 0) {
        NSString *leftStr = array[0];
        if (array.count == 1) {
            leftStr = [leftStr stringByAppendingString:@"."];
            for (int i = 0; i < count; i++) {
                leftStr = [leftStr stringByAppendingString:@"0"];
            }
            str = leftStr;
        } else if (array.count == 2) {
            NSString *rightStr = array[1];
            if (rightStr.length < count) {
                leftStr = [leftStr stringByAppendingString:@"."];
                for (int i = 0; i < count - rightStr.length; i++) {
                    rightStr = [rightStr stringByAppendingString:@"0"];
                }
                str = [leftStr stringByAppendingString:rightStr];
            }
        }
    }
    return str;
}
@end
