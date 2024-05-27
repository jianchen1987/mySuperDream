//
//  WMCouponActivityModel.m
//  SuperApp
//
//  Created by wmz on 2022/7/22.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "WMCouponActivityModel.h"


@implementation WMCouponActivityModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"activityContents": WMCouponActivityContentModel.class,
    };
}
@end
