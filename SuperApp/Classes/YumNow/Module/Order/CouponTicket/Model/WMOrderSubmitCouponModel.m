//
//  WMOrderSubmitCouponModel.m
//  SuperApp
//
//  Created by VanJay on 2020/5/16.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMOrderSubmitCouponModel.h"


@implementation WMOrderSubmitCouponModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
        @"usable": @"use",
        @"desc": @"description",
    };
}

- (void)setUsable:(SABoolValue)usable {
    if ([@[@"1", @"true", @"yes", @"10"] containsObject:usable.lowercaseString]) {
        _usable = SABoolValueTrue;
    } else {
        _usable = SABoolValueFalse;
    }
}

- (void)setChecked:(SABoolValue)checked {
    if ([@[@"1", @"true", @"yes", @"10"] containsObject:checked.lowercaseString]) {
        _checked = SABoolValueTrue;
    } else {
        _checked = SABoolValueFalse;
    }
}

- (NSString *)unavaliableResonStr {
    _unavaliableResonStr = @" ";
    if ([self.unavaliableReson isEqualToString:WMUnUseCouponThreshold]) {
        SAMoneyModel *money = SAMoneyModel.new;
        money.cy = self.thresholdMoney.cy;
        money.cent = @((self.thresholdMoney.cent.doubleValue / 100 - self.amount.doubleValue) * 100).stringValue;
        _unavaliableResonStr = [NSString stringWithFormat:WMLocalizedString(@"wm_usefail_less_reduction", @"商品金额+餐盒费还差%@达到满减门槛"), money.thousandSeparatorAmount];
    } else if ([self.unavaliableReson isEqualToString:WMUnUseCouponAccountRisk]) {
        _unavaliableResonStr = WMLocalizedString(@"wm_usefail_risk_restricted", @"您的账号有风险，限制使用，请联系客服");
    } else if ([self.unavaliableReson isEqualToString:WMUnUseCouponStackVoucher]) {
        _unavaliableResonStr = WMLocalizedString(@"wm_usefail_unusecode_with_good", @"此订单包含优惠商品，不可与优惠券叠加使用");
    } else if ([self.unavaliableReson isEqualToString:WMUnUseCouponEffective]) {
        _unavaliableResonStr = WMLocalizedString(@"wm_usefail_coupon_notintime", @"优惠券未到生效时间");
    } else if ([self.unavaliableReson isEqualToString:WMUnUseCouponStore]) {
        _unavaliableResonStr = WMLocalizedString(@"wm_usefail_cannot_use_thiscoupon", @"该门店不能使用该优惠券");
    } else if ([self.unavaliableReson isEqualToString:WMUnUseCouponStackProCode]) {
        _unavaliableResonStr = WMLocalizedString(@"wm_usefail_unusecode_with_procode", @"此订单已使用优惠码，不可与优惠券叠加使用");
    } else if ([self.unavaliableReson isEqualToString:WMUnUseCouponStackShipping]) {
        _unavaliableResonStr = [NSString stringWithFormat:WMLocalizedString(@"wm_usefail_choose_other", @"本单不可使用%@优惠券，请取消选择后再下单"), self.title];
    } else if ([self.unavaliableReson isEqualToString:WMUnUseCouponStackStoreCoupon]) {
        _unavaliableResonStr = [NSString stringWithFormat:WMLocalizedString(@"wm_usefail_choose_other", @"本单不可使用%@优惠券，请取消选择后再下单"), self.title];
    } else {
        if (self.unavaliableOtherReson) {
            _unavaliableResonStr = self.unavaliableOtherReson.desc;
        }
    }
    return _unavaliableResonStr;
}
@end
