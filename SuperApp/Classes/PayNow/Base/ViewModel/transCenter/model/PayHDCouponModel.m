//
//  PayHDCouponModel.m
//  customer
//
//  Created by null on 2019/3/8.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import "PayHDCouponModel.h"
#import "PNEnum.h"
#import "PNUtilMacro.h"


@implementation PayHDCouponModel

- (void)setType:(NSNumber *)type {
    _type = type;

    if (type.integerValue == PNTradePreferentialTypeCashBack) {
        _typeDesc = PNLocalizedString(@"coupon_type_desc_cash_back", @"返现");
    } else if (type.integerValue == PNTradePreferentialTypeDiscount) {
        _typeDesc = PNLocalizedString(@"coupon_type_desc_discount", @"折扣");
    } else if (type.integerValue == PNTradePreferentialTypeMinus) {
        _typeDesc = PNLocalizedString(@"coupon_type_desc_minus", @"立减");
    } else if (type.integerValue == PNTradePreferentialTypeFullReduction || type.integerValue == PNTradePreferentialTypeDiscountTicket) {
        _typeDesc = PNLocalizedString(@"checkStand_coupons", @"优惠券");
    } else {
        _typeDesc = PNLocalizedString(@"checkStand_coupon", @"优惠");
    }
}
@end
