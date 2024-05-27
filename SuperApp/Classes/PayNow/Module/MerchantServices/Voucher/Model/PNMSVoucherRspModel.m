//
//  PNMSVoucherRspModel.m
//  SuperApp
//
//  Created by xixi on 2022/12/1.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNMSVoucherRspModel.h"


@implementation PNMSVoucherRspModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"list": PNMSVoucherInfoModel.class,
    };
}
@end
