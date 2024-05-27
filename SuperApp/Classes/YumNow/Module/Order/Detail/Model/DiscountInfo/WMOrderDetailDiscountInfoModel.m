//
//  WMOrderDetailDiscountInfoModel.m
//  SuperApp
//
//  Created by VanJay on 2020/5/19.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMOrderDetailDiscountInfoModel.h"


@implementation WMOrderDetailDiscountInfoModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"activityDiscountInfo": WMOrderDetailPromotionModel.class, @"couponDiscountInfo": WMOrderDetailCouponModel.class, @"promotionCodeDiscountInfo": WMOrderDetailPromoCodeModel.class};
}
@end
