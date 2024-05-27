//
//  HDTradePreferentialModel.m
//  SuperApp
//
//  Created by VanJay on 2019/5/16.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import "HDTradePreferentialModel.h"


@implementation HDTradePreferentialModel
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

    //    _descSymbol = [PNCommonUtils getCurrencySymbolByCode:desc];
}

- (BOOL)isCommonCoupon {
    //    switch (self.type) {
    //        case HDTradePreferentialTypeCashBack:  // 返现
    //        case HDTradePreferentialTypeDiscount:  // 折扣
    //        case HDTradePreferentialTypeMinus:     // 立减
    //            return YES;
    //
    //        default:
    //            return NO;
    //            break;
    //    }
    return NO;
}

- (BOOL)isCouponTicket {
    //    switch (self.type) {
    //        case HDTradePreferentialTypeDiscountTicket:  // 折扣券
    //        case HDTradePreferentialTypeFullReduction:   // 满减券
    //            return YES;
    //            break;
    //
    //        default:
    //            return NO;
    //            break;
    //    }
    return NO;
}

//- (void)setType:(HDTradePreferentialType)type {
//    _type = type;
//
//    switch (type) {
//        case HDTradePreferentialTypeCashBack:
//            _typeDescForTrack = @"返现";
//            _typeDesc = SALocalizedString(@"coupon_type_desc_cash_back", @"返现", nil);
//            break;
//
//        case HDTradePreferentialTypeMinus:
//            _typeDescForTrack = @"立减";
//            _typeDesc = SALocalizedString(@"coupon_type_desc_minus", @"立减", nil);
//            break;
//
//        case HDTradePreferentialTypeDiscount:
//            _typeDescForTrack = @"折扣";
//            _typeDesc = SALocalizedString(@"coupon_type_desc_discount", @"折扣", nil);
//            break;
//
//        case HDTradePreferentialTypeDiscountTicket:
//            _typeDescForTrack = @"折扣券";
//            _typeDesc = SALocalizedString(@"checkStand_coupons", @"优惠券", nil);
//            break;
//
//        case HDTradePreferentialTypeFullReduction:
//            _typeDescForTrack = @"满减券";
//            _typeDesc = SALocalizedString(@"checkStand_coupons", @"优惠券", nil);
//            break;
//
//        default:
//            _typeDesc = SALocalizedString(@"checkStand_coupon", @"优惠", nil);
//            break;
//    }
//}
@end
