//
//  WMCouponActivityContentModel.m
//  SuperApp
//
//  Created by wmz on 2022/7/22.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "WMCouponActivityContentModel.h"


@implementation WMCouponActivityContentModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"coupons": WMStoreCouponDetailModel.class,
    };
}
@end
