//
//  SAMoneyTools.m
//  SuperApp
//
//  Created by VanJay on 2020/4/22.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAMoneyTools.h"
#import <HDKitCore/HDKitCore.h>


@implementation SAMoneyTools

+ (NSString *)yuanTofen:(NSString *__nonnull)yuan {
    if (HDIsStringEmpty(yuan)) {
        return @"";
    }

    NSDecimalNumberHandler *handle = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundBankers scale:2.0f raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO
                                                                              raiseOnDivideByZero:YES];

    NSDecimalNumber *amount = [NSDecimalNumber decimalNumberWithString:yuan];
    NSDecimalNumber *factoty = [NSDecimalNumber decimalNumberWithString:@"100"];
    NSDecimalNumber *result = [amount decimalNumberByMultiplyingBy:factoty withBehavior:handle];

    return [NSString stringWithFormat:@"%zd", result.integerValue];
}

+ (NSString *)fenToyuan:(NSString *__nonnull)fen {
    if (HDIsStringEmpty(fen)) {
        return @"";
    }

    NSDecimalNumberHandler *handle = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundBankers scale:2.0f raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO
                                                                              raiseOnDivideByZero:YES];

    NSDecimalNumber *amount = [NSDecimalNumber decimalNumberWithString:fen];
    NSDecimalNumber *factoty = [NSDecimalNumber decimalNumberWithString:@"100"];
    NSDecimalNumber *result = [amount decimalNumberByDividingBy:factoty withBehavior:handle];

    NSString *resultStr = [NSString stringWithFormat:@"%0.2f", result.doubleValue];

    // 如果小数点末尾是0需抹掉就解开注释
    /*
    if (resultStr.integerValue == resultStr.doubleValue) {
        resultStr = [NSString stringWithFormat:@"%zd", resultStr.integerValue];
    } else {
        // 判断小数位数
        if ([resultStr rangeOfString:@"."].location != NSNotFound) {
            NSArray<NSString *> *subStrArr = [resultStr componentsSeparatedByString:@"."];
            if (subStrArr.count >= 1) {
                NSString *pointStr = subStrArr[1];
                if (pointStr.length == 1) {
                    resultStr = [NSString stringWithFormat:@"%.1f", resultStr.doubleValue];
                } else {
                    // 最多两位
                    resultStr = [NSString stringWithFormat:@"%.2f", resultStr.doubleValue];
                }
            } else {
                resultStr = [NSString stringWithFormat:@"%zd", resultStr.integerValue];
            }
        }
    }
    */
    return resultStr;
}

+ (NSString *)getCurrencySymbolByCode:(NSString *)code {
    if (HDIsStringNotEmpty(code) && [[code uppercaseString] isEqualToString:@"USD"]) {
        return @"$";
    } else if (HDIsStringNotEmpty(code) && [[code uppercaseString] isEqualToString:@"KHR"]) {
        return @"៛";
    } else if (HDIsStringNotEmpty(code) && [[code uppercaseString] isEqualToString:@"CNY"]) {
        return @"￥";
    } else {
        return @"$";
    }
}

static NSNumberFormatter *_numberFormatter = nil;
+ (NSString *)thousandSeparatorAmountYuan:(NSString *)yuan currencyCode:(NSString *)code {
    if (HDIsObjectNil(_numberFormatter)) {
        _numberFormatter = [NSNumberFormatter new];
        _numberFormatter.locale = [NSLocale localeWithLocaleIdentifier:@"en_US"];
        _numberFormatter.numberStyle = NSNumberFormatterCurrencyStyle;
    }

    _numberFormatter.currencySymbol = [SAMoneyTools getCurrencySymbolByCode:code];

    NSDecimalNumberHandler *hander = nil;
    NSDecimalNumber *result = [NSDecimalNumber decimalNumberWithString:yuan];
    if ([[code uppercaseString] isEqualToString:@"KHR"]) {
        hander = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundBankers scale:0 raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
        _numberFormatter.maximumFractionDigits = 0;
    } else if ([[code uppercaseString] isEqualToString:@"USD"]) {
        hander = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundBankers scale:2 raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
        _numberFormatter.maximumFractionDigits = 2;
    } else if ([[code uppercaseString] isEqualToString:@"CNY"]) {
        hander = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundBankers scale:2 raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
        _numberFormatter.maximumFractionDigits = 2;
    }
    return [_numberFormatter stringFromNumber:[result decimalNumberByRoundingAccordingToBehavior:hander]];
}

+ (NSString *)thousandSeparatorNoCurrencySymbolWithAmountYuan:(NSString *)yuan currencyCode:(NSString *)code {
    NSNumberFormatter *format = [NSNumberFormatter new];
    format.locale = [NSLocale localeWithLocaleIdentifier:@"en_US"];
    format.numberStyle = NSNumberFormatterCurrencyStyle;
    format.currencySymbol = @"";

    NSDecimalNumberHandler *hander = nil;
    NSDecimalNumber *result = [NSDecimalNumber decimalNumberWithString:yuan];
    if ([[code uppercaseString] isEqualToString:@"KHR"]) {
        hander = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundBankers scale:0 raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
        format.maximumFractionDigits = 0;
    } else if ([[code uppercaseString] isEqualToString:@"USD"]) {
        hander = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundBankers scale:2 raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
        format.maximumFractionDigits = 2;
    } else if ([[code uppercaseString] isEqualToString:@"CNY"]) {
        hander = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundBankers scale:2 raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
        format.maximumFractionDigits = 2;
    }
    return [format stringFromNumber:[result decimalNumberByRoundingAccordingToBehavior:hander]];
}

@end
