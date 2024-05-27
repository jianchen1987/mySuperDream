//
//  WMOrderDetailPromotionModel.m
//  SuperApp
//
//  Created by VanJay on 2020/5/19.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMOrderDetailPromotionModel.h"


@implementation WMOrderDetailPromotionModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"fullReductionRules": WMPromotionReductionRule.class,
        @"triggerRule": WMPromotionReductionRule.class,
    };
}

- (void)setProportion:(NSNumber *)proportion {
    _proportion = proportion;
    if (proportion.doubleValue <= 0) {
        return;
    }
    NSNumber *discountRatioCent = [NSNumber numberWithDouble:(100 - proportion.doubleValue) / 10.0];
    if (discountRatioCent.integerValue != discountRatioCent.doubleValue) {
        // 判断小数位数
        NSString *stringValue = discountRatioCent.stringValue;
        if ([stringValue rangeOfString:@"."].location != NSNotFound) {
            NSArray<NSString *> *subStrArr = [stringValue componentsSeparatedByString:@"."];
            if (subStrArr.count >= 1) {
                NSString *pointStr = subStrArr[1];
                if (pointStr.length == 1) {
                    _discountRadioStr = [NSString stringWithFormat:@"%.1f", discountRatioCent.doubleValue];
                } else {
                    // 最多两位
                    _discountRadioStr = [NSString stringWithFormat:@"%.2f", discountRatioCent.doubleValue];
                }
            } else {
                _discountRadioStr = [NSString stringWithFormat:@"%zd", discountRatioCent.integerValue];
            }
        }
    } else {
        _discountRadioStr = [NSString stringWithFormat:@"%zd", discountRatioCent.integerValue];
    }
}

- (void)setDiscountRatio:(NSNumber *)discountRatio {
    _discountRatio = discountRatio;
    if (discountRatio.floatValue <= 0) {
        return;
    }
    NSNumber *discountRatioCent = [NSNumber numberWithDouble:(100 - discountRatio.doubleValue) / 10.0];
    if (discountRatioCent.integerValue != discountRatioCent.doubleValue) {
        // 判断小数位数
        NSString *stringValue = discountRatioCent.stringValue;
        if ([stringValue rangeOfString:@"."].location != NSNotFound) {
            NSArray<NSString *> *subStrArr = [stringValue componentsSeparatedByString:@"."];
            if (subStrArr.count >= 1) {
                NSString *pointStr = subStrArr[1];
                if (pointStr.length == 1) {
                    _discountRadioStr = [NSString stringWithFormat:@"%.1f", discountRatioCent.doubleValue];
                } else {
                    // 最多两位
                    _discountRadioStr = [NSString stringWithFormat:@"%.2f", discountRatioCent.doubleValue];
                }
            } else {
                _discountRadioStr = [NSString stringWithFormat:@"%zd", discountRatioCent.integerValue];
            }
        }
    } else {
        _discountRadioStr = [NSString stringWithFormat:@"%zd", discountRatioCent.integerValue];
    }
}

- (NSString *)promotionDesc {
    NSString *desc = @"";
    switch (self.marketingType) {
        case WMStorePromotionMarketingTypeDiscount: {
            if (self.discountAmt.cent.doubleValue > 0) {
                if (WMMultiLanguageManager.isCurrentLanguageCN) {
                    desc = [NSString stringWithFormat:WMLocalizedString(@"store_discount", @"%@折"), self.discountRadioStr];
                } else {
                    desc = [NSString stringWithFormat:WMLocalizedString(@"store_discount", @"%.0f%%off"), self.proportion.doubleValue];
                }
            }
        } break;

        case WMStorePromotionMarketingTypeLabber:
        case WMStorePromotionMarketingTypeStoreLabber:
        case WMStorePromotionMarketingTypeCoupon: {
            __block NSMutableString *ladderRules = [NSMutableString string];

            WMPromotionReductionRule *currentTriggerRule = self.triggerRule;
            NSString *thresholdAmtStr = currentTriggerRule.thresholdAmt.thousandSeparatorAmount;
            NSString *discountAmtStr = currentTriggerRule.discountAmt.thousandSeparatorAmount;
            NSString *labber;
            labber = [NSString stringWithFormat:WMLocalizedString(@"store_money_off_content", @"满%@减%@ "), thresholdAmtStr, discountAmtStr];
            if (labber.length) {
                [ladderRules appendString:labber];
            }
            desc = ladderRules;
        } break;
        case WMStorePromotionMarketingTypeDelievry:
            desc = WMLocalizedString(@"free_delivery", @"Free delivery");
            break;
        case WMStorePromotionMarketingTypeFirst:
            desc = [NSString stringWithFormat:WMLocalizedString(@"off_first_order", @"%@ Off 1st Order"), self.discountAmt.thousandSeparatorAmount];
            break;
        default:
            break;
    }
    return desc;
}
@end
