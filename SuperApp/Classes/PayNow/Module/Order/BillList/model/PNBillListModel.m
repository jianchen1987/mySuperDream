//
//  HDBillListModel.m
//  customer
//
//  Created by 陈剑 on 2018/8/9.
//  Copyright © 2018年 chaos network technology. All rights reserved.
//

#import "PNBillListModel.h"


@implementation PNBillListModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"productDesc": @[@"description"]};
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"couponList": PayHDCouponModel.class};
}

@end
