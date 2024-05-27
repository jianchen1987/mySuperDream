//
//  WMStoreActivityMdoel.m
//  SuperApp
//
//  Created by wmz on 2023/6/21.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "WMStoreActivityMdoel.h"

@implementation WMStoreActivityMdoel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"deliveryFeeItems": WMShareDeliveryFeeItems.class,
        @"storeCouponItems": WMShareStoreCouponItems.class,
        @"fullReductionItems": WMShareFullReductionItems.class,
        @"productDiscountItems": WMShareProductDiscountItems.class,
        @"bestSaleItems": WMShareProductDiscountItems.class,
        @"storeFirstItems": WMShareFirstItems.class,
    };
}
@end

@implementation WMShareDeliveryFeeItems

@end

@implementation WMShareStoreCouponItems

@end

@implementation WMShareFullReductionItems

@end

@implementation WMShareProductDiscountItems

@end

@implementation WMShareFirstItems

@end

