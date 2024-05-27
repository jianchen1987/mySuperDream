//
//  HDQueryPaymentMethodRspModel.m
//  SuperApp
//
//  Created by VanJay on 2020/8/21.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "HDQueryPaymentMethodRspModel.h"


@implementation HDQueryPaymentMethodRspModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"marketings": HDTradePreferentialModel.class,
        @"payWays": HDOnlinePaymentToolsModel.class,
    };
}
@end
