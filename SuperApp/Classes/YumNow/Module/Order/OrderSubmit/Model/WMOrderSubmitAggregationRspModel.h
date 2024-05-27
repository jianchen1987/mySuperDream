//
//  WMOrderSubmitAggregationRspModel.h
//  SuperApp
//
//  Created by Chaos on 2021/5/21.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "WMRspModel.h"

NS_ASSUME_NONNULL_BEGIN

@class WMOrderSubmitCalDeliveryFeeRspModel;
@class WMShoppingItemsPayFeeTrialCalRspModel;
@class WMOrderSubmitPromotionModel;
@class WMOrderSubmitPayFeeTrialCalRspModel;
@class WMQueryOrderInfoRspModel;
@class WMShoppingCartStoreProduct;
@class WMPromoCodeRspModel;
@class WMOrderSubmitCouponModel;
@class WMOrderSubmitFullGiftRspModel;


@interface WMOrderSubmitAggregationRspModel : WMRspModel

/// 促销码返回模型
@property (nonatomic, strong) WMPromoCodeRspModel *promoCodeDiscount;
/// 配送费和出餐时间对象
@property (nonatomic, strong) WMOrderSubmitCalDeliveryFeeRspModel *deliveryInfo;
/// 商品试算返回模型
@property (nonatomic, strong) WMShoppingItemsPayFeeTrialCalRspModel *wmTrial;
/// 优惠券列表
@property (nonatomic, strong) NSArray<WMOrderSubmitCouponModel *> *availableCoupons;
/// 运费券列表
@property (nonatomic, strong) NSArray<WMOrderSubmitCouponModel *> *availableFreightCoupon;
/// 可用活动列表
@property (nonatomic, strong) NSArray<WMOrderSubmitPromotionModel *> *availablePromotionActivities;
/// 订单金额试算返回
@property (nonatomic, strong) WMOrderSubmitPayFeeTrialCalRspModel *trial;
/// 配送时间和支付方式等订单信息
@property (nonatomic, strong) WMQueryOrderInfoRspModel *storeInfo;
/// 单个门店购物车项
@property (nonatomic, strong) NSArray<WMShoppingCartStoreProduct *> *storeShoppingCart;
/// 满赠
@property (nonatomic, strong) WMOrderSubmitFullGiftRspModel *fullGiftInfo;

@end

NS_ASSUME_NONNULL_END
