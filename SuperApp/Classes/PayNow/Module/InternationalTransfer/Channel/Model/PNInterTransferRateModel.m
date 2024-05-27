//
//  PNInterTransferRateModel.m
//  SuperApp
//
//  Created by xixi_wen on 2022/11/19.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNInterTransferRateModel.h"


@implementation PNInterTransferRateModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"sourceAmt": [PNInterTransferSubRateModel class],
        @"targetAmt": [PNInterTransferSubRateModel class],
    };
}
@end


@implementation PNInterTransferSubRateModel

@end
