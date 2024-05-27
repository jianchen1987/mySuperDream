//
//  WMOrderDetailDiscountInfoModel.h
//  SuperApp
//
//  Created by VanJay on 2020/5/19.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMModel.h"
#import "WMOrderDetailCouponModel.h"
#import "WMOrderDetailPromotionModel.h"
#import "WMOrderDetailPromoCodeModel.h"

NS_ASSUME_NONNULL_BEGIN

/// 折扣信息
@interface WMOrderDetailDiscountInfoModel : WMModel
/// 活动信息
@property (nonatomic, copy) NSArray<WMOrderDetailPromotionModel *> *activityDiscountInfo;
/// 优惠券信息
@property (nonatomic, copy) NSArray<WMOrderDetailCouponModel *> *couponDiscountInfo;
/// 促销码信息
@property (nonatomic, copy) NSArray<WMOrderDetailPromoCodeModel *> *promotionCodeDiscountInfo;
@end

NS_ASSUME_NONNULL_END
