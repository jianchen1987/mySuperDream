//
//  userBillDetailModel.m
//  customer
//
//  Created by 陈剑 on 2018/8/18.
//  Copyright © 2018年 chaos network technology. All rights reserved.
//

#import "HDUserBillDetailRspModel.h"


@implementation HDUserBillDetailRspModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
        @"couponListArr": @"couponList",
        @"productDesc": @"description",
    };
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"couponListArr": PayHDCouponModel.class,
        @"subBizEntity": BizEntityModel.class,
        @"bizEntity": BizEntityModel.class,
    };
}
@end
