//
//  WMOrderSubmitCouponRspModel.m
//  SuperApp
//
//  Created by VanJay on 2020/5/16.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMOrderSubmitCouponRspModel.h"


@implementation WMOrderSubmitCouponRspModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"list": WMOrderSubmitCouponModel.class,
    };
}
@end
