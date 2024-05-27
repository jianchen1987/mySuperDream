//
//  SAGetUserCouponTicketRspModel.m
//  SuperApp
//
//  Created by VanJay on 2020/5/18.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAGetUserCouponTicketRspModel.h"


@implementation SAGetUserCouponTicketRspModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"list": SACouponTicketModel.class,
    };
}
@end
