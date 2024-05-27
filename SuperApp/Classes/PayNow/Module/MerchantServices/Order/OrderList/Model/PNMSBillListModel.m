//
//  PNMSBillListModel.m
//  SuperApp
//
//  Created by xixi_wen on 2022/11/29.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNMSBillListModel.h"


@implementation PNMSBillListModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
        @"productDesc": @[@"description"],
    };
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"couponList": PayHDCouponModel.class,
        @"subBizEntity": BizEntityModel.class,
        @"bizEntity": BizEntityModel.class,
    };
}

@end
