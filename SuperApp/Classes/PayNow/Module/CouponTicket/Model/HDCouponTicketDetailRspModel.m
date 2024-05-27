//
//  HDCouponTicketDetailRspModel.m
//  ViPay
//
//  Created by VanJay on 2019/6/11.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import "HDCouponTicketDetailRspModel.h"
#import "PNCommonUtils.h"
#import "PNUtilMacro.h"


@implementation HDCouponTicketDetailRspModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
        @"limitAmountUSD": @[@"limitAmountUsd", @"limitAmountUSD"],
        @"limitAmountKHR": @[@"limitAmountKhr", @"limitAmountKHR"],
        @"thresholdAmountUSD": @[@"thresholdAmountUsd", @"thresholdAmountUSD"],
        @"thresholdAmountKHR": @[@"thresholdAmountKhr", @"thresholdAmountKHR"]
    };
}

- (NSString *)usableCurrencyDesc {
    NSString *desc = @"";
    if (self.currencyType == HDCouponTicketSupportCurrencyTypeUSD) {
        desc = [PNCommonUtils getCurrenceNameByCode:PNCurrencyTypeUSD];
    } else if (self.currencyType == HDCouponTicketSupportCurrencyTypeKHR) {
        desc = [PNCommonUtils getCurrenceNameByCode:PNCurrencyTypeKHR];
    } else if (self.currencyType == HDCouponTicketSupportCurrencyTypeUSDAndKHR) {
        NSMutableString *string = [NSMutableString stringWithString:desc];
        [string appendFormat:@"%@", [PNCommonUtils getCurrenceNameByCode:PNCurrencyTypeUSD]];
        [string appendString:@"/"];
        [string appendFormat:@"%@", [PNCommonUtils getCurrenceNameByCode:PNCurrencyTypeKHR]];
        desc = [string mutableCopy];
    }
    return desc;
}

- (void)setCouponDiscount:(NSNumber *)couponDiscount {
    _couponDiscount = couponDiscount;

    if (couponDiscount.integerValue != couponDiscount.doubleValue) {
        // 判断小数位数
        NSString *stringValue = couponDiscount.stringValue;
        if ([stringValue rangeOfString:@"."].location != NSNotFound) {
            NSArray<NSString *> *subStrArr = [stringValue componentsSeparatedByString:@"."];
            if (subStrArr.count >= 1) {
                NSString *pointStr = subStrArr[1];
                if (pointStr.length == 1) {
                    _discountRadioStr = [NSString stringWithFormat:@"%.1f%%", couponDiscount.doubleValue];
                } else {
                    // 最多两位
                    _discountRadioStr = [NSString stringWithFormat:@"%.2f%%", couponDiscount.doubleValue];
                }
            } else {
                _discountRadioStr = [NSString stringWithFormat:@"%zd%%", couponDiscount.integerValue];
            }
        }
    } else {
        _discountRadioStr = [NSString stringWithFormat:@"%zd%%", couponDiscount.integerValue];
    }
}

- (SAMoneyModel *)thresholdAmount {
    if (self.currencyType == HDCouponTicketSupportCurrencyTypeUSD) {
        return self.thresholdAmountUSD;
    } else if (self.currencyType == HDCouponTicketSupportCurrencyTypeKHR) {
        return self.thresholdAmountKHR;
    }
    return nil;
}

- (SAMoneyModel *)limitAmount {
    if (self.currencyType == HDCouponTicketSupportCurrencyTypeUSD) {
        return self.limitAmountUSD;
    } else if (self.currencyType == HDCouponTicketSupportCurrencyTypeKHR) {
        return self.limitAmountKHR;
    }
    return nil;
}

- (NSString *)couponUsageRule {
    if (self.couponType == PNTradePreferentialTypeDiscountTicket) {
        NSMutableArray<NSString *> *contentStrArr = [NSMutableArray array];
        [contentStrArr addObject:[NSString stringWithFormat:@"%@ %@", PNLocalizedString(@"supported_currency", @"支持货币"), self.usableCurrencyDesc]];
        [contentStrArr addObject:[NSString stringWithFormat:@"%@: %@ Off", PNLocalizedString(@"coupon_rate", @"优惠比例"), self.discountRadioStr]];

        if (self.currencyType == HDCouponTicketSupportCurrencyTypeUSD) {
            if (self.thresholdAmountUSD) {
                [contentStrArr addObject:[NSString stringWithFormat:PNLocalizedString(@"coupon_threshold", @"使用门槛：消费满 xx 可用"),
                                                                    [self.thresholdAmountUSD.thousandSeparatorAmountNoCurrencySymbol
                                                                        stringByAppendingString:[PNCommonUtils getCurrenceNameByCode:self.thresholdAmountUSD.cy]]]];
            } else {
                [contentStrArr addObject:PNLocalizedString(@"coupon_threshold_none", @"使用门槛：无门槛")];
            }

            if (self.limitAmountUSD) {
                [contentStrArr addObject:[NSString stringWithFormat:@"%@：%@%@",
                                                                    PNLocalizedString(@"coupon_max_limit", @"优惠上限"),
                                                                    self.limitAmount.thousandSeparatorAmountNoCurrencySymbol,
                                                                    [PNCommonUtils getCurrenceNameByCode:self.limitAmount.cy]]];
            } else {
                [contentStrArr addObject:[NSString stringWithFormat:@"%@：%@", PNLocalizedString(@"coupon_max_limit", @"优惠上限"), PNLocalizedString(@"coupon_max_limit_none", @"无上限")]];
            }
        } else if (self.currencyType == HDCouponTicketSupportCurrencyTypeKHR) {
            if (self.thresholdAmountKHR) {
                [contentStrArr addObject:[NSString stringWithFormat:PNLocalizedString(@"coupon_threshold", @"使用门槛：消费满 xx 可用"),
                                                                    [self.thresholdAmountKHR.thousandSeparatorAmountNoCurrencySymbol
                                                                        stringByAppendingString:[PNCommonUtils getCurrenceNameByCode:self.thresholdAmountKHR.cy]]]];
            } else {
                [contentStrArr addObject:PNLocalizedString(@"coupon_threshold_none", @"使用门槛：无门槛")];
            }

            if (self.limitAmountKHR) {
                [contentStrArr addObject:[NSString stringWithFormat:@"%@：%@%@",
                                                                    PNLocalizedString(@"coupon_max_limit", @"优惠上限"),
                                                                    self.limitAmountKHR.thousandSeparatorAmountNoCurrencySymbol,
                                                                    [PNCommonUtils getCurrenceNameByCode:self.limitAmountKHR.cy]]];
            } else {
                [contentStrArr addObject:[NSString stringWithFormat:@"%@：%@", PNLocalizedString(@"coupon_max_limit", @"优惠上限"), PNLocalizedString(@"coupon_max_limit_none", @"无上限")]];
            }
        } else if (self.currencyType == HDCouponTicketSupportCurrencyTypeUSDAndKHR) {
            NSMutableString *thresholdStr = [NSMutableString string];
            if (self.thresholdAmountUSD) {
                [thresholdStr appendString:[self.thresholdAmountUSD.thousandSeparatorAmountNoCurrencySymbol stringByAppendingString:[PNCommonUtils getCurrenceNameByCode:self.thresholdAmountUSD.cy]]];
            }
            if (self.thresholdAmountKHR) {
                if (self.thresholdAmountUSD) {
                    [thresholdStr appendString:@"/"];
                }

                [thresholdStr appendString:[self.thresholdAmountKHR.thousandSeparatorAmountNoCurrencySymbol stringByAppendingString:[PNCommonUtils getCurrenceNameByCode:self.thresholdAmountKHR.cy]]];
            }

            if (thresholdStr.length > 0) {
                [contentStrArr addObject:[NSString stringWithFormat:PNLocalizedString(@"coupon_threshold", @"使用门槛：消费满 xx 可用"), thresholdStr]];
            } else {
                [contentStrArr addObject:PNLocalizedString(@"coupon_threshold_none", @"使用门槛：无门槛")];
            }

            NSMutableString *limitStr = [NSMutableString string];
            if (self.limitAmountUSD) {
                [limitStr appendFormat:@"%@%@", self.limitAmountUSD.thousandSeparatorAmountNoCurrencySymbol, [PNCommonUtils getCurrenceNameByCode:self.limitAmountUSD.cy]];
            }
            if (self.limitAmountKHR) {
                if (self.limitAmountUSD) {
                    [limitStr appendString:@"/"];
                }

                [limitStr appendFormat:@"%@%@", self.limitAmountKHR.thousandSeparatorAmountNoCurrencySymbol, [PNCommonUtils getCurrenceNameByCode:self.limitAmountKHR.cy]];
            }

            if (limitStr.length > 0) {
                [contentStrArr addObject:[NSString stringWithFormat:@"%@：%@", PNLocalizedString(@"coupon_max_limit", @"优惠上限"), limitStr]];
            } else {
                [contentStrArr addObject:[NSString stringWithFormat:@"%@：%@", PNLocalizedString(@"coupon_max_limit", @"优惠上限"), PNLocalizedString(@"coupon_max_limit_none", @"无上限")]];
            }
        }

        NSMutableString *string = [NSMutableString string];

        for (short i = 0; i < contentStrArr.count; i++) {
            [string appendFormat:@"%zd.%@", (NSInteger)(i + 1), contentStrArr[i]];
            if (i != contentStrArr.count - 1) {
                [string appendString:@"\n"];
            }
        }

        return string;
    } else if (self.couponType == PNTradePreferentialTypeFullReduction) {
        NSString *thresholdAmount = self.thresholdAmount.thousandSeparatorAmountNoCurrencySymbol;
        NSString *thresholdAmountUnit = [PNCommonUtils getCurrenceNameByCode:self.thresholdAmount.cy];

        NSString *couponAmount = self.couponAmount.thousandSeparatorAmountNoCurrencySymbol;
        NSString *couponAmountUnit = [PNCommonUtils getCurrenceNameByCode:self.couponAmount.cy];

        NSMutableString *string = [NSMutableString string];
        [string appendFormat:@"1.%@ %@\n2.", PNLocalizedString(@"supported_currency", @"支持货币"), self.usableCurrencyDesc];
        [string appendFormat:PNLocalizedString(@"coupon_when_reach", @"消费满 xx 减免 xx"),
                             [thresholdAmount stringByAppendingString:thresholdAmountUnit],
                             [couponAmount stringByAppendingString:couponAmountUnit]];
        return string;
    } else if (self.couponType == PNTradePreferentialTypeCash) {
        NSMutableString *string = [NSMutableString string];
        [string appendFormat:@"1.%@ %@", PNLocalizedString(@"supported_currency", @"支持货币"), self.usableCurrencyDesc];
        [string appendFormat:@"\n2.%@", PNLocalizedString(@"coupon_cash_rule_2", @"使用门槛：无门槛，若消费的订单金额小于面值金额， 不设找零")];

        NSMutableArray<NSString *> *usableSceneArr = [NSMutableArray array];
        if ([self.sceneItem containsObject:PNCouponTicketUsableSceneStorePaying]) {
            [usableSceneArr addObject:PNLocalizedString(@"store_consume", @"到店消费")];
        }
        if ([self.sceneItem containsObject:PNCouponTicketUsableScenePhoneRecharging]) {
            [usableSceneArr addObject:PNLocalizedString(@"PHONE_TITLE_RECHARGE", @"手机充值")];
        }
        [string appendFormat:@"\n3.%@%@", PNLocalizedString(@"coupon_cash_rule_3", @"核销场景："), [usableSceneArr componentsJoinedByString:@"/"]];
        return string;
    }
    return nil;
}
@end
