//
//  HDQrCodePaymentResultQueryRsp.m
//  ViPay
//
//  Created by VanJay on 2019/8/5.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import "HDQrCodePaymentResultQueryRsp.h"


@implementation HDQrCodePaymentResultQueryRsp
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"payTypeStr": @"payType"};
}

- (void)setPayTypeStr:(NSString *)payTypeStr {
    _payTypeStr = payTypeStr;

    if ([_payTypeStr isEqualToString:@"VIPAY"]) {
        _payType = PNQrCodePaymentTypeViPay;
    } else if ([_payTypeStr isEqualToString:@"ALIPAY"]) {
        _payType = PNQrCodePaymentTypeAliPay;
    } else if ([_payTypeStr isEqualToString:@"WXPAY"]) {
        _payType = PNQrCodePaymentTypeWXPay;
    } else {
        _payType = PNQrCodePaymentTypeDefault;
    }
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"couponList": HDPaymentCodeCouponModel.class};
}
@end
