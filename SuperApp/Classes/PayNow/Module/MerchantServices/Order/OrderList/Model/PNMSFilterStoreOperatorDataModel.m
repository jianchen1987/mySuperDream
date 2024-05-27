//
//  PNMSFilterStoreOperatorDataModel.m
//  SuperApp
//
//  Created by xixi_wen on 2022/11/27.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNMSFilterStoreOperatorDataModel.h"


@implementation PNMSFilterStoreOperatorDataModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"storeList": PNMSStoreInfoModel.class,
        @"operList": PNMSOperatorInfoModel.class,
    };
}

@end
