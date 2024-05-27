//
//  PNMSVoucherInfoModel.m
//  SuperApp
//
//  Created by xixi_wen on 2022/11/26.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNMSVoucherInfoModel.h"


@implementation PNMSVoucherInfoModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
        @"voucherId": @"id",
    };
}
@end
