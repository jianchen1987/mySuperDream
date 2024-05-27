//
//  PNInterTransferQueryAllRateRspModel.m
//  SuperApp
//
//  Created by xixi_wen on 2022/11/19.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNInterTransferQueryAllRateRspModel.h"


@implementation PNInterTransferQueryAllRateRspModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"alipayRateInfo": [PNInterTransferRateModel class],
        @"wechatRateInfo": [PNInterTransferRateModel class],
    };
}

@end
