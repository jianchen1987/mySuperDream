//
//  HDRemoteNotificationModel.m
//  ViPay
//
//  Created by VanJay on 2019/8/9.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import "HDRemoteNotificationModel.h"


@implementation HDRemoteNotificationAPSAlertModel

@end


@implementation HDRemoteNotificationAPSModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"contentAvailable": @"content-available", @"mutableContent": @"mutable-content"};
}

@end


@implementation HDRemoteNotificationModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"couponList": HDPaymentCodeCouponModel.class};
}

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"googleCAE": @"google.c.a.e", @"messageID": @"gcm.message_id"};
}

- (void)setCurrency:(NSString *)currency {
    _currency = currency;

    _orderAmountCurrency = [currency copy];
    _payAmountCurrency = [currency copy];
}
@end
