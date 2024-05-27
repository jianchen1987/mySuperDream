//
//  SAOrderRefundInfoModel.m
//  SuperApp
//
//  Created by Chaos on 2020/7/8.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAOrderRefundInfoModel.h"
#import "SAMoneyModel.h"
#import "SAOrderDetailRefundEventModel.h"


@implementation SAOrderRefundInfoModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"refundEventList": SAOrderDetailRefundEventModel.class,
        @"actualRefundAmount": SAMoneyModel.class,
        @"applyRefundAmount": SAMoneyModel.class,
    };
}

@end
