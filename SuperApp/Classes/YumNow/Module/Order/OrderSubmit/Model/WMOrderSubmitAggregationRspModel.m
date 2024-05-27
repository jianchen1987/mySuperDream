//
//  WMOrderSubmitAggregationRspModel.m
//  SuperApp
//
//  Created by Chaos on 2021/5/21.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "WMOrderSubmitAggregationRspModel.h"
#import "WMOrderSubmitCouponModel.h"
#import "WMOrderSubmitPromotionModel.h"
#import "WMShoppingCartStoreProduct.h"


@implementation WMOrderSubmitAggregationRspModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
        @"wmTrial": @"YumNowTrial",
    };
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"availablePromotionActivities": WMOrderSubmitPromotionModel.class,
        @"storeShoppingCart": WMShoppingCartStoreProduct.class,
        @"availableCoupons": WMOrderSubmitCouponModel.class,
        @"availableFreightCoupon": WMOrderSubmitCouponModel.class,
    };
}

@end
