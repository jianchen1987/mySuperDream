//
//  PayHDTradeSubmitPaymentRspModel.m
//  customer
//
//  Created by VanJay on 2019/5/16.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import "PayHDTradeSubmitPaymentRspModel.h"


@implementation PayHDTradeSubmitPaymentRspModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"desc": @"description"};
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"couponList": PayHDTradeSubmitPreferentialModel.class,
    };
}
@end
