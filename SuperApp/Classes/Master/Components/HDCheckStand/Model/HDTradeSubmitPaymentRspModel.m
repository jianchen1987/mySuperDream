//
//  HDTradeSubmitPaymentRspModel.m
//  SuperApp
//
//  Created by VanJay on 2019/5/16.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import "HDTradeSubmitPaymentRspModel.h"


@implementation HDTradeSubmitPaymentRspModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"desc": @"description"};
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"couponList": HDTradeSubmitPreferentialModel.class,
    };
}
@end
