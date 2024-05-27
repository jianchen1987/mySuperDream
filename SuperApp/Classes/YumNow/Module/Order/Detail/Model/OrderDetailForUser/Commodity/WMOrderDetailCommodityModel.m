//
//  WMOrderDetailCommodityModel.m
//  SuperApp
//
//  Created by VanJay on 2020/6/27.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMOrderDetailCommodityModel.h"


@implementation WMOrderDetailCommodityModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"commodityList": WMOrderDetailProductModel.class,
        @"giftList": WMStoreFillGiftRuleModel.class,
    };
}
@end
