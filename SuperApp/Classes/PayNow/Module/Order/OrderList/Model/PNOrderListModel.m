//
//  PNOrderListModel.m
//  SuperApp
//
//  Created by Quin on 2021/11/18.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "PNOrderListModel.h"


@implementation PNOrderListModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"productDesc": @[@"description"]};
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"couponList": PayHDCouponModel.class,
    };
}

@end
