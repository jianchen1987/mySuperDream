//
//  TNProductBatchPriceInfoModel.m
//  SuperApp
//
//  Created by 张杰 on 2022/7/4.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "TNProductBatchPriceInfoModel.h"


@implementation TNPriceRangesModel

@end


@implementation TNProductBatchPriceInfoModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"priceRanges": [TNPriceRangesModel class],
    };
}
@end
