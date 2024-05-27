//
//  PayHDTradePaymentMethodModel.m
//  customer
//
//  Created by VanJay on 2019/5/16.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import "PayHDTradePaymentMethodModel.h"


@implementation PayHDTradePaymentMethodModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"number": @"no"};
}

- (void)setType:(NSString *)type {
    _type = type;

    if ([type isEqualToString:@"VIPAY_WALLET_USD"]) {
        _method = PNTradePaymentMethodTypeUSD;
    } else if ([type isEqualToString:@"VIPAY_WALLET_KHR"]) {
        _method = PNTradePaymentMethodTypeKHR;
    } else {
        _method = PNTradePaymentMethodTypeDefault;
    }
}
@end
