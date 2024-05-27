//
//  WMShoppingItemsPayFeeTrialCalRspModel.h
//  SuperApp
//
//  Created by VanJay on 2020/5/15.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMRspModel.h"
#import "WMShoppingCartPayFeeCalProductModel.h"
#import "WMStoreDetailPromotionModel.h"
#import "WMStoreStatusModel.h"

NS_ASSUME_NONNULL_BEGIN

/// 订单试算返回
@interface WMShoppingItemsPayFeeTrialCalRspModel : WMRspModel
/// 慢必赔
@property (nonatomic, copy) SABoolValue slowPayMark;
/// 配送费
@property (nonatomic, strong) SAMoneyModel *deliverFee;
/// 减免的配送费
@property (nonatomic, strong) SAMoneyModel *freeDeliveryAmount;
/// 折扣减免的费用
@property (nonatomic, strong) SAMoneyModel *freeDiscountAmount;
/// 满减减免的费用
@property (nonatomic, strong) SAMoneyModel *freeFullReductionAmount;
/// 首单优惠
@property (nonatomic, strong) SAMoneyModel *freeFirstOrderAmount;
/// 商品折扣减价
@property (nonatomic, strong) SAMoneyModel *freeProductDiscountAmount;
/// 爆款商品减价
@property (nonatomic, strong) SAMoneyModel *freeBestSaleDiscountAmount;
/// 打包费
@property (nonatomic, strong) SAMoneyModel *packageFee;
/// 餐盒费
@property (nonatomic, strong) SAMoneyModel *boxFee;
/// 门店打包费
@property (nonatomic, strong) SAMoneyModel *packingFee;
/// 总价
@property (nonatomic, strong) SAMoneyModel *totalAmount;
/// 增值税
@property (nonatomic, strong) SAMoneyModel *vat;
/// 优惠信息
@property (nonatomic, copy) NSArray<WMStoreDetailPromotionModel *> *promotions;
/// 商户号
@property (nonatomic, copy) NSString *merchantNo;
/// 所有商品
@property (nonatomic, copy) NSArray<WMShoppingCartPayFeeCalProductModel *> *products;
/// 门店 id
@property (nonatomic, copy) NSString *storeId;
/// 门店名称
@property (nonatomic, strong) SAInternationalizationModel *storeName;
/// 门店号
@property (nonatomic, copy) NSString *storeNo;
/// 门店状态
@property (nonatomic, strong) WMStoreStatusModel *storeStatus;
/// 税率
@property (nonatomic, copy) NSString *vatRate;
///是否限制叠加现金券
@property (nonatomic, assign) BOOL useVoucherCoupon;
///是否限制叠加运费券
@property (nonatomic, assign) BOOL useShippingCoupon;
///是否限制叠加优惠券
@property (nonatomic, assign) BOOL usePromoCode;
///是否限制叠加配送费活动
@property (nonatomic, assign) BOOL useDeliveryFeeReduce;
///活动号
@property (nonatomic, copy) NSArray *activityNos;
#pragma mark - 绑定属性
/// 原价
@property (nonatomic, strong, readonly) SAMoneyModel *originalPrice;
/// 展示价
@property (nonatomic, strong, readonly) SAMoneyModel *showPrice;
/// 划线价
@property (nonatomic, strong, readonly, nullable) SAMoneyModel *linePrice;
@end

NS_ASSUME_NONNULL_END
