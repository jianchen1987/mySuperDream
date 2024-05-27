//
//  WMOrderSubmitPromotionModel.m
//  SuperApp
//
//  Created by VanJay on 2020/5/18.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMOrderSubmitPromotionModel.h"
#import "WMPromotionReductionRule.h"


@interface WMOrderSubmitPromotionModel ()
/// 折扣描述
@property (nonatomic, copy) NSString *discountRadioStr;
@end


@implementation WMOrderSubmitPromotionModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
        @"ladderRules": @"activityLadderFullReductionRespDTOList",
        @"desc": @"description",
    };
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"ladderRules": WMStoreLadderRuleModel.class,
        @"triggerRule": WMStoreLadderRuleModel.class,
    };
}

- (void)setDiscountRatio:(NSNumber *)discountRatio {
    _discountRatio = discountRatio;

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
            if (self.discountAmount.cent.doubleValue > 0) {
                if (WMMultiLanguageManager.isCurrentLanguageCN) {
                    desc = [NSString stringWithFormat:WMLocalizedString(@"store_discount", @"%@折"), self.discountRadioStr];
                } else {
                    desc = [NSString stringWithFormat:WMLocalizedString(@"store_discount", @"%.0f%%off"), self.discountRatio.doubleValue];
                }
            }
        } break;

        case WMStorePromotionMarketingTypeLabber:
        case WMStorePromotionMarketingTypeStoreLabber:
        case WMStorePromotionMarketingTypeCoupon: {
            __block NSMutableString *ladderRules = [NSMutableString string];
            WMStoreLadderRuleModel *currentTriggerRule = self.ladderRules.firstObject;
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
            desc = [NSString stringWithFormat:WMLocalizedString(@"off_first_order", @"%@ Off 1st Order"), self.discountAmount.thousandSeparatorAmount];
            break;
        default:
            break;
    }
    return desc;
}

- (WMStoreLadderRuleModel *)inUseLadderRuleModel {
    if (self.marketingType != WMStorePromotionMarketingTypeLabber && self.marketingType != WMStorePromotionMarketingTypeStoreLabber && self.marketingType != WMStorePromotionMarketingTypeCoupon) {
        return nil;
    }

    if (HDIsArrayEmpty(self.ladderRules))
        return nil;

    return self.ladderRules.firstObject;
}
@end
