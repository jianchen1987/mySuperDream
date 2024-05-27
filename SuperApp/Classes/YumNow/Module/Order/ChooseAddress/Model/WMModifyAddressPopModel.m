//
//  WMModifyAddressPopModel.m
//  SuperApp
//
//  Created by wmz on 2022/10/18.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "WMModifyAddressPopModel.h"


@implementation WMModifyAddressPopModel
- (NSString *)paymentMethodStr {
    if (!_paymentMethodStr) {
        if (self.paymentMethod == SAOrderPaymentTypeOnline) {
            _paymentMethodStr = WMLocalizedString(@"order_payment_method_online", @"线上付款");
        } else if (self.paymentMethod == SAOrderPaymentTypeCashOnDelivery) {
            _paymentMethodStr = WMLocalizedString(@"order_payment_method_offline", @"货到付款");
        }
    }
    return _paymentMethodStr;
}
@end
