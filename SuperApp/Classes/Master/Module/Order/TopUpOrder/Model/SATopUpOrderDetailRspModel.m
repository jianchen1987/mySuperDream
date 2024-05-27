//
//  WMTopUpOrderDetailModel.m
//  SuperApp
//
//  Created by Chaos on 2020/6/24.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SATopUpOrderDetailRspModel.h"
#import "SAMoneyModel.h"
#import "SAOrderRefundInfoModel.h"


@implementation SATopUpOrderDetailRspModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"payeeAmt": SAMoneyModel.class,
        @"orderAmt": SAMoneyModel.class,
        @"refundInfo": SAOrderRefundInfoModel.class,
    };
}

@end
