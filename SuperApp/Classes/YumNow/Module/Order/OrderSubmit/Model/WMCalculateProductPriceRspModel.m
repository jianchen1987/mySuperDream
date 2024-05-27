//
//  WMCalculateProductPriceRspModel.m
//  SuperApp
//
//  Created by VanJay on 2020/7/8.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMCalculateProductPriceRspModel.h"


@implementation WMCalculateProductPriceRspModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"productAndSpecCheckDetailsReqDTOS": WMCalculateProductPriceGoodsItem.class,
    };
}
@end
