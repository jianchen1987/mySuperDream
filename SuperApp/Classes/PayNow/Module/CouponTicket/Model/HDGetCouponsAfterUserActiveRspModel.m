//
//  HDGetCouponsAfterUserActiveRspModel.m
//  ViPay
//
//  Created by seeu on 2019/6/18.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import "HDGetCouponsAfterUserActiveRspModel.h"


@implementation HDGetCouponsAfterUserActiveRspModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"receivedCouponList": HDCouponTicketModel.class,
    };
}

@end
