//
//  PNMSStoreOperatorRspModel.m
//  SuperApp
//
//  Created by xixi_wen on 2022/12/2.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNMSStoreOperatorRspModel.h"


@implementation PNMSStoreOperatorRspModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"list": PNMSStoreOperatorInfoModel.class,
    };
}
@end
