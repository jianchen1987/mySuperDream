//
//  PNBillPaymentRspModel.m
//  SuperApp
//
//  Created by 张杰 on 2022/12/29.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNBillPaymentRspModel.h"


@implementation PNBillPaymentRspModel
+ (NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass {
    return @{@"list": [PNBillPaymentItemModel class]};
}
@end


@implementation PNBillPaymentItemModel

+ (NSDictionary<NSString *, id> *)modelCustomPropertyMapper {
    return @{@"ID": @"id"};
}

@end
