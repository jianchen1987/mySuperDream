//
//  PayHDTradeSubmitPreferentialModel.m
//  customer
//
//  Created by VanJay on 2019/5/17.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import "PayHDTradeSubmitPreferentialModel.h"
#import "PNUtilMacro.h"


@implementation PayHDTradeSubmitPreferentialModel

- (void)setType:(PNTradePreferentialType)type {
    _type = type;

    if (type == PNTradePreferentialTypeCashBack) {
        _typeDesc = PNLocalizedString(@"coupon_type_desc_cash_back", @"返现");
    } else if (type == PNTradePreferentialTypeDiscount) {
        _typeDesc = PNLocalizedString(@"coupon_type_desc_discount", @"折扣");
    } else if (type == PNTradePreferentialTypeMinus) {
        _typeDesc = PNLocalizedString(@"coupon_type_desc_minus", @"立减");
    } else if (type == PNTradePreferentialTypeFullReduction || type == PNTradePreferentialTypeDiscountTicket) {
        _typeDesc = PNLocalizedString(@"checkStand_coupons", @"优惠券");
    } else {
        _typeDesc = PNLocalizedString(@"checkStand_coupon", @"优惠");
    }
}
@end
