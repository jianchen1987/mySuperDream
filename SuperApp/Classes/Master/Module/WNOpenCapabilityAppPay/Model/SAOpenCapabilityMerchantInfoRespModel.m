//
//  SAOpenCapabilityMerchantInfoRespModel.m
//  SuperApp
//
//  Created by seeu on 2021/11/30.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "SAOpenCapabilityMerchantInfoRespModel.h"


@implementation SAOpenCapabilityMerchantInfoRespModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"merchantName": @"firstMerchantName"};
}

@end
