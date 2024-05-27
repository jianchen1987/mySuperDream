//
//  PNInterTransferRateFeeModel.m
//  SuperApp
//
//  Created by 张杰 on 2022/6/20.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNInterTransferRateFeeModel.h"


@implementation PNInterTransferRateInfoModel

@end


@implementation PNInterTransferFeeRule

@end


@implementation PNInterTransferFeeInfoModel

@end


@implementation PNInterTransferRateFeeModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"feeInfos": [PNInterTransferFeeInfoModel class],
    };
}
@end
