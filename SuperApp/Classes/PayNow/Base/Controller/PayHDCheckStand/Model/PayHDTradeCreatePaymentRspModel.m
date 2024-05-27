//
//  PayHDTradeCreatePaymentRspModel.m
//  customer
//
//  Created by VanJay on 2019/5/16.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import "PayHDTradeCreatePaymentRspModel.h"


@implementation PayHDTradeCreatePaymentRspModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"couponList": PayHDTradePreferentialModel.class,
        @"methodList": PayHDTradePaymentMethodModel.class,
    };
}
@end
