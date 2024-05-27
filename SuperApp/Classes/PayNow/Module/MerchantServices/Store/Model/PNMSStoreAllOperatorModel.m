//
//  PNMSStoreAllOperatorModel.m
//  SuperApp
//
//  Created by xixi_wen on 2022/12/3.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNMSStoreAllOperatorModel.h"


@implementation PNMSStoreAllOperatorModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
        @"storeId": @"id",
        @"operatorArray": @"operator",
    };
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"operatorArray": PNMSStoreOperatorInfoModel.class,
    };
}

@end
