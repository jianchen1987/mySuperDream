//
//  HDTradeCreatePaymentRspModel.m
//  SuperApp
//
//  Created by VanJay on 2019/5/16.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import "HDTradeCreatePaymentRspModel.h"


@implementation HDTradeCreatePaymentRspModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"couponList": HDTradePreferentialModel.class,
        @"methodList": HDOnlinePaymentToolsModel.class,
    };
}
@end
