//
//  SABusinessCouponCountRspModel.m
//  SuperApp
//
//  Created by seeu on 2021/7/31.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "SABusinessCouponCountRspModel.h"


@implementation SABusinessCouponCountModel

@end


@implementation SABusinessCouponCountRspModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"coupon": SABusinessCouponCountModel.class,
    };
}
@end
