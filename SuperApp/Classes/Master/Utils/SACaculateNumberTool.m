//
//  SACaculateNumberTool.m
//  SuperApp
//
//  Created by VanJay on 2020/4/16.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SACaculateNumberTool.h"
#import "GNMultiLanguageManager.h"


@implementation SACaculateNumberTool
static NSNumberFormatter *formater;
static NSDictionary *configDict;

+ (void)initialize {
    if (self == [SACaculateNumberTool class]) {
        formater = [[NSNumberFormatter alloc] init];
        // 可自行扩展
        configDict = @{@"wan": @{@"unit": @"万", @"dividend": @(10000.0)}, @"yi": @{@"unit": @"亿", @"dividend": @(100000000.0)}, @"wanYi": @{@"unit": @"万亿", @"dividend": @(1000000000000.0)}};
    }
}

+ (void)configureFormaterWithRoundingMode:(SANumRoundingMode)roundingMode {
    if (roundingMode == SANumRoundingModeUpAndDown) {
        formater.roundingMode = NSNumberFormatterRoundHalfEven; // 四舍五入
    } else if (roundingMode == SANumRoundingModeOnlyUp) {
        formater.roundingMode = NSNumberFormatterRoundCeiling; // 只入不舍
    } else if (roundingMode == SANumRoundingModeOnlyDown) {
        formater.roundingMode = NSNumberFormatterRoundFloor;    // 只舍不入
    } else {                                                    // 默认
        formater.roundingMode = NSNumberFormatterRoundHalfEven; // 四舍五入
    }
}

+ (NSString *)distanceStringFromNumber:(double)number toFixedCount:(NSInteger)toFixed roundingMode:(SANumRoundingMode)roundingMode {
    NSString *output;

    formater.maximumFractionDigits = toFixed;

    [self configureFormaterWithRoundingMode:roundingMode];

    // 如果要五入恰好传入临界值，则h对该值加1，换单位，避免出现10000万这样情况
    if (formater.roundingMode == NSNumberFormatterRoundHalfEven || formater.roundingMode == NSNumberFormatterRoundCeiling) {
        if (number == 9999 || number == 99999999 || number == 999999999999) {
            number = number + 1;
        }
    }

    if (number <= 0) {
        output = @"0m";
    } else if (number <= 999) {
        formater.maximumFractionDigits = 0;
        output = [NSString stringWithFormat:@"%@m", [formater stringFromNumber:@(number)]];
    } else {
        double value = (double)number / 1000.f;
        output = [NSString stringWithFormat:@"%.1fkm", value];
    }
    return output;
}

/**
 团购计算距离（米到米单位的转换）
 */
+ (NSString *)gnDistanceStringFromNumber:(double)number toFixedCount:(NSInteger)toFixed roundingMode:(SANumRoundingMode)roundingMode {
    NSString *output;

    formater.maximumFractionDigits = toFixed;

    [self configureFormaterWithRoundingMode:roundingMode];

    // 如果要五入恰好传入临界值，则h对该值加1，换单位，避免出现10000万这样情况
    if (formater.roundingMode == NSNumberFormatterRoundHalfEven || formater.roundingMode == NSNumberFormatterRoundCeiling) {
        if (number == 9999 || number == 99999999 || number == 999999999999) {
            number = number + 1;
        }
    }

    if (number <= 0) {
        output = @"0m";
    } else if (number <= 1000) {
        formater.maximumFractionDigits = 0;
        output = [NSString stringWithFormat:@"%@m", [formater stringFromNumber:@(number)]];
    } else if (number > 1000 && number <= 10000) {
        double value = (double)number / 1000.f;
        output = [NSString stringWithFormat:@"%.1fkm", value];
    } else {
        output = @">10km";
    }
    return output;
}

+ (NSString *)stringFromNumber:(double)number toFixedCount:(NSInteger)toFixed roundingMode:(SANumRoundingMode)roundingMode {
    NSString *output;

    formater.maximumFractionDigits = toFixed;

    [self configureFormaterWithRoundingMode:roundingMode];

    // 如果要五入恰好传入临界值，则h对该值加1，换单位，避免出现10000万这样情况
    if (formater.roundingMode == NSNumberFormatterRoundHalfEven || formater.roundingMode == NSNumberFormatterRoundCeiling) {
        if (number == 9999 || number == 99999999 || number == 999999999999) {
            number = number + 1;
        }
    }

    if (number <= 0) {
        output = @"0";
    } else if (number <= 9999) {
        output = [NSString stringWithFormat:@"%@", [formater stringFromNumber:@(number)]];
    } else if (number <= 99999999) { // 9999999
        double value = (double)number / [configDict[@"wan"][@"dividend"] doubleValue];
        output = [NSString stringWithFormat:@"%@%@", [formater stringFromNumber:@(value)], configDict[@"wan"][@"unit"]];
    } else if (number <= 999999999999) { // 999999999999
        double value = (double)number / [configDict[@"yi"][@"dividend"] doubleValue];
        output = [NSString stringWithFormat:@"%@%@", [formater stringFromNumber:@(value)], configDict[@"yi"][@"unit"]];
    } else {
        double value = (double)number / [configDict[@"wanYi"][@"dividend"] doubleValue];
        output = [NSString stringWithFormat:@"%@%@", [formater stringFromNumber:@(value)], configDict[@"wanYi"][@"unit"]];
    }
    return output;
}

/**
 计算特定小数位数

 @param input 输入数字
 @param toFixed 保留小数位数
 @param isRounded 是否四舍五入
 */
//+ (double)roundFloat:(double)input toFixedCount:(NSInteger)toFixed rounded:(BOOL)isRounded {
//
//    double scale = 1;
//    if (toFixed == 0) {
//        scale = 1;
//    } else if (toFixed == 1) {
//        scale = 10;
//    } else if (toFixed == 2) {
//        scale = 100;
//    } else if (toFixed == 3) {
//        scale = 1000;
//    } else if (toFixed == 4) {
//        scale = 10000;
//    }
//    if (isRounded) {
//        return (floorf(input * scale + 0.5)) / scale;
//    } else {
//        return (floorf(input * scale - 0.5)) / scale;
//    }
//}
@end
