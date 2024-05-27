//
//  PayHDTradePreferentialModel.m
//  customer
//
//  Created by VanJay on 2019/5/16.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import "PayHDTradePreferentialModel.h"
#import "PNCommonUtils.h"
#import "PNUtilMacro.h"


@implementation PayHDTradePreferentialModel
- (instancetype)init {
    self = [super init];
    if (self) {
        self.gradientLayerWidth = kRealWidth(110);
        self.numbersOfLineOfTitle = 0;
        self.numbersOfLineOfDate = 0;
    }
    return self;
}

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"number": @"no"};
}

- (void)setDesc:(NSString *)desc {
    _desc = desc;

    _descSymbol = [PNCommonUtils getCurrencySymbolByCode:desc];
}

- (BOOL)isCommonCoupon {
    switch (self.type) {
        case PNTradePreferentialTypeCashBack: // 返现
        case PNTradePreferentialTypeDiscount: // 折扣
        case PNTradePreferentialTypeMinus:    // 立减
            return YES;

        default:
            return NO;
            break;
    }
    return NO;
}

- (BOOL)isCouponTicket {
    switch (self.type) {
        case PNTradePreferentialTypeDiscountTicket: // 折扣券
        case PNTradePreferentialTypeFullReduction:  // 满减券
            return YES;
            break;

        default:
            return NO;
            break;
    }
    return NO;
}

- (void)setType:(PNTradePreferentialType)type {
    _type = type;

    switch (type) {
        case PNTradePreferentialTypeCashBack:
            _typeDescForTrack = @"返现";
            _typeDesc = PNLocalizedString(@"coupon_type_desc_cash_back", @"返现");
            break;

        case PNTradePreferentialTypeMinus:
            _typeDescForTrack = @"立减";
            _typeDesc = PNLocalizedString(@"coupon_type_desc_minus", @"立减");
            break;

        case PNTradePreferentialTypeDiscount:
            _typeDescForTrack = @"折扣";
            _typeDesc = PNLocalizedString(@"coupon_type_desc_discount", @"折扣");
            break;

        case PNTradePreferentialTypeDiscountTicket:
            _typeDescForTrack = @"折扣券";
            _typeDesc = PNLocalizedString(@"checkStand_coupons", @"优惠券");
            break;

        case PNTradePreferentialTypeFullReduction:
            _typeDescForTrack = @"满减券";
            _typeDesc = PNLocalizedString(@"checkStand_coupons", @"优惠券");
            break;

        default:
            _typeDesc = PNLocalizedString(@"checkStand_coupon", @"优惠");
            break;
    }
}
@end
