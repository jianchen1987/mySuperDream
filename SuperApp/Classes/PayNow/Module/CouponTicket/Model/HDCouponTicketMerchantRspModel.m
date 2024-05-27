//
//  HDCouponTicketMerchantRspModel.m
//  ViPay
//
//  Created by VanJay on 2019/6/11.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import "HDCouponTicketMerchantRspModel.h"


@implementation HDCouponTicketMerchantRspModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"list": HDCouponTicketMerchantModel.class,
    };
}
@end
