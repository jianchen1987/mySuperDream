//
//  HDCouponTicketStoreRspModel.m
//  ViPay
//
//  Created by VanJay on 2019/6/11.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import "HDCouponTicketStoreRspModel.h"


@implementation HDCouponTicketStoreRspModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"storeList": HDCouponTicketStoreModel.class,
    };
}
@end
