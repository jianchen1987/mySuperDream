//
//  HDCouponTicketRspModel.m
//  ViPay
//
//  Created by VanJay on 2019/6/11.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import "HDCouponTicketRspModel.h"


@implementation HDCouponTicketRspModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"list": HDCouponTicketModel.class,
    };
}
@end
