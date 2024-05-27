//
//  HDBillListModel.m
//  customer
//
//  Created by 陈剑 on 2018/8/9.
//  Copyright © 2018年 chaos network technology. All rights reserved.
//

#import "HDBillListModel.h"


@implementation HDBillListModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"productDesc": @[@"description"]};
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"couponList": HDCouponModel.class};
}

@end
