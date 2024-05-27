//
//  PNMSStoreOperatorInfoModel.m
//  SuperApp
//
//  Created by xixi_wen on 2022/11/25.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNMSStoreOperatorInfoModel.h"


@implementation PNMSStoreOperatorInfoModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
        @"role": @"role.code",
        @"roleStr": @"role.message",
        @"storeOperatorId": @"id",
    };
}
@end
